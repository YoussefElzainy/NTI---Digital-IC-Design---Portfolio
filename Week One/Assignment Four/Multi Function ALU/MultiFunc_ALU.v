module MultiFuncALU (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    input [4:0] Control,
    output reg [15:0] Out
);

    reg [15:0] temp;

    always @(*) begin

        Out = 16'd0;
        temp = 16'd0;

        case (Control)

            5'b00000: Out = A + B;
            5'b00001: Out = A + B + Cin;
            5'b00010: Out = A - B + Cin;
            5'b00011: Out = A - B;
            5'b00100: Out = A + 1;
            5'b00101: Out = A - 1;
            5'b00110: Out = A * B + 1;

            5'b00111: Out = A & B;
            5'b01000: Out = A | B;
            5'b01001: Out = A ^ B;
            5'b01010: Out = ~A;
            5'b01011: Out = ~(A & B);

            5'b01100: Out = A << B;
            5'b01101: Out = A >> B;
            5'b01110: Out = A <<< B;
            5'b01111: Out = $signed(A) >>> B;

            5'b10000: begin
                if (B == 0)
                    Out = {8'd0, A};
                else
                    Out = {8'd0, ((A >> B) | (A << (8-B)))};
            end

            5'b10001: begin
                if (B == 0)
                    Out = {8'd0, A};
                else
                    Out = {8'd0, ((A << B) | (A >> (8-B)))};
            end

            5'b10010: Out = (A >= B) ? A : B;

            5'b10011: Out = Cin ? B : A;

           5'b10100: Out = {~B, ~A};

            5'b10101: Out = {
                10'd0,
                A >= B,
                A > B,
                A == B,
                A <= B,
                A < B,
                A != B
            };
            5'b10110: Out = {
                13'd0,
                ~^B,
                ^A
            };

            default: Out = 16'd0;

        endcase
    end

endmodule