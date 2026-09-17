# Packet Routing System
## Project Documentation

**Names:**
- Youssef Hossam EldeenMohamed Elzainy
- Fares Nagah Ibrahim
- Yehia Omar

**Course:** Digital IC Design Using FPGA

## 1. Introduction

In most digital systems, more than one part of the chip needs to send data to shared resources at the same time. A single bus cannot serve four sources at once without collisions, so some form of arbitration and routing is needed between the sources and the destinations. This project implements a small router that solves exactly that problem for a system with four input ports and four output ports.

The design accepts data from four independent write ports, each backed by its own synchronous FIFO buffer. A round-robin arbiter monitors the four FIFOs and grants access to the shared output path in a fair, rotating order, so no single port can starve the others. Once a packet is granted access, it passes through a packet routing block that reads the destination bits embedded in the packet and forwards it to the correct one of four output ports. Three of the output ports are connected to simple RAM-based memory nodes that model slave devices on the network, while the fourth port is exposed directly to the testbench so that responses coming back from the memory nodes can be observed and checked.

### 1.1 Objective

The objective of this project is to design and verify a 4-port packet router at the RTL level using Verilog, covering the full data path from FIFO buffering and arbitration through to packet routing and delivery, and to confirm correct operation through simulation and synthesis

### 1.2 Project Overview

The system is built up from a small set of reusable blocks. A generic synchronous FIFO (FIFO_Memory.v) is instantiated four times (Four_FIFO_Buffers.v) to buffer incoming data on each port. A round-robin arbiter (RR_Arbiter.v) decides, cycle by cycle, which non-empty FIFO is allowed to send its data out, and this is combined with the FIFO buffers in FIFO_Arbiter_System.v. The arbitrated data stream is then handed to the Packet_Routing.v module, which decodes the destination field of each packet and steers it to the correct output port. These pieces come together in Router_TopModule.v, which is the top-level router.

Around the router, network.v adds three memory nodes (ram.v) that receive packets, service them, and send response packets back into the network, forming a small closed network rather than just a router in isolation. Port 3 is left open and connects straight to the testbench (n_tb.v), which drives input packets and checks that the corresponding responses come back correctly.

## 2. System Architecture

## 3. Design Files

### 3.1 FIFO_Memory.v — Synchronous FIFO

```verilog
module sync_fifo #(
parameter WIDTH = 8,
parameter DEPTH = 32
) (
input clk, rst_n,
input wr_en, r_en,
input [WIDTH - 1 : 0] data_in,
output empty, full,
output reg [WIDTH - 1 : 0] data_out
);

reg [$clog2(DEPTH) - 1 : 0] w_ptr, r_ptr; // $clog2 is ceiling of log base 2
reg [$clog2(DEPTH + 1) - 1 : 0] cnt;
reg [WIDTH - 1 : 0] mem [0 : DEPTH - 1];

assign empty = (cnt == 0);
assign full = (cnt == DEPTH);

always @(posedge clk) begin
if(!rst_n) begin
w_ptr <= 0;
r_ptr <= 0;
data_out <= 0;
cnt <= 0;
end else begin
if (wr_en && !full) begin
mem [w_ptr] <= data_in;
w_ptr <= w_ptr + 1;
end
if (r_en && !empty) begin
data_out <= mem[r_ptr];
r_ptr <= r_ptr + 1;
end

case ({wr_en && !full , r_en && !empty})
2'b10: begin
cnt <= cnt + 1;
end
2'b01: begin
cnt <= cnt - 1;
end
default: cnt <= cnt;
endcase
end
end
endmodule
```

### 3.2 Four_FIFO_Buffers.v — Four FIFO Buffers

```verilog
module Four_Fifo_Buffers #(
parameter DATA_WIDTH = 40
) (
input clk, rst_n, wr_en0 , wr_en1, wr_en2, wr_en3,
input r_en0, r_en1, r_en2, r_en3,
input [DATA_WIDTH - 1 : 0] data_in0, data_in1, data_in2, data_in3,
output empty0, empty1, empty2, empty3,
output full0, full1, full2, full3,
output [DATA_WIDTH - 1 : 0] data_out0, data_out1, data_out2, data_out3
);

sync_fifo #(
 .WIDTH(DATA_WIDTH),
 .DEPTH(16)
) FIFO0 (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en(wr_en0),
 .r_en(r_en0),
 .data_in(data_in0),
 .empty(empty0),
 .full(full0),
 .data_out(data_out0)
);

sync_fifo #(
 .WIDTH(DATA_WIDTH),
 .DEPTH(16)
) FIFO1 (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en(wr_en1),
 .r_en(r_en1),
 .data_in(data_in1),
 .empty(empty1),
 .full(full1),
 .data_out(data_out1)
);

sync_fifo #(
 .WIDTH(DATA_WIDTH),
 .DEPTH(16)
) FIFO2 (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en(wr_en2),
 .r_en(r_en2),
 .data_in(data_in2),
 .empty(empty2),
 .full(full2),
 .data_out(data_out2)
);

sync_fifo #(
 .WIDTH(DATA_WIDTH),
 .DEPTH(16)
) FIFO3 (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en(wr_en3),
 .r_en(r_en3),
 .data_in(data_in3),
 .empty(empty3),
 .full(full3),
 .data_out(data_out3)
);
endmodule
```

### 3.3 RR_Arbiter.v — Round Robin Arbiter

```verilog
module RR_Arbiter(
input clk, rst_n,
input empty0, empty1, empty2, empty3,
input Router_Ready,
output grant0, grant1, grant2, grant3
);

reg [3:0] grant_all;
assign {grant3 , grant2 , grant1 , grant0} = grant_all;
reg [1:0] current_state, next_state;
localparam [1:0] S_FIFO0 = 2'b00,
S_FIFO1 = 2'b01,
S_FIFO2 = 2'b10,
S_FIFO3 = 2'b11;
// current state logic
always @(posedge clk) begin
if (!rst_n) begin
current_state <= S_FIFO0;
end else begin
current_state <= next_state;
end
end
// next state logic
always @(*) begin
next_state = current_state;
if (Router_Ready) begin
case (grant_all)
4'b0001: next_state = S_FIFO1;
4'b0010: next_state = S_FIFO2;
4'b0100: next_state = S_FIFO3;
4'b1000: next_state = S_FIFO0;
default: next_state = current_state;
endcase
end
end
// Output logic 
always @(*) begin
case (current_state)
S_FIFO0: begin
if (!empty0)
grant_all = 4'b0001;
else if (!empty1)
grant_all = 4'b0010;
else if (!empty2)
grant_all = 4'b0100;
else if (!empty3)
grant_all = 4'b1000;
else
grant_all = 0;
end
S_FIFO1: begin
if (!empty1)
grant_all = 4'b0010;
else if (!empty2)
grant_all = 4'b0100;
else if (!empty3)
grant_all = 4'b1000;
else if (!empty0)
grant_all = 4'b0001;
else
grant_all = 0;
end
S_FIFO2: begin
if (!empty2)
grant_all = 4'b0100;
else if (!empty3)
grant_all = 4'b1000;
else if (!empty0)
grant_all = 4'b0001;
else if (!empty1)
grant_all = 4'b0010;
else
grant_all = 0;
end
S_FIFO3: begin
if (!empty3)
grant_all = 4'b1000;
else if (!empty0)
grant_all = 4'b0001;
else if (!empty1)
grant_all = 4'b0010;
else if (!empty2)
grant_all = 4'b0100;
else
grant_all = 0;
end
default: grant_all = 0;
endcase
end
endmodule
```

### 3.4 FIFO_Arbiter_System.v — FIFO + Arbiter Integration

```verilog
module FIFO_Arbiter_System #(
parameter DATA_WIDTH = 40
) (
input clk, rst_n,
input wr_en0, wr_en1, wr_en2, wr_en3,
input [DATA_WIDTH-1:0] data_in0, data_in1, data_in2, data_in3,
input Router_Ready,
output empty0, empty1, empty2, empty3,
output full0, full1, full2, full3,
output grant0, grant1, grant2, grant3,
output reg [DATA_WIDTH-1:0] data_out,
output packet_valid
);

wire r_en0, r_en1, r_en2, r_en3;
assign r_en0 = grant0 && Router_Ready;
assign r_en1 = grant1 && Router_Ready;
assign r_en2 = grant2 && Router_Ready;
assign r_en3 = grant3 && Router_Ready;
wire [DATA_WIDTH-1:0] data_out0, data_out1, data_out2, data_out3;
Four_Fifo_Buffers #(
 .DATA_WIDTH(DATA_WIDTH)
) FIFO_BUFFERS (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en0(wr_en0),
 .wr_en1(wr_en1),
 .wr_en2(wr_en2),
 .wr_en3(wr_en3),
 .r_en0(r_en0),
 .r_en1(r_en1),
 .r_en2(r_en2),
 .r_en3(r_en3),
 .data_in0(data_in0),
 .data_in1(data_in1),
 .data_in2(data_in2),
 .data_in3(data_in3),
 .empty0(empty0),
 .empty1(empty1),
 .empty2(empty2),
 .empty3(empty3),
 .full0(full0),
 .full1(full1),
 .full2(full2),
 .full3(full3),
 .data_out0(data_out0),
 .data_out1(data_out1),
 .data_out2(data_out2),
 .data_out3(data_out3)
);

RR_Arbiter ARBITER (
 .clk(clk),
 .rst_n(rst_n),
 .empty0(empty0),
 .empty1(empty1),
 .empty2(empty2),
 .empty3(empty3),
 .Router_Ready(Router_Ready),
 .grant0(grant0),
 .grant1(grant1),
 .grant2(grant2),
 .grant3(grant3)
);

reg [3:0] selected_fifo;
assign packet_valid = |selected_fifo;
always @(posedge clk) begin
if (!rst_n) begin
selected_fifo <= 4'b0000;
end
else if (Router_Ready) begin
selected_fifo <= {grant3, grant2, grant1, grant0};
end
end

always @(*) begin
case (selected_fifo)
4'b0001: data_out = data_out0;
4'b0010: data_out = data_out1;
4'b0100: data_out = data_out2;
4'b1000: data_out = data_out3;
default: data_out = {DATA_WIDTH{1'b0}};
endcase
end

endmodule
```

### 3.5 Packet_Routing.v — Packet Routing Module

```verilog
module Packet_Routing #(
parameter DATA_WIDTH = 24
) (
input clk, rst_n,
input [DATA_WIDTH-1:0] packet_in,
input packet_valid,
input port0_ready, port1_ready, port2_ready, port3_ready,
output reg [DATA_WIDTH-1:0] port0_data, port1_data, port2_data, port3_data,
output reg port0_valid, port1_valid, port2_valid, port3_valid
);

localparam Dest0 = 2'b00,
Dest1 = 2'b01,
Dest2 = 2'b10,
Dest3 = 2'b11;
reg [DATA_WIDTH-1:0] packet_reg;
reg [1:0] destination_reg;
reg packet_active;
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
packet_reg <= {DATA_WIDTH{1'b0}};
destination_reg <= 2'b00;
packet_active <= 1'b0;
end else begin
if (!packet_active) begin
if (packet_valid) begin
packet_reg <= packet_in;
destination_reg <= packet_in[DATA_WIDTH-1 : DATA_WIDTH-2];
packet_active <= 1'b1;
end
end else begin
case (destination_reg)
Dest0: if (port0_ready) packet_active <= 1'b0;
Dest1: if (port1_ready) packet_active <= 1'b0;
Dest2: if (port2_ready) packet_active <= 1'b0;
Dest3: if (port3_ready) packet_active <= 1'b0;
default: packet_active <= 1'b0;
endcase
end
end
end

always @(*) begin
port0_valid = 1'b0; port1_valid = 1'b0; port2_valid = 1'b0; port3_valid = 1'b0;
port0_data = {DATA_WIDTH{1'b0}}; port1_data = {DATA_WIDTH{1'b0}};
port2_data = {DATA_WIDTH{1'b0}}; port3_data = {DATA_WIDTH{1'b0}};

if (packet_active) begin
case (destination_reg)
Dest0: begin port0_valid = 1'b1; port0_data = packet_reg; end
Dest1: begin port1_valid = 1'b1; port1_data = packet_reg; end
Dest2: begin port2_valid = 1'b1; port2_data = packet_reg; end
Dest3: begin port3_valid = 1'b1; port3_data = packet_reg; end
endcase
end
end
endmodule
```

### 3.6 ram.v — Memory Node

```verilog
// Memory node with destination parameter to route response packets to Port 3 (Testbench)
module ram_network_node_fixed #(
parameter DATA_WIDTH = 24,
parameter ADDR_WIDTH = 5,
parameter RAM_DEPTH = 32,
parameter [1:0] RESP_DEST = 2'b11 // Destination for read response packets
) (
input clk, rst_n, rx_valid,
input [DATA_WIDTH-1:0] rx_data,
input fifo_full,
output reg rx_ready,
output reg [DATA_WIDTH-1:0] tx_data,
output reg tx_wr_en
);

reg [15:0] mem [0:RAM_DEPTH-1];
localparam [1:0] S_IDLE = 2'b00,
S_SEND_RESP = 2'b01,
S_DONE = 2'b10;
reg [1:0] state;
reg [ADDR_WIDTH-1:0] saved_addr;
reg [15:0] saved_data;

wire pkt_rw = rx_data[21];
wire [ADDR_WIDTH-1:0] pkt_addr = rx_data[20:16];
wire [15:0] pkt_data = rx_data[15:0];
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
state <= S_IDLE;
rx_ready <= 1'b1;
tx_wr_en <= 1'b0;
tx_data <= {DATA_WIDTH{1'b0}};
saved_addr <= {ADDR_WIDTH{1'b0}};
saved_data <= 16'h0000;
end else begin
case (state)
S_IDLE: begin
tx_wr_en <= 1'b0;
rx_ready <= 1'b1;
if (rx_valid && rx_ready) begin
if (pkt_rw == 1'b1) begin
mem[pkt_addr] <= pkt_data;
end else begin
saved_addr <= pkt_addr;
saved_data <= mem[pkt_addr];
rx_ready <= 1'b0;
state <= S_SEND_RESP;
end
end
end
S_SEND_RESP: begin
if (!fifo_full) begin
tx_data <= {RESP_DEST, 1'b0, saved_addr, saved_data};
tx_wr_en <= 1'b1;
state <= S_DONE;
end else begin
tx_wr_en <= 1'b0;
end
end
S_DONE: begin
tx_wr_en <= 1'b0;
rx_ready <= 1'b1;
state <= S_IDLE;
end
default: state <= S_IDLE;
endcase
end
end
endmodule
```

### 3.7 network.v — Network System Top

```verilog
// Structural wrapper wiring Ports 0, 1, 2 to memories and exposing Port 3 to TB
module Network_System_Top (
input clk, rst_n, Router_Ready, tb_wr_en,
input [23:0] tb_data_in,
input tb_port3_ready,
output wire [23:0] tb_port3_data,
output tb_port3_valid,
output tb_fifo3_full,
output tb_fifo3_empty
);

wire wr_en0, wr_en1, wr_en2;
wire [23:0] data_in0, data_in1, data_in2;
wire [23:0] port0_data, port1_data, port2_data;
wire port0_valid, port1_valid, port2_valid;
wire port0_ready, port1_ready, port2_ready;
wire full0, full1, full2;
wire empty0, empty1, empty2;
Router_Top #(.DATA_WIDTH(24)) router_inst (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en0(wr_en0), .wr_en1(wr_en1), .wr_en2(wr_en2), .wr_en3(tb_wr_en),
 .data_in0(data_in0), .data_in1(data_in1), .data_in2(data_in2), .data_in3(tb_data_in),
 .Router_Ready(Router_Ready),
 .port0_ready(port0_ready), .port1_ready(port1_ready), .port2_ready(port2_ready), .port3_ready(tb_port3_ready),
 .port0_data(port0_data), .port1_data(port1_data), .port2_data(port2_data), .port3_data(tb_port3_data),
 .port0_valid(port0_valid), .port1_valid(port1_valid), .port2_valid(port2_valid), .port3_valid(tb_port3_valid),
 .empty0(empty0), .empty1(empty1), .empty2(empty2), .empty3(tb_fifo3_empty),
 .full0(full0), .full1(full1), .full2(full2), .full3(tb_fifo3_full)
);

ram_network_node_fixed
#(.DATA_WIDTH(24), .ADDR_WIDTH(5), .RAM_DEPTH(32), .RESP_DEST(2'b11)) node0 (
 .clk(clk), .rst_n(rst_n),
 .rx_valid(port0_valid), .rx_data(port0_data), .rx_ready(port0_ready),
 .tx_wr_en(wr_en0), .tx_data(data_in0), .fifo_full(full0)
);

ram_network_node_fixed
#(.DATA_WIDTH(24), .ADDR_WIDTH(5), .RAM_DEPTH(32), .RESP_DEST(2'b11)) node1 (
 .clk(clk), .rst_n(rst_n),
 .rx_valid(port1_valid), .rx_data(port1_data), .rx_ready(port1_ready),
 .tx_wr_en(wr_en1), .tx_data(data_in1), .fifo_full(full1)
);

ram_network_node_fixed
#(.DATA_WIDTH(24), .ADDR_WIDTH(5), .RAM_DEPTH(32), .RESP_DEST(2'b11)) node2 (
 .clk(clk), .rst_n(rst_n),
 .rx_valid(port2_valid), .rx_data(port2_data), .rx_ready(port2_ready),
 .tx_wr_en(wr_en2), .tx_data(data_in2), .fifo_full(full2)
);

endmodule
```

### 3.8 Router_TopModule.v — Router Top Module

```verilog
module Router_Top #(
parameter DATA_WIDTH = 24
) (
input clk, rst_n,
input wr_en0, wr_en1, wr_en2, wr_en3,
input [DATA_WIDTH-1:0] data_in0, data_in1, data_in2, data_in3,
input Router_Ready,
input port0_ready, port1_ready, port2_ready, port3_ready,
output [DATA_WIDTH-1:0] port0_data, port1_data, port2_data, port3_data,
output port0_valid, port1_valid, port2_valid, port3_valid,
output empty0, empty1, empty2, empty3,
output full0, full1, full2, full3
);

wire grant0, grant1, grant2, grant3;
wire [DATA_WIDTH-1:0] data_out;
wire packet_valid;
FIFO_Arbiter_System #(.DATA_WIDTH(DATA_WIDTH)) inst_arb (
 .clk(clk),
 .rst_n(rst_n),
 .wr_en0(wr_en0),
 .wr_en1(wr_en1),
 .wr_en2(wr_en2),
 .wr_en3(wr_en3),
 .data_in0(data_in0),
 .data_in1(data_in1),
 .data_in2(data_in2),
 .data_in3(data_in3),
 .Router_Ready(Router_Ready),
 .empty0(empty0),
 .empty1(empty1),
 .empty2(empty2),
 .empty3(empty3),
 .full0(full0),
 .full1(full1),
 .full2(full2),
 .full3(full3),
 .grant0(grant0),
 .grant1(grant1),
 .grant2(grant2),
 .grant3(grant3),
 .data_out(data_out),
 .packet_valid(packet_valid)
);

Packet_Routing #(.DATA_WIDTH(DATA_WIDTH)) inst_rout (
 .clk(clk),
 .rst_n(rst_n),
 .packet_in(data_out),
 .packet_valid(packet_valid),
 .port0_ready(port0_ready),
 .port1_ready(port1_ready),
 .port2_ready(port2_ready),
 .port3_ready(port3_ready),
 .port0_valid(port0_valid),
 .port1_valid(port1_valid),
 .port2_valid(port2_valid),
 .port3_valid(port3_valid),
 .port0_data(port0_data),
 .port1_data(port1_data),
 .port2_data(port2_data),
 .port3_data(port3_data)
);
endmodule
```

## 4. Testbench

### 4.1 n_tb.v — Network Testbench

```verilog
`timescale 1ns / 1ps
module tb_Network_System;
reg clk;
reg rst_n;
reg Router_Ready;
reg tb_wr_en;
reg [23:0] tb_data_in;
reg tb_port3_ready;
wire [23:0] tb_port3_data;
wire tb_port3_valid;
wire tb_fifo3_full;
wire tb_fifo3_empty;
Network_System_Top uut (
 .clk(clk),
 .rst_n(rst_n),
 .Router_Ready(Router_Ready),
 .tb_wr_en(tb_wr_en),
 .tb_data_in(tb_data_in),
 .tb_port3_ready(tb_port3_ready),
 .tb_port3_data(tb_port3_data),
 .tb_port3_valid(tb_port3_valid),
 .tb_fifo3_full(tb_fifo3_full),
 .tb_fifo3_empty(tb_fifo3_empty)
);
// 10ns Clock generation (100MHz)
always #5 clk = ~clk;
// Task to dispatch a write packet into Port 3 FIFO
task send_write(input [1:0] dest, input [4:0] addr, input [15:0] data);
begin
@(posedge clk);
while (tb_fifo3_full) @(posedge clk);
tb_data_in <= {dest, 1'b1, addr, data};
tb_wr_en <= 1'b1;
@(posedge clk);
tb_wr_en <= 1'b0;
end
endtask
// Task to dispatch a read request packet into Port 3 FIFO
task send_read(input [1:0] dest, input [4:0] addr);
begin
@(posedge clk);
while (tb_fifo3_full) @(posedge clk);
tb_data_in <= {dest, 1'b0, addr, 16'h0000};
tb_wr_en <= 1'b1;
@(posedge clk);
tb_wr_en <= 1'b0;
end
endtask
// Task to receive and check response on Port 3
task wait_read_response(input [4:0] exp_addr, input [15:0] exp_data);
begin
while (!tb_port3_valid) @(posedge clk);
if (tb_port3_data[20:16] === exp_addr && tb_port3_data[15:0] === exp_data) begin
$display("[PASS] TB Read Verification: Addr = 0x%0h | Data = 0x%04h",
tb_port3_data[20:16], tb_port3_data[15:0]);
end else begin
$display("[FAIL] TB Read Verification: Expected Addr = 0x%0h, Data = 0x%04h | Got Addr = 0x%0h, Data = 0x%04h",
exp_addr, exp_data, tb_port3_data[20:16], tb_port3_data[15:0]);
end
@(posedge clk);
end
endtask
initial begin
clk = 0;
rst_n = 0;
Router_Ready = 1;
tb_wr_en = 0;
tb_data_in = 24'd0;
tb_port3_ready = 1;
// Reset Sequence
#20;
rst_n = 1;
#20;
$display("--- Step 1: Writing data to memories 0, 1, and 2 ---");
send_write(2'b00, 5'd4, 16'hA1B2); // Node 0, Addr 4
send_write(2'b01, 5'd10, 16'hC3D4); // Node 1, Addr 10
send_write(2'b10, 5'd31, 16'hE5F6); // Node 2, Addr 31
#150;
$display("--- Step 2: Reading back data and checking responses on Port 3 ---");
send_read(2'b00, 5'd4);
wait_read_response(5'd4, 16'hA1B2);
send_read(2'b01, 5'd10);
wait_read_response(5'd10, 16'hC3D4);
send_read(2'b10, 5'd31);
wait_read_response(5'd31, 16'hE5F6);
#100;
$display("--- All Operations Finished ---");
$stop;
end
endmodule
```

## 5. Simulation Results

### 5.1 Waveforms
<img width="869" height="318" alt="image" src="https://github.com/user-attachments/assets/5754671f-2fa8-4b48-be25-6cd49b7c933d" />
<img width="838" height="477" alt="image" src="https://github.com/user-attachments/assets/09273bda-ecfe-4eb8-b9b9-dc4891a78f95" />
<img width="975" height="340" alt="image" src="https://github.com/user-attachments/assets/244707a4-e851-4cb3-83ce-248011390af3" />

## 6. Synthesis

### 6.1 RTL Schematic
<img width="561" height="971" alt="image" src="https://github.com/user-attachments/assets/0e19f675-ade8-4982-9f84-5e8367164e1c" />

<img width="986" height="546" alt="image" src="https://github.com/user-attachments/assets/68d9d1f8-96e2-44e2-839f-ebd21ce1b54d" />


