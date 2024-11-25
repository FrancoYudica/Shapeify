#[vertex]
#version 450 core
layout(location = 0) in vec3 vertex;
layout(location = 1) in vec2 in_uv;
layout(location = 2) in float rotation;
layout(location = 3) in vec4 in_color;
layout(location = 4) in int in_texture;
layout(location = 5) in float in_id;

layout(location = 0) out vec2 uv;          // Pass UV to the fragment shader
layout(location = 1) out vec4 color;       // Pass COLOR to the fragment shader
layout(location = 2) out int texture_slot; // Pass texture to fragment shader
layout(location = 3) out float id;         // Pass id to fragment shader

// Sets the binding for the buffer
layout(set = 0, binding = 1, std430) restrict buffer MatrixBuffer {
  mat3 projection;
}
matrix_buffer;

void main() {

  // Uses projection matrix to map viewport space to ndc [-1, 1] space
  gl_Position = vec4(matrix_buffer.projection * vertex, 1.0);
  uv = in_uv;
  color = in_color;
  texture_slot = in_texture;
  id = in_id;
}

#[fragment]
#version 450 core
#extension GL_EXT_nonuniform_qualifier : enable

layout(location = 0) in vec2 uv;
layout(location = 1) in vec4 color;
layout(location = 2) flat in int texture_slot;
layout(location = 3) flat in float id;

layout(location = 0) out vec4 frag_color;
layout(location = 1) out float id_output;

layout(binding = 0) uniform sampler2D textures[32];

void main() {

  vec4 c = texture(textures[texture_slot], uv);
  frag_color = c * color;

  // Only outputs id if the sampled texture transparency isn't 0
  id_output = ceil(c.a) * id;
}