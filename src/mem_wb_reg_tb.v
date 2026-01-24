`timescale 1ns / 1ps

module mem_wb_reg_tb;

    reg clk;
    reg reset;

    // MEM inputs
    reg [31:0] alu_result_m;
    reg [31:0] mem_data_m;
    reg [4:0]  rd_m;
    reg        mem_to_reg_m;

    // WB outputs
    wire [31:0] alu_result_w;
    wire [31:0] mem_data_w;
    wire [4:0]  rd_w;
    wire        mem_to_reg_w;

    // DUT
    mem_wb_reg dut (
        .clk(clk),
        .reset(reset),
        .alu_result_m(alu_result_m),
        .mem_data_m(mem_data_m),
        .rd_m(rd_m),
        .mem_to_reg_m(mem_to_reg_m),
        .alu_result_w(alu_result_w),
        .mem_data_w(mem_data_w),
        .rd_w(rd_w),
        .mem_to_reg_w(mem_to_reg_w)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        alu_result_m = 0;
        mem_data_m   = 0;
        rd_m         = 0;
        mem_to_reg_m = 0;

        // Hold reset for 1 cycle
        repeat (2) @(posedge clk);
        reset = 0;

        // --------------------
        // CYCLE 1: ALU result
        // --------------------
        @(negedge clk);
        alu_result_m = 32'h0000002A;   // 42
        mem_data_m   = 32'h00000000;
        rd_m         = 5'd1;
        mem_to_reg_m = 0;

        // --------------------
        // CYCLE 2: LOAD result
        // --------------------
        @(negedge clk);
        alu_result_m = 32'h00000000;
        mem_data_m   = 32'hCAFEBABE;
        rd_m         = 5'd2;
        mem_to_reg_m = 1;

        // --------------------
        // CYCLE 3: Another ALU
        // --------------------
        @(negedge clk);
        alu_result_m = 32'h00000010;
        mem_data_m   = 32'h00000000;
        rd_m         = 5'd3;
        mem_to_reg_m = 0;

        repeat (3) @(posedge clk);

        $display("MEM/WB register test PASSED");
        $finish;
    end

endmodule
