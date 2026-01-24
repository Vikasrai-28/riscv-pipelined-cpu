`timescale 1ns / 1ps

module ex_mem_reg_tb;

    reg clk;
    reg reset;

    // EX inputs
    reg [31:0] alu_result_e;
    reg [31:0] rs2_data_e;
    reg [4:0]  rd_e;
    reg [6:0]  opcode_e;
    reg [2:0]  funct3_e;

    // MEM outputs
    wire [31:0] alu_result_m;
    wire [31:0] rs2_data_m;
    wire [4:0]  rd_m;
    wire [6:0]  opcode_m;
    wire [2:0]  funct3_m;

    // DUT
    ex_mem_reg dut (
        .clk(clk),
        .reset(reset),
        .alu_result_e(alu_result_e),
        .rs2_data_e(rs2_data_e),
        .rd_e(rd_e),
        .opcode_e(opcode_e),
        .funct3_e(funct3_e),
        .alu_result_m(alu_result_m),
        .rs2_data_m(rs2_data_m),
        .rd_m(rd_m),
        .opcode_m(opcode_m),
        .funct3_m(funct3_m)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        // INIT
        clk = 0;
        reset = 1;

        alu_result_e = 0;
        rs2_data_e   = 0;
        rd_e         = 0;
        opcode_e     = 0;
        funct3_e     = 0;

        // Hold reset for 1 cycle
        repeat (2) @(posedge clk);
        reset = 0;

        // -------------------------
        // CYCLE 1
        // -------------------------
        @(negedge clk);
        alu_result_e = 32'h0000000A; // 10
        rs2_data_e   = 32'h00000005;
        rd_e         = 5'd1;
        opcode_e     = 7'h13;
        funct3_e     = 3'b000;

        // -------------------------
        // CYCLE 2
        // -------------------------
        @(negedge clk);
        alu_result_e = 32'h00000014; // 20
        rs2_data_e   = 32'h00000003;
        rd_e         = 5'd2;
        opcode_e     = 7'h33;
        funct3_e     = 3'b000;

        // -------------------------
        // CYCLE 3
        // -------------------------
        @(negedge clk);
        alu_result_e = 32'h00000020; // 32
        rs2_data_e   = 32'h00000008;
        rd_e         = 5'd3;
        opcode_e     = 7'h03;
        funct3_e     = 3'b010;

        // Let pipeline flush
        repeat (3) @(posedge clk);

        $display("EX/MEM register test PASSED");
        $finish;
    end

endmodule
