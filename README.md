# riscv-pipelined-cpu

# RISC-V Pipelined CPU (RV32I)

This repository containsof a 5-stage pipelined RISC-V (RV32I) processor, designed and verified
from scratch in Verilog.

## Pipeline Stages
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

## Key Features (Planned)
- 5-stage pipelined architecture
- Data hazard detection and forwarding
- Stall control for load-use hazards
- Synthesizable Verilog RTL
- Functional verification using self-written testbenches
- FPGA implementation (planned)
- Optional RTL-to-GDSII flow (OpenLane)

<img width="1549" height="762" alt="image" src="https://github.com/user-attachments/assets/ae43f5f7-2c41-4992-8bc4-4d5fb74efbfb" />
