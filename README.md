RISC-V 32-bit 5-Stage Pipelined CPU (RV32I)

A fully synthesizable 32-bit RV32I RISC-V processor implemented from scratch in Verilog, featuring a classic 5-stage pipeline with hazard detection, data forwarding, stall control, and full ASIC physical implementation using the Sky130 PDK.

This project demonstrates end-to-end CPU design — from RTL microarchitecture to post-route GDSII generation.

📌 Overview

This repository contains the design, verification, and physical implementation of a 5-stage pipelined RISC-V processor implementing the base RV32I instruction set.

The processor follows the classical RISC pipeline architecture:
<img width="991" height="668" alt="image" src="https://github.com/user-attachments/assets/77c08409-9fa6-404a-b9e2-31a1d8427176" />


Instruction Fetch (IF)

Instruction Decode (ID)

Execute (EX)

Memory Access (MEM)

Write Back (WB)

The design emphasizes:

Correct pipeline behavior

Data hazard resolution

Clean synthesizable RTL

ASIC-compatible implementation

🧠 Microarchitecture
🔹 Pipeline Stages
Stage	Function
IF	Fetches instruction from instruction memory
ID	Decodes instruction and reads register file
EX	ALU operations and branch evaluation
MEM	Data memory read/write
WB	Writes results back to register file

Each stage is separated by dedicated pipeline registers:

IF/ID

ID/EX

EX/MEM

MEM/WB

⚙️ Key Features
✔ 5-Stage Pipelined Architecture

Implements a standard RISC pipeline with proper control and data propagation.

✔ Data Hazard Detection & Forwarding

Forwarding from:

EX/MEM → EX

MEM/WB → EX

Resolves RAW hazards without unnecessary stalls.

✔ Load-Use Hazard Stall Logic

Detects load-use hazards

Inserts pipeline bubble

Prevents incorrect operand usage

✔ Branch Handling

Branch decision resolved in EX stage

Pipeline flush mechanism for control hazards

✔ Synthesizable Verilog RTL

Fully synthesizable

No behavioral-only constructs

ASIC and FPGA compatible

✔ Modular Design

Core modules include:

cpu_top.v

alu.v

control_unit.v

forwarding_unit.v

hazard_detection_unit.v

regfile.v

Pipeline register modules

🧪 Functional Verification

The processor was functionally verified using self-written Verilog testbenches.

Verification includes:

Arithmetic and logical instruction validation

Load/store testing

Hazard condition verification

Forwarding correctness

Stall insertion testing

Branch correctness testing

Simulation confirms:

Correct pipeline timing

Proper hazard handling

Correct register updates

🏭 ASIC Physical Implementation (Sky130)

The design was synthesized and physically implemented using:

OpenLane

Sky130 (130nm) PDK

OpenROAD

Magic Layout Tool

🔹 Flow Performed

RTL Synthesis

Floorplanning

Power Distribution Network (PDN) Generation

Placement

Clock Tree Synthesis (CTS)

Global & Detailed Routing

Parasitic Extraction

Static Timing Analysis (STA)

DRC & LVS Verification

Final GDSII Generation

🔹 Results

✅ DRC Clean

✅ LVS Clean

✅ No setup violations (typical corner)

✅ No hold violations

✅ Final GDS successfully generated

This makes the processor silicon-ready at 130nm technology.

🧩 Pipeline Architecture Diagram
<img width="1549" height="762" alt="image" src="https://github.com/user-attachments/assets/5eb3148e-e2e7-4a60-a9fa-2cffb4ebc034" />

🧱 Post-Route Physical Layout (GDS View)
<img width="1026" height="580" alt="image" src="https://github.com/user-attachments/assets/67c92f0e-f956-4e0f-932b-ee64bb654d02" />


## ASIC Physical Implementation Summary

| Metric | Value |
|------|------|
| Technology | Sky130 (130 nm) |
| Die Size | 300 µm × 300 µm |
| Die Area | 0.09 mm² |
| Standard Cells | ~4,081 |
| Placement Rows | 44 |
| Sites per Row | 434 |
| Metal Layers | M1–M5 |
| Core Utilization | ~65 % |
| Flow | OpenLane RTL-to-GDS |

The processor was implemented using the open-source OpenLane ASIC flow with the Sky130 HD standard cell library. The design successfully completed synthesis, placement, clock tree synthesis, routing, and signoff checks, producing a manufacturable GDSII layout.

## Performance Summary

| Metric | Value |
|---|---|
| Minimum Clock Period | 11.84 ns |
| Maximum Frequency | 84.45 MHz |
| Worst Setup Slack | 9.27 ns |
| Worst Hold Slack | 0.35 ns |
| Total Power | ~38.5 mW |
