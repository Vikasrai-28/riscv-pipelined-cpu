RISC-V 32-bit 5-Stage Pipelined CPU (RV32I)

A fully synthesizable 32-bit RV32I RISC-V processor implemented from scratch in Verilog, featuring a classic 5-stage pipeline with hazard detection, data forwarding, stall control, and full ASIC physical implementation using the Sky130 PDK.

This project demonstrates end-to-end CPU design — from RTL microarchitecture to post-route GDSII generation.

📌 Overview

This repository contains the design, verification, and physical implementation of a 5-stage pipelined RISC-V processor implementing the base RV32I instruction set.

The processor follows the classical RISC pipeline architecture:
<img width="825" height="517" alt="image" src="https://github.com/user-attachments/assets/1f04680d-cef7-41fe-83fd-154990aa8d85" />

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
