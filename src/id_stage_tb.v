`timescale 1ns / 1ps

module id_stage_tb;

    reg         clk;
    reg         reset;
    reg [31:0]  instr;

    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [2:0]  funct3;
    wire [6:0]  opcode;
    wire [31:0] imm;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // DUT
    id_stage dut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .opcode(opcode),
        .imm(imm),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Init
        clk   = 0;
        reset = 1;
        instr = 32'b0;

        #10;
        reset = 0;

        // ADDI x1, x0, 10  -> 0x00A00093
        instr = 32'h00A00093;

        #20;

        // Display checks
        $display("opcode   = %b (expect 0010011)", opcode);
        $display("rs1      = %0d (expect 0)", rs1);
        $display("rd       = %0d (expect 1)", rd);
        $display("funct3   = %b (expect 000)", funct3);
        $display("imm      = %0d (expect 10)", imm);
        $display("rs1_data = %0d (expect 0)", rs1_data);

        #20;
        $finish;
    end

endmodule
