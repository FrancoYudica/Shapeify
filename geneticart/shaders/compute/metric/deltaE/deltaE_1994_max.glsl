#[compute]
#version 450
#extension GL_EXT_shader_atomic_float2 : enable
#include "../common/CEILab_common.glslinc"
#include "../common/deltaE.glslinc"
// Local invocation settings with 64 local invocations
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
}
params;

// Buffer to store the MSE result
layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float local_max_delta_e[];
}
result_buffer;

// Image bindings
layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba32f, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;

// Variable shared by invocations of the same work group
shared float local_max_delta_e;

void main()
{
    // Get the 2D coordinates of the current invocation
    uint x = gl_GlobalInvocationID.x;
    uint y = gl_GlobalInvocationID.y;

    // Ensure we are within the bounds of the image
    if (x >= params.texture_size.x || y >= params.texture_size.y)
        return;

    // The local invocation of index 0 initializes the `local_max_delta_e` variable
    // to 0
    uint local_index = gl_LocalInvocationIndex;
    if (local_index == 0) {
        local_max_delta_e = 0.0f;
    }

    // Ensures that `local_max_delta_e` is set to 0
    barrier();

    // Sample the target and source textures at the current pixel location
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));

    // Compute colors in CEILab color space
    vec3 target_lab = rgb2lab(target_pixel.rgb);
    vec3 source_lab = rgb2lab(source_pixel.rgb);

    // Calculates pixel delta e
    float pixel_delta_e = delta_e_1994(target_lab, source_lab);
    atomicMax(local_max_delta_e, pixel_delta_e);

    // Ensures that all invocations added it's values to `local_max_delta_e`
    barrier();

    // Only invocation of index 0 adds to the global buffer
    if (local_index == 0) {
        // For some reason `atomicMax` is breaking on runtime, so I'll be just
        // writing to a global array buffer and then CPU calculates the max across
        // all the work groups max delta e.
        uint globalIndex = gl_GlobalInvocationID.y * 8 + gl_GlobalInvocationID.x;
        result_buffer.local_max_delta_e[globalIndex] = local_max_delta_e;
    }
}
