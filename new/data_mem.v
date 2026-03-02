`timescale 1ns / 1ps

module data_mem (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);

    reg [31:0] mem [0:255];
    integer i;

    // ===============================
    // MEMORY INITIALIZATION (SIM ONLY)
    // ===============================
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'b0;

        // Example initialization
        // mem[0] = 32'd5;   // useful for lw x?, 0(x0)
    end

    // ===============================
    // READ (COMBINATIONAL)
    // ===============================
    assign read_data = mem_read ? mem[addr[9:2]] : 32'b0;

    // ===============================
    // WRITE (SYNCHRONOUS)
    // ===============================
    always @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= write_data;
    end

endmodule
