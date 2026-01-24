`timescale 1ns / 1ps

module if_id_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        if_id_write,
    input  wire        flush,

    input  wire [31:0] pc_f,
    input  wire [31:0] instr_f,

    output reg  [31:0] pc_d,
    output reg  [31:0] instr_d
);

    always @(posedge clk) begin
        // RESET or FLUSH → INSERT NOP
        if (reset || flush) begin
            pc_d    <= 32'b0;
            instr_d <= 32'b0;
        end
        // NORMAL PIPELINE FLOW
        else if (if_id_write) begin
            pc_d    <= pc_f;
            instr_d <= instr_f;
        end
        // else: HOLD value (stall)
    end

endmodule
