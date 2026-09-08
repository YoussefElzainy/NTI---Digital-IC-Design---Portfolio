# Data Driver

## Overview

A parameterized Verilog data driver that controls whether an input data bus is driven onto the output or placed in a high-impedance (`Z`) state. This models a tri-state data bus interface.

## Operation

| `data_en` | `data_out` |
|-----------|------------|
| `1` | `data_in` |
| `0` | High-impedance (`Z`) |

The `WIDTH` parameter controls the size of the data bus and defaults to 8 bits.

## Inputs

- `data_in [WIDTH-1:0]` – Input data bus.
- `data_en` – Enables or disables the driver.

## Output

- `data_out [WIDTH-1:0]` – Driven data when enabled, otherwise high-impedance.

## Verification

The testbench verifies the driver in both enabled and disabled states and checks the resulting output against the expected values.

## Waveform

> Add waveform screenshot here.

## Transcript

> Add QuestaSim transcript screenshot here.

## Files

- `DataDriver.v` – Parameterized data driver RTL implementation.
- `driver_test.v` – Testbench used to verify the data driver.
