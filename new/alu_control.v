`timescale 1ns / 1ps

module alu_control (
    input  wire [2:0] funct3,
    input  wire        funct7_5,
    input  wire [3:0]  alu_ctrl_in,
    output reg  [3:0]  alu_ctrl_out
);

    always @(*) begin
        alu_ctrl_out = alu_ctrl_in;

        case (funct3)
            3'b000: alu_ctrl_out = funct7_5 ? 4'b0001 : 4'b0000; // SUB / ADD
            3'b111: alu_ctrl_out = 4'b0010; // AND
            3'b110: alu_ctrl_out = 4'b0011; // OR
            3'b100: alu_ctrl_out = 4'b0100; // XOR
            3'b010: alu_ctrl_out = 4'b0101; // SLT
            3'b001: alu_ctrl_out = 4'b0110; // SLL
            3'b101: alu_ctrl_out = 4'b0111; // SRL
        endcase
    end

endmodule
