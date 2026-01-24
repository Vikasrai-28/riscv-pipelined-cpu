`timescale 1ns / 1ps

module mem_stage (
    input  wire        clk,
    input  wire        reset,

    input  wire [31:0] alu_result_m,
    input  wire [31:0] rs2_data_m,
    input  wire [4:0]  rd_m,

    input  wire        mem_read_m,
    input  wire        mem_write_m,
    input  wire        reg_write_m,
    input  wire        mem_to_reg_m,

    output reg  [31:0] mem_data_w,
    output reg  [31:0] alu_result_w,
    output reg  [4:0]  rd_w,
    output reg         reg_write_w,
    output reg         mem_to_reg_w
);

reg [31:0] data_mem [0:255];
integer i;

always @(posedge clk) begin
    if (reset) begin
        mem_data_w   <= 0;
        alu_result_w <= 0;
        rd_w         <= 0;
        reg_write_w  <= 0;
        mem_to_reg_w <= 0;

        for (i = 0; i < 256; i = i + 1)
            data_mem[i] <= 0;
    end else begin
        alu_result_w <= alu_result_m;
        rd_w         <= rd_m;
        reg_write_w  <= reg_write_m;
        mem_to_reg_w <= mem_to_reg_m;

        if (mem_write_m)
            data_mem[alu_result_m[9:2]] <= rs2_data_m;

        if (mem_read_m)
            mem_data_w <= data_mem[alu_result_m[9:2]];
    end
end

endmodule
