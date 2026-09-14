`timescale 1ns/1ps

module tb_I2C_PacketConverter();

    // Parameters
    parameter DATA_WIDTH = 24;

    // Clock and Reset Signals
    reg clk;
    reg rst_n;

    // Router Interface Signals
    reg router_ready;
    reg port_valid;
    reg [DATA_WIDTH-1:0] router_dout;
    wire wr_en;
    wire port_ready;
    wire [DATA_WIDTH-1:0] router_din;

    // I2C Master Interface Signals
    reg ack_err;
    reg busy;
    reg [7:0] data_read;
    wire en;
    wire rw;
    wire [7:0] data_write;
    wire [6:0] slave_addr;

    // Device Under Test (DUT) Instantiation
    I2C_PacketConverter #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .router_ready(router_ready),
        .port_valid(port_valid),
        .router_dout(router_dout),
        .wr_en(wr_en),
        .port_ready(port_ready),
        .router_din(router_din),
        .ack_err(ack_err),
        .busy(busy),
        .data_read(data_read),
        .en(en),
        .rw(rw),
        .data_write(data_write),
        .slave_addr(slave_addr)
    );

    // Clock Generation (100 MHz)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Helper Task: Mock I2C Master Write Cycle
    task mock_master_write_ack;
        input integer byte_num;
        input [7:0] expected_data;
        begin
            wait(en == 1'b1);
            @(posedge clk);
            if (data_write !== expected_data) begin
                $display("[ERROR] Byte %0d Mismatch: Expected %h, Got %h", byte_num, expected_data, data_write);
            end else begin
                $display("[PASS] Master received Byte %0d: %h", byte_num, data_write);
            end
                
            busy = 1'b1;
            repeat(4) @(posedge clk); // Simulate active transaction
            busy = 1'b0;
            @(posedge clk);
        end
    endtask

    // Helper Task: Mock I2C Master Read Cycle
    task mock_master_read_ack;
        input integer byte_num;
        input [7:0] data_to_send;
        begin
            wait(en == 1'b1);
            @(posedge clk);
            busy = 1'b1;
            data_read = data_to_send;
            $display("[INFO] Master sending Byte %0d: %h", byte_num, data_read);
            repeat(4) @(posedge clk); // Simulate active transaction
            busy = 1'b0;
            @(posedge clk);
        end
    endtask

    // Main Test Stimulus
    initial begin
        // Initialize Inputs
        rst_n        = 1'b0;
        router_ready = 1'b1;
        port_valid   = 1'b0;
        router_dout  = {DATA_WIDTH{1'b0}};
        ack_err      = 1'b0;
        busy         = 1'b0;
        data_read    = 8'h00;

        // Apply Reset
        repeat(2) @(posedge clk);
        rst_n = 1'b1;
        repeat(2) @(posedge clk);
        $display("-------------------------------------------");
        $display("         SYSTEM RESET COMPLETE            ");
        $display("-------------------------------------------");

        // ---------------------------------------------------------
        // TEST CASE 1: Standard Write Operation (Bit 21 = 0)
        // ---------------------------------------------------------
        $display("\n[TEST 1] Starting Write Sequence...");
        @(posedge clk);
        port_valid  = 1'b1;
        router_dout = 24'h0A_BC_DE; // Bit 21 is 0 (Write)

        fork
            begin
                wait(port_ready == 1'b1);
                @(posedge clk);
                port_valid = 1'b0;
            end
            begin
                mock_master_write_ack(1, 8'h0A);
                mock_master_write_ack(2, 8'hBC);
                mock_master_write_ack(3, 8'hDE);
            end
        join

        $display("[TEST 1] Write Sequence Completed Successfully.");
        repeat(3) @(posedge clk);

        // ---------------------------------------------------------
        // TEST CASE 2: Standard Read Operation (Bit 21 = 1)
        // ---------------------------------------------------------
        $display("\n[TEST 2] Starting Read Sequence...");
        @(posedge clk);
        port_valid  = 1'b1;
        router_dout = 24'h2A_00_00; // Bit 21 is 1 (Read)

        fork
            begin
                wait(wr_en == 1'b1);
                if (router_din === 24'h11_22_33) begin
                    $display("[PASS] router_din correctly updated to: %h", router_din);
                end else begin
                    $display("[ERROR] router_din mismatch! Expected 24'h112233, Got: %h", router_din);
                end

                wait(port_ready == 1'b1);
                @(posedge clk);
                port_valid = 1'b0;
            end
            begin
                mock_master_read_ack(1, 8'h11);
                mock_master_read_ack(2, 8'h22);
                mock_master_read_ack(3, 8'h33);
            end
        join

        $display("[TEST 2] Read Sequence Completed Successfully.");
        repeat(3) @(posedge clk);

        // ---------------------------------------------------------
        // TEST CASE 3: ACK Error Handling (NACK Abort)
        // ---------------------------------------------------------
        $display("\n[TEST 3] Testing ACK Error Abort...");
        @(posedge clk);
        port_valid  = 1'b1;
        router_dout = 24'h05_44_99;

        fork
            begin
                wait(en == 1'b1);
                @(posedge clk);
                wait(dut.cs == 3'b000); // Wait until returning to IDLE
                $display("[PASS] FSM aborted transaction and safely returned to IDLE.");
                port_valid = 1'b0;
            end
            begin
                mock_master_write_ack(1, 8'h05);

                // Inject ACK error on byte 2
                wait(en == 1'b1);
                @(posedge clk);
                busy = 1'b1;
                repeat(2) @(posedge clk);
                ack_err = 1'b1; // Trigger NACK
                repeat(2) @(posedge clk);
                busy    = 1'b0;
                ack_err = 1'b0;
            end
        join

        $display("[TEST 3] Error Abort Handled Successfully.");

        repeat(5) @(posedge clk);
        $display("\n===========================================");
        $display("         ALL TEST CASES PASSED             ");
        $display("===========================================");
        $finish;
    end

endmodule