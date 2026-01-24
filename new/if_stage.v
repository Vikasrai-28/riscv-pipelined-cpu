`timescale 1ns / 1ps

module if_stage (
    input  wire        clk,
    input  wire        reset,
    input  wire        pc_write,
    input  wire        pc_src,
    input  wire [31:0] pc_branch,

    output reg  [31:0] pc,
    output wire [31:0] instr_f
);

    wire [31:0] pc_plus4 = pc + 32'd4;
    wire [31:0] pc_next  = pc_src ? pc_branch : pc_plus4;

    instr_mem IMEM (
        .addr  (pc),
        .instr (instr_f)
    );

    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;
        else if (pc_write)
            pc <= pc_next;
    end

endmodule
