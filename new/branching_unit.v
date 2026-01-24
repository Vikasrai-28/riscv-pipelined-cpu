`timescale 1ns / 1ps

module branching_unit (
    input  wire [31:0] pc_e,
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    input  wire [31:0] imm,
    input  wire        branch,

    output reg         taken,
    output wire [31:0] target
);

    assign target = pc_e + imm;

    always @(*) begin
        taken = 0;
        if (branch && (rs1 == rs2))
            taken = 1;
    end

endmodule
