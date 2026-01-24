`timescale 1ns / 1ps

module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        flush,          // <<< ADD
    input  wire [31:0] alu_result_e,
    input  wire [4:0]  rd_e,
    input  wire        reg_write_e,

    output reg  [31:0] alu_result_m,
    output reg  [4:0]  rd_m,
    output reg         reg_write_m
);

    always @(posedge clk) begin
        if (reset || flush) begin
            alu_result_m <= 32'b0;
            rd_m         <= 5'b0;
            reg_write_m  <= 1'b0;   // <<< KILL WB
        end else begin
            alu_result_m <= alu_result_e;
            rd_m         <= rd_e;
            reg_write_m  <= reg_write_e;
        end
    end

endmodule
