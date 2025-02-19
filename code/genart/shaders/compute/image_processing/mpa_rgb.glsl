#[compute]
#version 450

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(rgba8, set = 0, binding = 0) uniform restrict readonly image2D target_image;
layout(rgba8, set = 1, binding = 0) uniform restrict readonly image2D source_image;
layout(rgba8, set = 2, binding = 0) uniform restrict writeonly image2D output_image;

layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    float power;
}
params;

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
    ivec2 global_id = ivec2(gl_GlobalInvocationID.xy);

    // Ensure we're within bounds
    if (global_id.x < int(params.texture_size.x) && global_id.y < int(params.texture_size.y)) {
        float mpa = 1.0f - compute_mpa(global_id.x, global_id.y);
        vec4 output_color = vec4(mpa, mpa, mpa, 1.0);
        imageStore(output_image, global_id, output_color);
    }
}
