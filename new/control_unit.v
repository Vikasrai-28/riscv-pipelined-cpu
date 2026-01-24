`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,

    output reg        reg_write,
    output reg        alu_src,
    output reg        branch
);

    always @(*) begin
        // -------- DEFAULTS --------
        reg_write = 1'b0;
        alu_src   = 1'b0;
        branch    = 1'b0;

        case (opcode)

            // ADDI
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end

            // R-type (ADD, SUB)
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
            end

            // BEQ
            7'b1100011: begin
                branch    = 1'b1;
                reg_write = 1'b0;   // ✅ CRITICAL
                alu_src   = 1'b0;
            end

            default: begin
                // NOP
            end
        endcase
    end

endmodule
