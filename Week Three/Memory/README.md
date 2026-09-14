# Memory

## Main Idea

A parameterized synchronous-write memory with an 8-bit data bus and 32 memory locations.

The data bus is bidirectional, using tri-state behavior so the memory drives the bus during read operations and receives data from the bus during write operations.

## Design

* Parameterized address and data width
* Synchronous write operation
* Read operation through a bidirectional data bus
* Tri-state data bus control
* 32 memory locations with 8-bit data

## Files

* `memory.v` — Memory RTL
* `memory_test2.v` — Testbench