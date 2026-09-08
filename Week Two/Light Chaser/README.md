# Light Chaser

A parameterized RTL implementation of a **Light Chaser** circuit using a clock divider and a rotate register.

## Overview

The design generates a slower clock from the input clock and uses the divided clock to rotate a single active bit across the output LEDs, creating a moving-light effect.

## Design Structure

- **Clock_Divider.v** — Parameterized clock divider that generates the required lower-frequency clock.
- **Rotate_Register.v** — Parameterized rotate register that shifts/rotates the active LED position on each clock edge.
- **Light_Chaser.v** — Top-level structural module that instantiates the clock divider and rotate register.
- **Light_Chaser_tb.v** — Testbench used to verify the Light Chaser behavior in simulation.

## Concepts Practiced

- Parameterized Verilog modules
- Module instantiation and structural design
- Clock division
- Sequential logic and registers
- Rotate/shift operations
- Reset handling
- RTL simulation and testbench development

## Simulation

The testbench verifies the generated clock and the expected LED rotation sequence over multiple clock cycles.

## Tools

- Verilog HDL
- QuestaSim

## Expected Behavior

After reset, one LED is active. On every active edge of the divided clock, the active bit rotates to the next LED position, producing a continuous chasing-light pattern.
