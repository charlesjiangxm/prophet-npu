#!/bin/bash

# --------------------
# Unset variables:
#   target-layout - NCHW, NHWC
# --------------------
hhb -S --calibrate-dataset /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/random_input.npz \
    --simulate-data /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/random_input.npz \
    --model-file /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/matmul.onnx \
    --input-name "input_1;input_2" \
    --output-name "output" \
    --input-shape "1 1 1024 1024;1 1 1024 1024" \
    --board c906 \
    --output hhb_out \
    --quantization-scheme int8_asym_w_sym \
    --with-makefile \
    --without-preprocess


# hhb -S --calibrate-dataset /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/random_input.npz \
#     --simulate-data /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/random_input.npz \
#     --model-file /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/matmul.onnx \
#     --input-name "input_1;input_2" \
#     --output-name "output" \
#     --input-shape "1 1 1024 1024;1 1 1024 1024" \
#     --save-temps \
#     --board c906 \
#     --output hhb_out \
#     --quantization-scheme int8_asym_w_sym \
#     --with-makefile \
#     --without-preprocess \
#     --model-save save_and_run \
#     --trace relay qnn csinn
    