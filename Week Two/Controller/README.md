# Controller

## Overview

This project implements the **Controller** for a simple accumulator-based CPU using Verilog HDL.

The controller generates the required control signals according to the current **instruction opcode**, **execution phase**, and the **zero flag** from the accumulator.

## Control Signals

The controller generates the following control signals:

| Signal | Description |
|---|---|
| `sel` | Selects the instruction address for memory access |
| `rd` | Enables memory read |
| `ld_ir` | Loads the Instruction Register |
| `halt` | Halts the processor |
| `inc_pc` | Increments the Program Counter |
| `ld_ac` | Loads the Accumulator |
| `ld_pc` | Loads the Program Counter |
| `wr` | Writes data to memory |
| `data_e` | Enables the Accumulator onto the data bus |

## Instruction Opcodes

| Opcode | Instruction | Description |
|---|---|---|
| `000` | HLT | Halt the processor |
| `001` | SKZ | Skip the next instruction if the accumulator is zero |
| `010` | ADD | Add memory data to the accumulator |
| `011` | AND | Perform bitwise AND with memory data |
| `100` | XOR | Perform bitwise XOR with memory data |
| `101` | LDA | Load memory data into the accumulator |
| `110` | STO | Store accumulator data into memory |
| `111` | JMP | Jump to the specified address |

## Execution Phases

The controller operates according to eight execution phases:

| Phase | Name | Purpose |
|---|---|---|
| `000` | `INST_ADDR` | Select the instruction address |
| `001` | `INST_FETCH` | Fetch the instruction from memory |
| `010` | `INST_LOAD` | Load the instruction into the Instruction Register |
| `011` | `IDLE` | Instruction decode / idle phase |
| `100` | `OP_ADDR` | Generate the operand address |
| `101` | `OP_FETCH` | Fetch the operand from memory |
| `110` | `ALU_OP` | Perform the required operation |
| `111` | `STORE` | Store data or complete the operation |

## Design Approach

The controller uses the current `phase` and `opcode` to determine which control signals should be asserted during each CPU cycle.

The `zero` input is used by the `SKZ` instruction to determine whether the Program Counter should be incremented to skip the next instruction.

## Verification

The design is verified using a Verilog testbench that checks the generated control signals for all supported instructions across all execution phases.

The testbench verifies:

- Instruction fetch sequence
- Instruction decode phase
- Arithmetic and logical operations
- Skip-if-zero behavior
- Store operation
- Jump operation
- Halt operation

## Waveform

> **Waveform screenshot will be added here.**

<img width="1129" height="324" alt="image" src="https://github.com/user-attachments/assets/70240dec-0a99-4dd8-856c-2ff95a5debb4" />


## Simulation Transcript

> **Simulation transcript screenshot will be added here.**

<img width="755" height="190" alt="image" src="https://github.com/user-attachments/assets/ab92f0da-6f45-415f-a8ce-5f89f3cf0626" />


## Files

- `controller.v` — Controller RTL implementation
- `controller_test.v` — Verilog testbench
- `README.md` — Project documentation
