#[compute]
#version 450

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size; // Full texture size
    vec2 sample_size; // Subrect size (width, height)
    vec2 sample_offset; // Subrect offset (x, y)
    float power;
}
params;

layout(set = 0, binding = 0, std430) restrict buffer InputBuffer
{
    float partial_delta_mpa_sums[];
};

layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba32f, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;
layout(rgba32f, set = 3, binding = 0) uniform
    restrict readonly image2D new_source_image;

shared float shared_partial_delta_mpa_sum[gl_WorkGroupSize.x];

float compute_mpa_target_source(uint x, uint y)
{
    vec4 pixel_a = imageLoad(target_image, ivec2(x, y));
    vec4 pixel_b = imageLoad(source_image, ivec2(x, y));

    vec3 diff = abs(pixel_a.rgb - pixel_b.rgb);

    vec3 fitness_color = vec3(1.0f) - clamp(diff, vec3(0.0f), vec3(1.0f));
    fitness_color = pow(fitness_color, vec3(params.power));
    return fitness_color.x + fitness_color.y + fitness_color.z;
}

float compute_mpa_target_new_source(uint x, uint y)
{
    vec4 pixel_a = imageLoad(target_image, ivec2(x, y));
    vec4 pixel_b = imageLoad(new_source_image, ivec2(x, y));

    vec3 diff = abs(pixel_a.rgb - pixel_b.rgb);

    vec3 fitness_color = vec3(1.0f) - clamp(diff, vec3(0.0f), vec3(1.0f));
    fitness_color = pow(fitness_color, vec3(params.power));
    return fitness_color.x + fitness_color.y + fitness_color.z;
}

void main()
{

    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    // Compute total number of pixels in the subrectangle
    uint num_pixels = uint(params.sample_size.x * params.sample_size.y);

    // Initialize shared data
    shared_partial_delta_mpa_sum[local_id] = 0.0;
    barrier();

    // Process pixel if within bounds of the image
    if (global_id < num_pixels) {
        // Map global_id to subrectangle coordinates
        int x = int(global_id) % int(params.sample_size.x) + int(params.sample_offset.x);
        int y = int(global_id) / int(params.sample_size.x) + int(params.sample_offset.y);

        // Ensure coordinates are within the valid texture range
        if (x < params.texture_size.x
            && x >= 0
            && y < params.texture_size.y
            && y >= 0) {
            // Computes the MPA of the two textures
            float mpa_0 = compute_mpa_target_source(x, y);
            float mpa_1 = compute_mpa_target_new_source(x, y);

            float delta_mpa = mpa_1 - mpa_0;

            shared_partial_delta_mpa_sum[local_id] = delta_mpa;
        }
    }

    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_delta_mpa_sum[local_id] += shared_partial_delta_mpa_sum[local_id + stride];
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_delta_mpa_sums[group_id] = shared_partial_delta_mpa_sum[0];
    }
}
