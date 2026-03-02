`timescale 1ns / 1ps

module forwarding_unit (
    input wire [4:0] rs1_e, rs2_e,
    input wire [4:0] rd_m,
    input wire reg_write_m,
    input wire [4:0] rd_w,
    input wire reg_write_w,
    output reg [1:0] forward_a, forward_b
);
    always @(*) begin
        forward_a=0; forward_b=0;
        if (reg_write_m && rd_m!=0 && rd_m==rs1_e) forward_a=2'b10;
        if (reg_write_m && rd_m!=0 && rd_m==rs2_e) forward_b=2'b10;
        if (reg_write_w && rd_w!=0 && rd_w==rs1_e) forward_a=2'b01;
        if (reg_write_w && rd_w!=0 && rd_w==rs2_e) forward_b=2'b01;
    end
endmodule
