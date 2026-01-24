module mem_wb_reg (
    input wire clk, reset,
    input wire [31:0] alu_result_m,
    input wire [4:0] rd_m,
    input wire reg_write_m,
    output reg [31:0] alu_result_w,
    output reg [4:0] rd_w,
    output reg reg_write_w
);
    always @(posedge clk)
        if (reset) begin alu_result_w<=0; rd_w<=0; reg_write_w<=0; end
        else begin alu_result_w<=alu_result_m; rd_w<=rd_m; reg_write_w<=reg_write_m; end
endmodule
