#[compute]
#version 450
#extension GL_EXT_shader_atomic_float : enable

// Local invocation settings with 64 local invocations
layout(local_size_x = 4, local_size_y = 4, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params {
  vec2 texture_size;
  vec2 sample_offset;
}
params;

layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer {

  // Sum of all the sampled colors
  vec4 accumulated_colors;

  // Amount of samples, this is later used in CPU to normalize
  // the `accumulated_colors` output and calculate the average
  float total_samples;
}
result_buffer;

// Image bindings
layout(rgba32f, set = 1, binding = 0) uniform
    restrict readonly image2D sample_image;

void main() {
  // Get the 2D coordinates of the current invocation
  int x = int(gl_GlobalInvocationID.x) + int(params.sample_offset.x);
  int y = int(gl_GlobalInvocationID.y) + int(params.sample_offset.y);

  // Ensure we are within the bounds of the image
  if (x >= params.texture_size.x || x < 0 || y >= params.texture_size.y ||
      y < 0)
    return;

  vec4 color = imageLoad(sample_image, ivec2(uint(x), uint(y)));

  // Use atomicAdd to safely accumulate the normalized colors
  atomicAdd(result_buffer.accumulated_colors.r, color.r);
  atomicAdd(result_buffer.accumulated_colors.g, color.g);
  atomicAdd(result_buffer.accumulated_colors.b, color.b);
  atomicAdd(result_buffer.accumulated_colors.a, color.a);

  // Increases the samples counter, later used for normalization
  atomicAdd(result_buffer.total_samples, 1);
}
