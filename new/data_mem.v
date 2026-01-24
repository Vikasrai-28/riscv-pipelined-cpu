`timescale 1ns / 1ps

module data_mem (
    input  wire        clk,
    input  wire        mem_write,
    input  wire        mem_read,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    // Simple 1 KB data memory (256 words)
    reg [31:0] mem [0:255];

    // READ (combinational)
    always @(*) begin
        if (mem_read)
            read_data = mem[addr[9:2]]; // word aligned
        else
            read_data = 32'b0;
    end

    // WRITE (sequential)
    always @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= write_data;
    end

endmodule
