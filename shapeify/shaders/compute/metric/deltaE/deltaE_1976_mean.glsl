#[compute]
#version 450
#include "../common/CEILab_common.glslinc"
#include "../common/deltaE.glslinc"
#include "../common/metric_constants.glslinc"

// Local invocation settings with 64 local invocations
layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

// Parameters passed to the shader
layout(push_constant, std430) uniform Params
{
    vec2 texture_size;
}
params;

// Buffer to store the MSE result
layout(set = 0, binding = 0, std430) restrict buffer ResultBuffer
{
    float partial_sums[];
};

layout(set = 0, binding = 1, std430) restrict buffer WeightsResultBuffer
{
    float partial_weight_sums[];
};

// Image bindings
layout(rgba8, set = 1, binding = 0) uniform
    restrict readonly image2D target_image;
layout(rgba8, set = 2, binding = 0) uniform
    restrict readonly image2D source_image;
layout(rgba8, set = 3, binding = 0) uniform
    restrict readonly image2D weight_image;

// Variable shared by invocations of the same work group
shared float shared_partial_sums[gl_WorkGroupSize.x];
shared float shared_partial_weights_sum[gl_WorkGroupSize.x];

struct MetricData {
    float value;
    float weight;
};

MetricData compute_delta_e(uint x, uint y)
{
    // Sample the target and source textures at the current pixel location
    vec4 target_pixel = imageLoad(target_image, ivec2(x, y));
    vec4 source_pixel = imageLoad(source_image, ivec2(x, y));
    vec4 weight_pixel = imageLoad(weight_image, ivec2(x, y));

    // Compute colors in CEILab color space
    vec3 target_lab = rgb2lab(target_pixel.rgb);
    vec3 source_lab = rgb2lab(source_pixel.rgb);

    // Calculates pixel delta e and adds to the shared buffer
    float pixel_delta_e = delta_e_1976(target_lab, source_lab);

    float normalized_weight = weight_pixel.r;

    // Maps weight from range [0.0, 1.0] to range [MIN_WEIGHT_BOUND, 1.0]
    float mapped_weight = MIN_WEIGHT_BOUND + normalized_weight * (1.0 - MIN_WEIGHT_BOUND);
    return MetricData(pixel_delta_e * mapped_weight, mapped_weight);
}

void main()
{

    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    // Compute total number of pixels in the image
    uint num_pixels = uint(params.texture_size.x * params.texture_size.y);

    // Initialize shared data
    shared_partial_sums[local_id] = 0.0;
    shared_partial_weights_sum[local_id] = 0.0;

    // Process pixel if within bounds of the image
    if (global_id < num_pixels) {
        // Map global_id to image coordinates
        uint x = global_id % uint(params.texture_size.x);
        uint y = global_id / uint(params.texture_size.x);

        MetricData data = compute_delta_e(x, y);
        shared_partial_sums[local_id] = data.value;
        shared_partial_weights_sum[local_id] = data.weight;
    }

    // Synchronize threads in the workgroup
    barrier();

    // Perform parallel reduction
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_sums[local_id] += shared_partial_sums[local_id + stride];
            shared_partial_weights_sum[local_id] += shared_partial_weights_sum[local_id + stride];
        }
        barrier();
    }

    // Write the result of the reduction to the output buffer (only thread 0)
    if (local_id == 0) {
        partial_sums[group_id] = shared_partial_sums[0];
        partial_weight_sums[group_id] = shared_partial_weights_sum[0];
    }
}
