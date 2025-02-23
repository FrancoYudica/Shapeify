#[compute]
#version 450
#define PI 3.1415926535

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(rgba8, set = 0, binding = 0) uniform restrict readonly image2D read_image;
layout(rgba8, set = 1, binding = 0) uniform restrict writeonly image2D write_image;

layout(push_constant, std430) uniform Params
{
    float threshold;
    float power;
}
params;

void main()
{
    ivec2 size = imageSize(read_image);
    ivec2 coord = ivec2(gl_GlobalInvocationID.xy);

    if (coord.x >= size.x || coord.y >= size.y) {
        return;
    }

    // Sobel kernels
    const int kernel_size = 3;
    const int offset[3] = int[](-1, 0, 1);

    const float Gx[3][3] = float[][](
        float[](-1, 0, 1),
        float[](-2, 0, 2),
        float[](-1, 0, 1));

    const float Gy[3][3] = float[][](
        float[](-1, -2, -1),
        float[](0, 0, 0),
        float[](1, 2, 1));

    float sum_x = 0.0;
    float sum_y = 0.0;

    // Apply kernels
    for (int i = 0; i < kernel_size; i++) {
        for (int j = 0; j < kernel_size; j++) {
            ivec2 sample_coordinate = coord + ivec2(offset[i], offset[j]);
            sample_coordinate = clamp(sample_coordinate, ivec2(0), size - ivec2(1));
            vec4 sampled = imageLoad(read_image, sample_coordinate);
            float intensity = dot(sampled.rgb, vec3(0.299, 0.587, 0.114)); // Grayscale conversion

            sum_x += Gx[i][j] * intensity;
            sum_y += Gy[i][j] * intensity;
        }
    }

    // Compute gradient magnitude
    float magnitude = sqrt(sum_x * sum_x + sum_y * sum_y);
    // Normalize and write to output
    float edge_strength = clamp(magnitude, 0.0, 1.0) * step(params.threshold, magnitude);
    edge_strength = pow(edge_strength, params.power);
    imageStore(write_image, coord, vec4(edge_strength, edge_strength, edge_strength, 1.0));
}