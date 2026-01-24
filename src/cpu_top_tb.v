`timescale 1ns / 1ps

module cpu_top_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;
    wire [31:0] instr;
    wire        wb_we;
    wire [4:0]  wb_rd;
    wire [31:0] wb_data;

    cpu_top dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .wb_we(wb_we),
        .wb_rd(wb_rd),
        .wb_data(wb_data)
    );

    always #5 clk = ~clk;   // 10 ns clock

    initial begin
        clk = 0;
        reset = 1;

        // HOLD reset for multiple clocks
        repeat (3) @(posedge clk);

        reset = 0;

        #500;
        $finish;
    end

endmodule
