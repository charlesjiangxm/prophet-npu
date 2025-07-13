# HHB (Horizon Heterogeneous Bridge) Neural Network Deployment

This directory contains the HHB (Horizon Heterogeneous Bridge) tools and utilities for deploying neural networks on the T-Head C906 RISC-V processor. HHB provides a complete workflow for converting ONNX models to optimized C906-executable code.

## Overview

HHB is a neural network deployment framework that:
- Converts ONNX models to C906-optimized implementations
- Supports quantization for efficient inference
- Generates complete C source code with runtime libraries
- Provides build systems for cross-compilation
- Enables simulation and testing on C906 processors

## Directory Structure

```
hhb/
├── scripts/                    # Deployment scripts and workflows
│   ├── run_hhb_cmp.sh         # Main HHB deployment script
│   ├── run_tb_cmp.sh          # Test bench build script
│   └── hhb_out/               # Generated output directory
│       ├── main.c             # Generated application entry point
│       ├── model.c            # Neural network model implementation
│       ├── model.params       # Model weights and parameters
│       ├── io.c, io.h         # I/O handling code
│       ├── makefile.c906      # Generated C906 build configuration
│       ├── hhb_runtime.elf    # Compiled executable
│       └── *.bin, *.tensor    # Input/output data files
├── utils/                     # Build utilities and configurations
│   ├── Makefile              # General-purpose C906 build system
│   ├── linker.lcf            # Linker script for C906 memory layout
│   ├── Srec2vmem             # Binary to memory format converter
│   └── onnx_gen.ipynb        # Jupyter notebook for ONNX model generation
└── README.md                 # This file
```

## Prerequisites

### Required Tools

1. **HHB Tool**
   - Location: `/usr/local/bin/hhb`
   - Neural network deployment framework

2. **C906 Toolchain**
   - Location: `/opt/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.1.0/bin/`
   - Cross-compiler for C906 RISC-V processor

3. **Python Environment**
   - Python 3.8+ with required packages
   - ONNX, NumPy for model handling

### Environment Setup

```bash
# Set up toolchain paths
export HHB_PATH=/usr/local/bin
export XUANTIE_ROOT=/opt/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.1.0/bin
export PATH=$HHB_PATH:$XUANTIE_ROOT:$PATH

# Verify installation
hhb --version
```

## Quick Start

### 1. Basic Deployment Workflow

```bash
# Navigate to scripts directory
cd scripts

# Run the example deployment
./run_hhb_cmp.sh

# Build the generated code
./run_tb_cmp.sh
```

### 2. Custom Model Deployment

```bash
# Deploy your own ONNX model
hhb -S \
    --calibrate-dataset /path/to/calibration_data.npz \
    --simulate-data /path/to/test_data.npz \
    --model-file /path/to/your_model.onnx \
    --input-name "input_tensor_name" \
    --output-name "output_tensor_name" \
    --input-shape "1,3,224,224" \
    --board c906 \
    --output hhb_out \
    --quantization-scheme int8_asym_w_sym \
    --with-makefile \
    --without-preprocess

# Build the generated code
cd hhb_out
make -f makefile.c906 all
```

## HHB Command Reference

### Core Options

| Option | Description | Example |
|--------|-------------|---------|
| `--model-file` | Input ONNX model file | `--model-file model.onnx` |
| `--output` | Output directory | `--output hhb_out` |
| `--board` | Target platform | `--board c906` |
| `--input-name` | Input tensor names | `--input-name "input1;input2"` |
| `--output-name` | Output tensor names | `--output-name "output"` |
| `--input-shape` | Input tensor shapes | `--input-shape "1,3,224,224"` |

### Quantization Options

| Option | Description |
|--------|-------------|
| `--quantization-scheme int8_asym_w_sym` | 8-bit asymmetric activation, symmetric weights |
| `--quantization-scheme int16_asym_w_sym` | 16-bit asymmetric activation, symmetric weights |
| `--calibrate-dataset` | Calibration data for quantization |

### Build Options

| Option | Description |
|--------|-------------|
| `--with-makefile` | Generate Makefile for C906 |
| `--without-preprocess` | Skip preprocessing steps |
| `--save-temps` | Save intermediate files |
| `--trace relay qnn csinn` | Enable tracing for debugging |

### Advanced Options

| Option | Description |
|--------|-------------|
| `--model-save save_and_run` | Save model and run inference |
| `--target-layout NCHW` | Specify tensor layout |
| `-S` | Simulation mode |

## Generated Files

### Core Generated Files

After running HHB, the output directory contains:

#### Source Code
- **`main.c`**: Application entry point with model inference loop
- **`model.c`**: Generated neural network implementation
- **`io.c/io.h`**: Input/output handling functions
- **`model.params`**: Binary model weights and parameters

#### Build System
- **`makefile.c906`**: C906-specific build configuration
- **`linker.lcf`**: Memory layout configuration (copied from utils/)

#### Binary Files
- **`hhb_runtime.elf`**: Compiled executable
- **`hhb_runtime.hex`**: Hex format for memory loading
- **`hhb_runtime_data.hex`**: Data segment hex file
- **`hhb_runtime_inst.hex`**: Instruction segment hex file

#### Data Files
- **`input_*.bin`**: Input tensor data in binary format
- **`input_*.tensor`**: Input tensor metadata
- **`random_input.npz.*.bin`**: Test input data
- **`hhb.bm`**: Benchmark metadata

### File Format Details

#### Memory Layout (`linker.lcf`)
```
MEM1 (Text): 0x10000000 - 0x10010000 (64KB)
MEM2 (Data): 0x10010000 - 0x10040000 (192KB)
Stack:       0x10030000
```

#### Makefile Targets
- `all`: Build complete application (default)
- `elf`: Generate ELF executable
- `hex`: Generate hex files for memory loading
- `pat`: Generate pattern files for simulation
- `obj`: Generate disassembly listing
- `clean`: Remove generated files

## Workflow Examples

### Example 1: Image Classification Model

```bash
# Deploy ResNet-18 for image classification
hhb -S \
    --calibrate-dataset imagenet_calibration.npz \
    --simulate-data test_image.npz \
    --model-file resnet18.onnx \
    --input-name "input" \
    --output-name "output" \
    --input-shape "1,3,224,224" \
    --board c906 \
    --output resnet18_out \
    --quantization-scheme int8_asym_w_sym \
    --with-makefile \
    --without-preprocess
```

### Example 2: Matrix Multiplication (Current Example)

```bash
# Deploy matrix multiplication model
hhb -S \
    --calibrate-dataset /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/random_input.npz \
    --simulate-data /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/random_input.npz \
    --model-file /mnt/dev/ml_db/ml_db/onnx1_12_opset17/matmul/matmul.onnx \
    --input-name "input_1;input_2" \
    --output-name "output" \
    --input-shape "1,1,1024,1024;1,1,1024,1024" \
    --board c906 \
    --output hhb_out \
    --quantization-scheme int8_asym_w_sym \
    --with-makefile \
    --without-preprocess
```

### Example 3: Custom Model with Debugging

```bash
# Deploy with full debugging and tracing
hhb -S \
    --calibrate-dataset calibration.npz \
    --simulate-data test_data.npz \
    --model-file custom_model.onnx \
    --input-name "input" \
    --output-name "output" \
    --input-shape "1,128,128,3" \
    --board c906 \
    --output debug_out \
    --quantization-scheme int8_asym_w_sym \
    --with-makefile \
    --without-preprocess \
    --save-temps \
    --trace relay qnn csinn \
    --model-save save_and_run
```

## Build System

### Using Generated Makefile

```bash
# Navigate to output directory
cd hhb_out

# Build all targets
make -f makefile.c906 all

# Build specific targets
make -f makefile.c906 elf    # ELF executable only
make -f makefile.c906 hex    # Hex files only
make -f makefile.c906 pat    # Pattern files for simulation
make -f makefile.c906 obj    # Disassembly listing

# Clean build artifacts
make -f makefile.c906 clean
```

### Using Utils Makefile

```bash
# Copy utils Makefile to output directory
cp ../utils/Makefile hhb_out/

# Build with utils Makefile
cd hhb_out
make all
```

### Manual Build Process

```bash
# Set toolchain variables
export XUANTIE_ROOT=/opt/Xuantie-900-gcc-linux-6.6.0-glibc-x86_64-V3.1.0/bin
export CC=${XUANTIE_ROOT}/riscv64-unknown-linux-gnu-gcc
export OBJCOPY=${XUANTIE_ROOT}/riscv64-unknown-linux-gnu-objcopy

# Compile and link
$CC -O2 -g -march=rv64gcv0p7_zfh_xtheadc -mabi=lp64d \
    -I/usr/local/lib/python3.8/dist-packages/hhb/install_nn2/c906/include/ \
    main.c model.c io.c \
    -L/usr/local/lib/python3.8/dist-packages/hhb/install_nn2/c906/lib/ \
    -lshl -lm -o hhb_runtime

# Generate hex files
$OBJCOPY -O srec hhb_runtime hhb_runtime.hex
```

## ONNX Model Generation

### Using Jupyter Notebook

The `utils/onnx_gen.ipynb` notebook provides examples for generating ONNX models:

```python
# Example: Generate a simple convolution model
import torch
import torch.nn as nn
import torch.onnx

class ConvModel(nn.Module):
    def __init__(self):
        super(ConvModel, self).__init__()
        self.conv = nn.Conv2d(3, 64, kernel_size=3, padding=1)
        self.relu = nn.ReLU()
        
    def forward(self, x):
        return self.relu(self.conv(x))

# Export to ONNX
model = ConvModel()
dummy_input = torch.randn(1, 3, 224, 224)
torch.onnx.export(model, dummy_input, "conv_model.onnx")
```

### Model Requirements

- **Format**: ONNX format (opset 11+ recommended)
- **Precision**: FP32 models (will be quantized by HHB)
- **Operations**: Supported by CSI-NN2 library
- **Input/Output**: Named tensors with fixed shapes

## Optimization Tips

### Quantization Best Practices

1. **Calibration Data**
   - Use representative dataset for calibration
   - Match the distribution of real inference data
   - Include edge cases and diverse samples

2. **Quantization Schemes**
   - `int8_asym_w_sym`: Best for most models
   - `int16_asym_w_sym`: Higher precision for sensitive layers

3. **Input Preprocessing**
   - Normalize inputs to match training data
   - Use `--without-preprocess` for custom preprocessing

### Performance Optimization

1. **Memory Layout**
   - Use NCHW layout for better C906 performance
   - Optimize tensor shapes for vector operations

2. **Compiler Flags**
   - Enable C906 vector extensions (`-march=rv64gcv0p7_zfh_xtheadc`)
   - Use appropriate optimization level (`-O2` or `-O3`)

3. **Model Architecture**
   - Prefer operations well-supported by CSI-NN2
   - Minimize dynamic shapes and branching

## Troubleshooting

### Common Issues

1. **HHB Command Fails**
   ```
   Error: Model conversion failed
   Solution: Check ONNX model format and supported operations
   ```

2. **Build Errors**
   ```
   Error: Toolchain not found
   Solution: Set XUANTIE_ROOT environment variable correctly
   ```

3. **Runtime Errors**
   ```
   Error: Segmentation fault
   Solution: Check memory layout in linker.lcf
   ```

4. **Quantization Issues**
   ```
   Error: Poor inference accuracy
   Solution: Improve calibration dataset quality
   ```

### Debugging Steps

1. **Enable Tracing**
   ```bash
   hhb --trace relay qnn csinn [other options]
   ```

2. **Save Intermediate Files**
   ```bash
   hhb --save-temps [other options]
   ```

3. **Check Generated Code**
   ```bash
   # Review generated model.c for issues
   less hhb_out/model.c
   
   # Check disassembly
   make -f makefile.c906 obj
   less hhb_runtime.obj
   ```

4. **Validate Input Data**
   ```bash
   # Check tensor shapes and data types
   python -c "import numpy as np; print(np.load('input.npz').files)"
   ```

### Log Files and Debugging

- **HHB Logs**: Console output during model conversion
- **Build Logs**: Compiler warnings and errors
- **Runtime Logs**: Application output and errors
- **Trace Files**: Intermediate representation files (with `--save-temps`)

## Integration with C906 Smart Run

### Workflow Integration

1. **Deploy Model with HHB**
   ```bash
   cd npu-hkust/sw/hhb/scripts
   ./run_hhb_cmp.sh
   ```

2. **Copy to Smart Run Environment**
   ```bash
   # Create test case directory
   mkdir -p ../../C906-Minimal-SOC/smart_run/tests/cases/nn_inference
   
   # Copy generated files
   cp hhb_out/main.c ../../C906-Minimal-SOC/smart_run/tests/cases/nn_inference/
   cp hhb_out/model.c ../../C906-Minimal-SOC/smart_run/tests/cases/nn_inference/
   cp hhb_out/io.c ../../C906-Minimal-SOC/smart_run/tests/cases/nn_inference/
   cp hhb_out/io.h ../../C906-Minimal-SOC/smart_run/tests/cases/nn_inference/
   ```

3. **Build and Test in Smart Run**
   ```bash
   cd ../../C906-Minimal-SOC/smart_run
   make buildcase CASE=nn_inference
   make runcase CASE=nn_inference
   ```

## Support and Resources

### Documentation
- **T-Head C906 Manual**: C906 processor documentation
- **CSI-NN2 Documentation**: Neural network library reference
- **RISC-V Vector Extension**: RVV 0.7.1 specification

### Example Models
- Matrix multiplication: Current example in `scripts/`
- Convolution networks: Generate using `utils/onnx_gen.ipynb`
- Custom models: Create with PyTorch/TensorFlow → ONNX export

### Community and Support
- T-Head developer community
- RISC-V foundation resources
- CSI-NN2 GitHub repository

This HHB framework provides a complete solution for deploying neural networks on C906 RISC-V processors, from model conversion to optimized executable generation.
