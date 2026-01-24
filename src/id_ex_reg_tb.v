`timescale 1ns / 1ps

module id_ex_reg_tb;

    reg clk;
    reg reset;

    reg [31:0] rs1_data_d;
    reg [31:0] rs2_data_d;
    reg [31:0] imm_d;
    reg [4:0]  rs1_d;
    reg [4:0]  rs2_d;
    reg [4:0]  rd_d;
    reg [2:0]  funct3_d;
    reg [6:0]  opcode_d;

    wire [31:0] rs1_data_e;
    wire [31:0] rs2_data_e;
    wire [31:0] imm_e;
    wire [4:0]  rs1_e;
    wire [4:0]  rs2_e;
    wire [4:0]  rd_e;
    wire [2:0]  funct3_e;
    wire [6:0]  opcode_e;

    id_ex_reg dut (
        .clk(clk),
        .reset(reset),
        .rs1_data_d(rs1_data_d),
        .rs2_data_d(rs2_data_d),
        .imm_d(imm_d),
        .rs1_d(rs1_d),
        .rs2_d(rs2_d),
        .rd_d(rd_d),
        .funct3_d(funct3_d),
        .opcode_d(opcode_d),
        .rs1_data_e(rs1_data_e),
        .rs2_data_e(rs2_data_e),
        .imm_e(imm_e),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .rd_e(rd_e),
        .funct3_e(funct3_e),
        .opcode_e(opcode_e)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        rs1_data_d = 32'h00000000;
        rs2_data_d = 32'h00000000;
        imm_d      = 32'h0000000A;
        rs1_d      = 5'd0;
        rs2_d      = 5'd0;
        rd_d       = 5'd1;
        funct3_d   = 3'b000;
        opcode_d   = 7'b0010011;

        #10 reset = 0;

        #10;  // first latch

        $display("EX imm = %0d (expect 10)", imm_e);
        $display("EX rd  = %0d (expect 1)", rd_e);

        #20 $finish;
    end

endmodule
