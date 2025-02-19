#[compute]
#version 450

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(rgba8, set = 0, binding = 0) uniform restrict readonly image2D input_image;
layout(rgba8, set = 1, binding = 0) uniform restrict writeonly image2D output_image;

layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    float min_bound;
    float max_bound;
};

void main()
{
    ivec2 global_id = ivec2(gl_GlobalInvocationID.xy);

    // Ensure we're within bounds
    if (global_id.x < int(texture_size.x) && global_id.y < int(texture_size.y)) {
        vec4 sampled = imageLoad(input_image, global_id);

        // Maps the color from [0.0, 1.0] to [min_bound, max_bound]
        vec3 mapped_color = vec3(min_bound) + vec3(max_bound - min_bound) * sampled.rgb;
        imageStore(
            output_image,
            global_id,
            vec4(mapped_color, sampled.a));
    }
}
