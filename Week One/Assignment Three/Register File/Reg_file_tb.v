module Reg_file_tb;

    reg clk, write_en;
    reg [2:0] read_add, write_add;
    reg [15:0] write_data;
    wire [15:0] read_data;
    wire [7:0] read_data_top_byte;

    Reg_file dut (
        clk, write_en, read_add, write_add,
        write_data, read_data, read_data_top_byte
    );


    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        $readmemh("mem_file.mem", dut.register_file);

        $display("--------------------------------------------------------------------------");
        $display(" Time | WE | R_ADD | W_ADD |   W_DATA   |   R_DATA   |  TOP_BYTE");
        $display("--------------------------------------------------------------------------");

        $monitor("%5t | %2b | %5d | %5d | %10h | %10h | %8h",
                $time,
                write_en,
                read_add,
                write_add,
                write_data,
                read_data,
                read_data_top_byte);
        

        // THIS TABLE IS AI GENERATED :)    

        repeat (2) begin
            write_en = 0;
            read_add = $random;
            write_add = $random;
            write_data = $random;

            @(negedge clk);
        end

        repeat (25) begin
            write_en = 1;
            read_add = $random;
            write_add = $random;
            write_data = $random;

            @(negedge clk);
        end

        
        

        $finish;
        
    end


endmodule