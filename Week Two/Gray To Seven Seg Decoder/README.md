# Gray to Seven-Segment Decoder

This task implements a combinational logic design that converts a 4-bit Gray code input into a seven-segment display output.

## Design Flow

```text
Gray Code
    ↓
Gray-to-Binary Converter
    ↓
Binary-to-Seven-Segment Decoder
    ↓
Seven-Segment Display
```

## Files

- `Gray_to_binary_gate.v` — Converts the 4-bit Gray code input to Binary using gate-level logic.
- `BinToSeg.v` — Converts the Binary value to the corresponding seven-segment display pattern.
- `GrayToSeg.v` — Top-level module that connects the two conversion stages.
- `GrayToSeg_tb.v` — Testbench used to verify the complete design.

## Concepts Practiced

- Gray code to Binary conversion
- Seven-segment decoder design
- Gate-level modeling
- Module instantiation and structural design
- Testbench development and functional verification

## Verification

The testbench applies different Gray code inputs and checks the resulting seven-segment output through simulation.