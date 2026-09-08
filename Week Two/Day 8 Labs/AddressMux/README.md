# Address Mux

## Overview

A parameterized **2-to-1 Multiplexer** designed in Verilog to select between two input buses based on a select signal.

## Design

- **Module:** `multiplexor`
- **Inputs:** `in0`, `in1`, `sel`
- **Output:** `mux_out`
- **Parameter:** `WIDTH` (default: 5 bits)
- When `sel = 0`, `mux_out = in0`.
- When `sel = 1`, `mux_out = in1`.

## Implementation

The multiplexer is implemented using a continuous assignment with the ternary operator:

```verilog
assign mux_out = sel ? in1 : in0;
```

The design is parameterized so the bus width can be changed without modifying the module itself.

## Verification

The design was tested using a Verilog testbench covering different input and select combinations.

### Waveform

_Add waveform screenshot here._

### Transcript

_Add QuestaSim transcript here._

## Files

- `AddressMux.v` — RTL design.
- `multiplexor_test.v` — Testbench used for verification.
