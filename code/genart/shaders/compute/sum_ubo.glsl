#[compute]
#version 450

layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) restrict buffer InputBuffer
{
    float input_buffer[];
};

layout(set = 0, binding = 1, std430) restrict buffer OutputBuffer
{
    float output_buffer[];
};

shared float shared_partial_sum[gl_WorkGroupSize.x];

void main()
{
    uint global_id = gl_GlobalInvocationID.x;
    uint local_id = gl_LocalInvocationID.x;
    uint group_id = gl_WorkGroupID.x;

    shared_partial_sum[local_id] = input_buffer[global_id];

    // Parallel reduction in shared memory
    for (uint stride = gl_WorkGroupSize.x / 2; stride > 0; stride /= 2) {
        if (local_id < stride) {
            shared_partial_sum[local_id] += shared_partial_sum[local_id + stride];
        }
        barrier(); // Synchronize before next iteration
    }

    // Write final sum to output buffer (only thread 0)
    if (local_id == 0) {
        output_buffer[group_id] = shared_partial_sum[0];
    }
}
