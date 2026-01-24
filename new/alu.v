`timescale 1ns / 1ps

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_ctrl,
    output reg  [31:0] result
);

    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a + b;   // ADD / ADDI
            4'b0001: result = a - b;   // SUB
            default: result = 32'b0;
        endcase
    end

endmodule
