# Sequence Detectors

## Main Idea

This task implements a **sequence detector FSM** for detecting the bit sequence `110101` using both **Mealy** and **Moore** state-machine designs.

Two detection modes are implemented:

- **Overlapping:** allows a newly detected sequence to share bits with the next sequence.
- **Non-overlapping:** returns to the initial state after detecting a sequence.

The project therefore contains four implementations:

- `O_Mealy.v` — Overlapping Mealy sequence detector
- `O_Moore.v` — Overlapping Moore sequence detector
- `N_O_Mealy.v` — Non-overlapping Mealy sequence detector
- `N_O_Moore.v` — Non-overlapping Moore sequence detector

## FSM Behavior

The FSM tracks the received input bits and progresses through states representing the matched portion of the target sequence `110101`.

### Mealy

The output depends on both the **current state** and `seq_in`, so `seq_correct` is asserted when the final `1` of `110101` is received.

### Moore

The output depends only on the **current state**. An additional state is used to represent successful detection, so the output is asserted after entering the final detection state.

## Overlap vs Non-Overlap

For the overlapping detectors, the FSM preserves the part of the detected sequence that can also be the beginning of another sequence.

For the non-overlapping detectors, the FSM returns to the initial state after a successful detection, preventing the detected sequence from being reused as part of another detection.

## Files

| File | Description |
|------|-------------|
| `O_Mealy.v` | Overlapping sequence detector using a Mealy FSM |
| `O_Moore.v` | Overlapping sequence detector using a Moore FSM |
| `N_O_Mealy.v` | Non-overlapping sequence detector using a Mealy FSM |
| `N_O_Moore.v` | Non-overlapping sequence detector using a Moore FSM |
| `SeqDet_tb.v` | Testbench used to test all four implementations |

## Testbench

The testbench instantiates all four sequence detectors and applies the same input sequence to each implementation for comparison.

## Waveform

<img width="1846" height="236" alt="image" src="https://github.com/user-attachments/assets/bb9361ea-208d-46c4-b108-700a77edf768" />


## Tools

- Verilog HDL
- QuestaSim
