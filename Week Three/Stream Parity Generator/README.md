# Stream Bit Generator

## Main Idea

A serial data processing module that collects incoming serial bits into an 8-bit data word and generates the corresponding parity bit.

A `valid` signal indicates when a complete 8-bit data word has been received and the generated parity value is ready to be checked.

## Design

* Serial-to-parallel data collection
* 8-bit data output
* Parity generation
* `valid` signal for completed data
* Synchronous design with active-low reset

## Files

* `Stream_bit_gen.v` — Stream bit generator RTL
* `Stream_bit_gen_tb.v` — Testbench
