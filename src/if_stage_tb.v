`timescale 1ns / 1ps

module if_stage_tb;

    // Testbench signals
    reg         clk;
    reg         reset;
    wire [31:0] pc;
    wire [31:0] instr;

    // Instantiate the IF stage (DUT = Device Under Test)
    if_stage dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk   = 0;
        reset = 1;

        // Hold reset for some time
        #20;
        reset = 0;

        // Let the PC run for a few cycles
        #100;

        // Finish simulation
        $finish;
    end

endmodule
