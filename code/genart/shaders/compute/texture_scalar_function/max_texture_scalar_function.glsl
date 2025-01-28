#[compute]
#version 450

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    uint num_pixels;
}
params;

layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float partial_max[];
};

layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D sample_image;

shared float shared_partial_max[gl_WorkGroupSize.x];

void main()
{

    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    // Initialize shared data
    shared_partial_max[local_id] = 0.0;

    // Process pixel if within bounds of the image
    if (global_id < params.num_pixels) {
        // Map global_id to image coordinates
        uint x = global_id % uint(params.texture_size.x);
        uint y = global_id / uint(params.texture_size.x);

        // Ensure coordinates are within the valid image range
        vec4 sampled = imageLoad(sample_image, ivec2(x, y));
        shared_partial_max[local_id] = max(sampled.r, max(sampled.g, sampled.b));
    }

    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_max[local_id] = max(shared_partial_max[local_id], shared_partial_max[local_id + stride]);
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_max[group_id] = shared_partial_max[0];
    }
}
