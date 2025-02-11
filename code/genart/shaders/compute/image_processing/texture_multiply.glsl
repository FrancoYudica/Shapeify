#[compute]
#version 450

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(rgba8, set = 0, binding = 0) uniform restrict readonly image2D a_image;
layout(rgba8, set = 1, binding = 0) uniform restrict readonly image2D b_image;
layout(rgba8, set = 2, binding = 0) uniform restrict writeonly image2D output_image;

layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
}
params;

void main()
{
    ivec2 global_id = ivec2(gl_GlobalInvocationID.xy);

    // Ensure we're within bounds
    if (global_id.x < int(params.texture_size.x) && global_id.y < int(params.texture_size.y)) {

        vec4 a_pixel = imageLoad(a_image, global_id);
        vec4 b_pixel = imageLoad(b_image, global_id);

        imageStore(output_image, global_id, a_pixel * b_pixel);
    }
}
