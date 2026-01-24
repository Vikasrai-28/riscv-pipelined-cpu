`timescale 1ns / 1ps

module alu_control (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7_5,   // instr[30]
    output reg  [3:0] alu_ctrl
);

    always @(*) begin
        case (opcode)
            7'b0010011: begin // ADDI
                alu_ctrl = 4'b0000; // ADD
            end

            7'b0110011: begin // R-type
                if (funct3 == 3'b000 && funct7_5)
                    alu_ctrl = 4'b0001; // SUB
                else
                    alu_ctrl = 4'b0000; // ADD
            end

            default: alu_ctrl = 4'b0000;
        endcase
    end

endmodule
