#[compute]
#version 450

layout(local_size_x = 256) in; // Workgroup size

layout(set = 0, binding = 0, std430) buffer SumsOutputBuffer
{
    vec4 partial_sums[]; // Partial sums from each workgroup
};

layout(set = 0, binding = 1, std430) buffer SamplesOutputBuffer
{
    float partial_sample_counts[]; // Partial sums of sample counts
};

// Image bindings
layout(rgba32f, set = 1, binding = 0) uniform restrict readonly image2D sample_image;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size; // Full texture size
    vec2 sample_size; // Subrect size (width, height)
    vec2 sample_offset; // Subrect offset (x, y)
}
params;

shared vec4 shared_data[gl_WorkGroupSize.x];
shared float shared_sample_count[gl_WorkGroupSize.x];

void main()
{
    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    // Compute total number of pixels in the subrectangle
    uint num_pixels = uint(params.sample_size.x * params.sample_size.y);

    // Initialize shared data
    shared_data[local_id] = vec4(0.0);
    shared_sample_count[local_id] = 0.0;

    barrier();

    int sample_count = 0;
    // Process pixel if within bounds of the subrectangle
    if (global_id < num_pixels) {
        // Map global_id to subrectangle coordinates
        int x = int(global_id) % int(params.sample_size.x) + int(params.sample_offset.x);
        int y = int(global_id) / int(params.sample_size.x) + int(params.sample_offset.y);

        // Ensure coordinates are within the valid texture range
        if (x < params.texture_size.x
            && x >= 0
            && y < params.texture_size.y
            && y >= 0) {
            shared_data[local_id] = imageLoad(sample_image, ivec2(uint(x), uint(y)));
            shared_sample_count[local_id] = 1.0;
        }
    }

    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_data[local_id] += shared_data[local_id + stride];
            shared_sample_count[local_id] += shared_sample_count[local_id + stride];
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_sums[group_id] = shared_data[0];
        partial_sample_counts[group_id] = shared_sample_count[0];
    }
}
