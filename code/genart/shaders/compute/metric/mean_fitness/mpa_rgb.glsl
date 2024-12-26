#[compute]
#version 450

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    float power;
}
params;

layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float partial_mpa_sums[];
};

layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba32f, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;

shared float shared_partial_mpa_sum[gl_WorkGroupSize.x];

float compute_mpa(uint x, uint y)
{
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));

    vec3 diff = abs(target_pixel.rgb - source_pixel.rgb);

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
    shared_partial_mpa_sum[local_id] = 0.0;

    barrier();

    if (global_id < num_pixels) {
        // Map global_id to subrectangle coordinates
        int x = int(global_id) % int(params.texture_size.x);
        int y = int(global_id) / int(params.texture_size.x);

        // Ensure coordinates are within the valid texture range
        if (x < params.texture_size.x
            && x >= 0
            && y < params.texture_size.y
            && y >= 0) {

            shared_partial_mpa_sum[local_id] = compute_mpa(x, y);
        }
    }

    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_mpa_sum[local_id] += shared_partial_mpa_sum[local_id + stride];
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_mpa_sums[group_id] = shared_partial_mpa_sum[0];
    }
}
