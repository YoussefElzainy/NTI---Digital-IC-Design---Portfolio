# Counter

## Main Idea

A parameterized synchronous counter that can be reset, loaded with a selected value, or incremented when enabled.

The design also includes a function-based implementation to demonstrate using a Verilog `function` for next-state logic.

## Design

* Parameterized counter width
* Synchronous reset
* Load operation
* Enable-based increment
* Function-based next-state logic

## Files

* `Counter.v` — Counter RTL
* `Counterf.v` — Counter RTL using a function
* `counter_test.v` — Testbench