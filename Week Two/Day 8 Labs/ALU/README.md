# ALU

## Overview

A 6-bit Arithmetic Logic Unit (ALU) implemented in Verilog. The ALU performs arithmetic, logic, comparison, and shift operations based on a 3-bit `Control` signal.

## Operations

| Control | Operation |
|---------|-----------|
| `000` | Addition: `A + B + Cin` |
| `001` | Subtraction: `A - B - Cin` |
| `010` | MUX: `Cin = 0 → A`, `Cin = 1 → B` |
| `011` | 2's Complement of `A` |
| `100` | XOR: `A ^ B` |
| `101` | Equality Check: `A == B` |
| `110` | Logical Right Shift of `A` |
| `111` | Arithmetic Right Shift of `A` |

## Inputs

- `A [5:0]` – First 6-bit operand.
- `B [5:0]` – Second 6-bit operand.
- `Cin` – Carry/control input.
- `Control [2:0]` – Selects the ALU operation.

## Outputs

- `Out [5:0]` – 6-bit operation result.
- `Cout` – Carry output for arithmetic operations.

## Verification

The testbench verifies all supported ALU operations using directed test cases and checks the resulting outputs against expected values.

## Waveform

<img width="519" height="243" alt="image" src="https://github.com/user-attachments/assets/062a8d73-2f5a-4c2b-8b7f-20df3aeb3d48" />


## Transcript

> Add QuestaSim transcript screenshot here.

<img width="565" height="218" alt="image" src="https://github.com/user-attachments/assets/5d6f3973-1189-40a3-9dcb-7226f5845be0" />


- `ALU.v` – ALU RTL implementation.
- `alu_test.v` – Testbench used to verify the ALU.
