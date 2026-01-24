module wb_stage (
    input  wire [31:0] alu_result_w,
    input  wire [31:0] mem_data_w,
    input  wire [4:0]  rd_w,
    input  wire        mem_to_reg_w,
    input  wire        reg_write_w,

    output wire [31:0] wb_data,
    output wire [4:0]  wb_rd,
    output wire        wb_we
);

assign wb_data = mem_to_reg_w ? mem_data_w : alu_result_w;
assign wb_rd   = rd_w;
assign wb_we   = reg_write_w;

endmodule
