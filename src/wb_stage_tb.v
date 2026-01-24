`timescale 1ns / 1ps

module wb_stage_tb;

    reg [31:0] alu_result_w;
    reg [31:0] mem_data_w;
    reg [4:0]  rd_w;
    reg        mem_to_reg_w;

    wire [31:0] wb_data;
    wire [4:0]  wb_rd;
    wire        wb_we;

    wb_stage dut (
        .alu_result_w(alu_result_w),
        .mem_data_w(mem_data_w),
        .rd_w(rd_w),
        .mem_to_reg_w(mem_to_reg_w),
        .wb_data(wb_data),
        .wb_rd(wb_rd),
        .wb_we(wb_we)
    );

    initial begin
        // ---------------------------
        // ALU instruction
        // ---------------------------
        alu_result_w = 32'h00000020;
        mem_data_w   = 32'hDEADBEEF;
        rd_w         = 5'd3;
        mem_to_reg_w = 0;
        #10;

        // ---------------------------
        // LOAD instruction
        // ---------------------------
        alu_result_w = 32'h00000000;
        mem_data_w   = 32'hCAFEBABE;
        rd_w         = 5'd5;
        mem_to_reg_w = 1;
        #10;

        // ---------------------------
        // x0 write (should disable)
        // ---------------------------
        alu_result_w = 32'hFFFFFFFF;
        mem_data_w   = 32'hAAAAAAAA;
        rd_w         = 5'd0;
        mem_to_reg_w = 0;
        #10;

        $display("WB STAGE TEST COMPLETED");
        $finish;
    end

endmodule
