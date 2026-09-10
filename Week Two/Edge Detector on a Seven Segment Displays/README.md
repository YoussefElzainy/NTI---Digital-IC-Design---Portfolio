# Edge Detector on Seven-Segment Displays

## Main Idea

This project implements an **edge detection system** that detects rising, falling, and both-edge transitions of an input signal, counts the detected edges, and displays the results on seven-segment displays.

The design also includes a clock divider to generate a slower clock suitable for the edge-detection and display system.

## Design Flow

```text
Input Signal
     |
     v
Clock Divider
     |
     v
+-----------------------+
| Edge Detection        |
| Rising / Falling /    |
| Both Edge             |
+-----------------------+
     |
     v
Edge Counters
     |
     v
Binary to 7-Segment
     |
     v
Seven-Segment Displays
```

## Files

- `EdgeDetect.v` — Top-level module connecting the clock divider, edge detectors, counters, and seven-segment display logic.
- `BothEdgeDetect.v` — Detects both rising and falling edges.
- `PosEdgeDetect_moore.v` — Detects rising edges using a Moore FSM.
- `FallEdgeDetect.v` — Detects falling edges.
- `EdgeCounter.v` — Counts rising, falling, and total detected edges.
- `BinToSeg.v` — Converts binary values into seven-segment display patterns.
- `Six_SevSeg.v` — Seven-segment display control logic.
- `Clock_Divider.v` — Divides the input clock to generate the required slower clock.
- `EdgeDetect_tb.v` — Testbench used to verify the design.

## Edge Detection

The system monitors the `level` input and generates a one-clock-cycle pulse when an edge is detected.

- **Rising edge** — `0 → 1`
- **Falling edge** — `1 → 0`
- **Both edge** — either `0 → 1` or `1 → 0`

Separate counters keep track of the number of rising, falling, and total edges detected.

## Seven-Segment Display

The counter values are converted from binary into seven-segment display patterns. The displays provide a visual representation of the detected edge counts.

## Clock Divider

A clock divider generates a lower-frequency clock from the input clock. This provides a slower sampling/update rate for the edge detection system and makes the displayed counting behavior easier to observe.

## Verification

The testbench applies different input transitions and verifies that the appropriate edge-detection outputs and counters respond correctly.

### Waveform

<!-- Add waveform screenshot here -->

