#[compute]
#version 450
#define PI 3.1415926535

layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

layout(rgba32f, set = 0, binding = 0) uniform restrict readonly image2D read_image;
layout(rgba32f, set = 1, binding = 0) uniform restrict writeonly image2D write_image;

layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
    vec2 direction;
    float gaussian_sigma;
    float kernel_size;
}
params;

shared float weights[32]; // Precompute Gaussian weights

float gaussian(float x)
{
    float sigma2 = params.gaussian_sigma * params.gaussian_sigma;
    return exp(-((x * x) / (2.0 * sigma2))) / sqrt(2.0 * PI * sigma2);
}

void main()
{
    ivec2 global_id = ivec2(gl_GlobalInvocationID.xy);

    // Precompute Gaussian weights in shared memory
    if (gl_LocalInvocationID.x == 0 && gl_LocalInvocationID.y == 0) {
        float weight_sum = 0.0;

        int range = int(params.kernel_size) / 2;
        for (int i = 0; i <= range; i++) {
            weights[i] = gaussian(float(i));
            weight_sum += (i == 0) ? weights[i] : 2.0 * weights[i]; // Double for symmetric weights
        }

        // Normalize weights
        for (int i = 0; i <= range; i++) {
            weights[i] /= weight_sum;
        }
    }
    barrier();

    // Ensure we're within bounds
    if (global_id.x >= int(params.texture_size.x) || global_id.y >= int(params.texture_size.y)) {
        return;
    }

    // Compute the Gaussian blur
    vec4 result = vec4(0.0);
    int range = int(params.kernel_size) / 2;

    for (int i = -range; i <= range; i++) {
        int weight_index = abs(i);
        vec2 offset = float(i) * params.direction;
        ivec2 sample_coord = clamp(global_id + ivec2(offset), ivec2(0), ivec2(params.texture_size) - 1);

        result += imageLoad(read_image, sample_coord) * weights[weight_index];
    }

    imageStore(write_image, global_id, result);
}
