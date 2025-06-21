# RISC-V with Custom Matrix Multiplication Instruction for Hardware Neural Network Acceleration.


Arjun Anand Mallya (23110039)
Anirudth Mittal (23110029)
Tirth Shah (23110295)

This project extends a standard 5-stage RISC-V processor with a custom hardware accelerator designed for efficient matrix multiplication. By offloading computationally intensive `matmul` operations to a dedicated systolic array, the architecture aims to significantly improve neural network inference tasks.
## Key Features

- Custom Instruction (`matmul`): A new R-type instruction (`matmul rd, rs1, rs2`) is added to the RISC-V ISA.
- Dedicated Accelerator Path: `matmul` instructions are routed to a `matmul_controller`, bypassing the ALU.
- Systolic Array: A parameterizable systolic array handles the core matrix multiply (`A × B`) operation.
- Pipeline Stalling: The processor stalls via a `busy` signal to ensure in-order execution during acceleration.
- 3-Port Register File: Enhanced to read three operands simultaneously (including `rd` as a source).

## Custom Instruction: `matmul`

Syntax:
matmul rd, rs1, rs2

Operands:
- rs1: Base address of Matrix A
- rs2: Base address of Matrix B
- rd: Base address for output Matrix C

Encoding:
- Opcode: CUSTOM_0 (0b0001011)
- funct3: 0b000
- funct7: 0b0000000

Example (Assembly):
matmul x27, x8, x9  # C = A × B; base addresses in x8, x9, and x27


## Hardware Modifications

- Instruction Decoder: Recognizes `matmul` via CUSTOM_0 opcode and asserts `is_matmul`.
- Register File: Expanded to 3 read ports to support simultaneous read of rs1, rs2, and rd.
- Issue Stage:
  - Routes matmul ops to the accelerator
  - Handles hazard checks on all 3 operands
  - Integrates pipeline stalling using busy signal
- Memory Arbiter:
  - A MUX is placed between the LSU and the Matmul controller, and based on the instruction the address is passed to the memory. A DEMUX is used to route the data from the memory into either the Controler or the LSU.
- Core Top-Level:
  - Instantiates matmul_controller and connects memory arbiter

## Software Toolchain Integration

### GNU Toolchain

- riscv-opc.c modified to include matmul mnemonic
- Enables riscv64-unknown-elf-gcc and gas to assemble matmul properly

### Spike Simulator

- matmul behavior modeled in C++
- Reads rs1, rs2, rd, performs matrix multiplication in software
- Enables functional verification before hardware simulation

## Getting Started

Since the GNU Toolchain and Spike ISA Simulator are large, they have been installed and changes have been made in a Docker Container. The steps to use the docker container are given below.

Using Pre-Built Docker Container:
```
docker pull arjunmallya/ubuntu:withmatmul
docker run -it --rm arjunmallya/ubuntu:withmatmul bash
```
Toolchain (e.g., riscv32-unknown-elf-gcc, spike) is pre-installed and configured.

Some sample C++ files have been compiled and tested on the Spike simulator.
## References
- The steps to compile and run code using the GNU Toolchain and Spike simulator can be viewed here:
https://iitgnacin-my.sharepoint.com/:p:/g/personal/23110029_iitgn_ac_in/EUzJW5k0-CZIqJAiPpHttxUBULoc6RdRJqBoGi890o7vZg?e=BhgA85
- This project builds upon the open-source ultra-embedded RISC-V core:  
https://github.com/ultra-embedded/riscv
