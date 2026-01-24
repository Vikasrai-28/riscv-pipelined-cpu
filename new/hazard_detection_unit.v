`timescale 1ns / 1ps

module hazard_detection_unit (
    input  wire        reset,
    input  wire [4:0]  rs1_d,
    input  wire [4:0]  rs2_d,
    input  wire        mem_read_e,
    input  wire [4:0]  rd_e,

    output reg         pc_write,
    output reg         if_id_write,
    output reg         id_ex_flush
);

    always @(*) begin
        pc_write    = 1;
        if_id_write = 1;
        id_ex_flush = 0;

        if (!reset && mem_read_e &&
            (rd_e != 0) &&
            ((rd_e == rs1_d) || (rd_e == rs2_d))) begin
            pc_write    = 0;
            if_id_write = 0;
            id_ex_flush = 1;
        end
    end

endmodule
