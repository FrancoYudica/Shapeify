#[compute]
#version 450
#include "../common/CEILab_common.glslinc"
#include "../common/deltaE.glslinc"

// Local invocation settings with 64 local invocations
layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    float power;
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

float compute_mpa_ceilab(uint x, uint y)
{
    // Sample the target and source textures at the current pixel location
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));

    // Compute colors in CEILab color space
    vec3 target_lab = rgb2lab_norm(target_pixel.rgb);
    vec3 source_lab = rgb2lab_norm(source_pixel.rgb);

    vec3 diff = abs(target_lab - source_lab);

    // Clamps all channels to [0.0, 1.0] and inverts, getting the fitness
    vec3 fitness_color = vec3(1.0f) - clamp(diff, vec3(0.0f), vec3(1.0f));

    // Applies power to all channels, punishing those with lower fitness
    fitness_color = pow(fitness_color, vec3(params.power));
    float fitness = fitness_color.x + fitness_color.y + fitness_color.z;
    return fitness;
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

    // Process pixel if within bounds of the subrectangle
    if (global_id < num_pixels) {
        // Map global_id to subrectangle coordinates
        int x = int(global_id) % int(params.texture_size.x);
        int y = int(global_id) / int(params.texture_size.x);

        // Ensure coordinates are within the valid texture range
        if (x < params.texture_size.x
            && x >= 0
            && y < params.texture_size.y
            && y >= 0) {

            shared_partial_sums[local_id] = compute_mpa_ceilab(x, y);
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
