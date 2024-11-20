#[compute]
#version 450
#extension GL_EXT_shader_atomic_float : enable

// Local invocation settings with 64 local invocations
layout(local_size_x = 4, local_size_y = 4, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params {
  vec2 texture_size;
  vec2 sample_offset;
  float n; // Normalization factor
}
params;

// Buffer to store the MSE result
layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer {
  vec4 average_color;
}
result_buffer;

// Image bindings
layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D sample_image;

void main() {
  // Get the 2D coordinates of the current invocation
  uint x = gl_GlobalInvocationID.x + uint(params.sample_offset.x);
  uint y = gl_GlobalInvocationID.y + uint(params.sample_offset.y);

  // Ensure we are within the bounds of the image
  if (x >= params.texture_size.x || y >= params.texture_size.y)
    return;

  vec4 color = imageLoad(sample_image, ivec2(x, y));
  vec4 normalized = color * params.n;

  // Use atomicAdd to safely accumulate the normalized colors
  atomicAdd(result_buffer.average_color.r, normalized.r);
  atomicAdd(result_buffer.average_color.g, normalized.g);
  atomicAdd(result_buffer.average_color.b, normalized.b);
  atomicAdd(result_buffer.average_color.a, normalized.a);
}
