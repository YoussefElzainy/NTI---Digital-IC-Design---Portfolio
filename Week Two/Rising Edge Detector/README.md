# Rising Edge Detector

## Main Idea

A **Rising Edge Detector** generates a one-clock-cycle pulse (`tick`) when the input signal `level` transitions from `0` to `1`.

This task implements the rising edge detector using two different FSM approaches:

- **Mealy FSM** — the output depends on the current state and the current input.
- **Moore FSM** — the output depends only on the current state.

## Files

- `PosEdgeDetect_mealy.v` — Rising edge detector implemented as a Mealy FSM.
- `PosEdgeDetect_moore.v` — Rising edge detector implemented as a Moore FSM.
- `PosEdgeDetect_tb.v` — Testbench used to verify the designs.

## FSM Concept

The detector must distinguish between:

- `level = 0` → input is low.
- `level = 1` for the first time → rising edge detected.
- `level = 1` continuously → no new rising edge should be generated.

The FSM therefore keeps track of the previous condition of the input so that only the `0 → 1` transition produces a `tick` pulse.

## Mealy Implementation

In the Mealy implementation, `tick` is generated from the combination of the current state and the current `level` input.

## Moore Implementation

In the Moore implementation, a dedicated `edg` state represents the detected rising edge. `tick` is asserted whenever the FSM is in this state.

## Verification

The testbench applies different `level` transitions and checks that `tick` is asserted only when a rising edge occurs.

### Waveform

<img width="1071" height="351" alt="image" src="https://github.com/user-attachments/assets/ff281f60-bf97-4ebe-b1ba-9eecb9465681" />

