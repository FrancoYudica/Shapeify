#[compute]
#version 450
#extension GL_EXT_shader_atomic_float : enable

// Local invocation settings with 64 local invocations
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params { vec2 texture_size; }
params;

// Buffer to store the MSE result
layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float mse_sum;

    float debug_data[];
}
result_buffer;

// Image bindings
layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba32f, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;

// Variable shared by invocations of the same work group
shared float shared_mse_sum;

void main()
{
    // Get the 2D coordinates of the current invocation
    uint x = gl_GlobalInvocationID.x;
    uint y = gl_GlobalInvocationID.y;

    // Ensure we are within the bounds of the image
    if (x >= params.texture_size.x || y >= params.texture_size.y)
        return;

    // The local invocation of index 0 initializes the `shared_mse_sum` variable
    // to 0
    uint local_index = gl_LocalInvocationIndex;
    if (local_index == 0) {
        shared_mse_sum = 0.0f;
    }

    // Ensures that `shared_mse_sum` is set to 0
    barrier();

    // Sample the target and source textures at the current pixel location
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));

    // Compute the squared difference for each color channel
    vec3 diff = abs(target_pixel.rgb - source_pixel.rgb);
    float squared_diff = dot(diff, diff);

    atomicAdd(shared_mse_sum, squared_diff);

    // Ensures that all invocations added it's values to `shared_mse_sum`
    barrier();

    // Only invocation of index 0 adds to the global buffer
    if (local_index == 0) {
        atomicAdd(result_buffer.mse_sum, shared_mse_sum);
    }
}
