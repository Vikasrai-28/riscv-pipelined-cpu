`timescale 1ns / 1ps

module ex_stage_tb;

    reg [31:0] rs1_data_e;
    reg [31:0] rs2_data_e;
    reg [31:0] imm_e;
    reg [4:0]  rd_e;
    reg [2:0]  funct3_e;
    reg [6:0]  opcode_e;
    reg        funct7_5_e;

    wire [31:0] alu_result;
    wire [4:0]  rd_out;

    ex_stage dut (
        .rs1_data_e(rs1_data_e),
        .rs2_data_e(rs2_data_e),
        .imm_e(imm_e),
        .rd_e(rd_e),
        .funct3_e(funct3_e),
        .opcode_e(opcode_e),
        .funct7_5_e(funct7_5_e),
        .alu_result(alu_result),
        .rd_out(rd_out)
    );

    initial begin
        // ADDI x1, x0, 10
        rs1_data_e = 32'd0;
        rs2_data_e = 32'd0;
        imm_e      = 32'd10;
        rd_e       = 5'd1;
        funct3_e   = 3'b000;
        opcode_e   = 7'b0010011;
        funct7_5_e = 1'b0;

        #10;

        $display("ALU result = %0d (expect 10)", alu_result);
        $display("rd_out     = %0d (expect 1)", rd_out);

        #10 $finish;
    end

endmodule
