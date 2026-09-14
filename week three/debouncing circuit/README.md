# Debouncing Circuit

## Main Idea

A digital debouncing circuit implemented using an FSM to filter the mechanical bouncing of a push button or switch.

The circuit waits for the input signal to remain stable for a predefined number of clock cycles before updating the debounced output.

## Design

- FSM-based debouncing
- Configurable clock frequency
- Configurable debounce counter
- Active-high switch input
- Synchronous debounced output

## Files

- `Debouncing_cir.v` — Debouncing circuit RTL
- `Debouncing_cir_tb.v` — Testbench
