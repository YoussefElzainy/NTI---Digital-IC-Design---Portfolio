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

<img width="410" height="214" alt="image" src="https://github.com/user-attachments/assets/10ad11ef-06e8-42d2-8059-4d051d22e927" />


### Transcript

<img width="711" height="132" alt="image" src="https://github.com/user-attachments/assets/ccc154e7-38ac-4643-aa5c-7f1183e47302" />


## Files

- `AddressMux.v` — RTL design.
- `multiplexor_test.v` — Testbench used for verification.
