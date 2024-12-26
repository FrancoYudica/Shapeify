#[compute]
#version 450

// Local invocation settings with 64 local invocations
layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
}
params;

// Buffer to store the MSE result
layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float partial_sums[];
};

// Image bindings
layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba32f, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;

// Variable shared by invocations of the same work group
shared float shared_partial_sums[gl_WorkGroupSize.x];

float compute_mse(uint x, uint y)
{
    // Sample the target and source textures at the current pixel location
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));

    // Compute the squared difference for each color channel
    vec3 diff = abs(target_pixel.rgb - source_pixel.rgb);
    float squared_diff = dot(diff, diff);
    return squared_diff;
}

void main()
{

    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    // Compute total number of pixels in the subrectangle
    uint num_pixels = uint(params.texture_size.x * params.texture_size.y);

    // Initialize shared data
    shared_partial_sums[local_id] = 0.0;

    barrier();

    // Process pixel if within bounds of the image
    if (global_id < num_pixels) {
        // Map global_id to image coordinates
        uint x = global_id % uint(params.texture_size.x);
        uint y = global_id / uint(params.texture_size.x);

        // Ensure coordinates are within the valid image range
        if (y < params.texture_size.y) {
            shared_partial_sums[local_id] = compute_mse(x, y);
        }
    }
    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_sums[local_id] += shared_partial_sums[local_id + stride];
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_sums[group_id] = shared_partial_sums[0];
    }
}
