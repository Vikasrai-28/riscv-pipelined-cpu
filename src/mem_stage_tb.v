`timescale 1ns / 1ps

module mem_stage_tb;

    reg clk;
    reg reset;

    reg [31:0] alu_result_m;
    reg [31:0] rs2_data_m;
    reg [4:0]  rd_m;
    reg [6:0]  opcode_m;
    reg [2:0]  funct3_m;

    wire [31:0] mem_data_w;
    wire [31:0] alu_result_w;
    wire [4:0]  rd_w;
    wire        mem_to_reg_w;

    // DUT
    mem_stage dut (
        .clk(clk),
        .reset(reset),
        .alu_result_m(alu_result_m),
        .rs2_data_m(rs2_data_m),
        .rd_m(rd_m),
        .opcode_m(opcode_m),
        .funct3_m(funct3_m),
        .mem_data_w(mem_data_w),
        .alu_result_w(alu_result_w),
        .rd_w(rd_w),
        .mem_to_reg_w(mem_to_reg_w)
    );

    // 10ns clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        alu_result_m = 0;
        rs2_data_m   = 0;
        rd_m         = 0;
        opcode_m     = 0;
        funct3_m     = 0;

        // Reset for 2 cycles
        repeat (2) @(posedge clk);
        reset = 0;

        // -----------------------------------
        // STORE WORD
        // SW x?, 0x20
        // -----------------------------------
        @(negedge clk);
        alu_result_m = 32'h00000020;
        rs2_data_m   = 32'hCAFEBABE;
        opcode_m     = 7'h23;   // STORE
        funct3_m     = 3'b010;
        rd_m         = 5'd0;

        @(posedge clk); // write happens here

        // -----------------------------------
        // LOAD WORD
        // LW x5, 0x20
        // -----------------------------------
        @(negedge clk);
        alu_result_m = 32'h00000020;
        opcode_m     = 7'h03;   // LOAD
        funct3_m     = 3'b010;
        rd_m         = 5'd5;

        @(posedge clk); // read happens here

        // -----------------------------------
        // CHECK
        // -----------------------------------
        #1;
        $display("Loaded data = %h (expect CAFEBABE)", mem_data_w);
        $display("mem_to_reg  = %b (expect 1)", mem_to_reg_w);
        $display("rd_w        = %d (expect 5)", rd_w);

        #20;
        $finish;
    end

endmodule
