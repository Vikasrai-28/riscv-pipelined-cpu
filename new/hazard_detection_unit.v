module hazard_detection_unit (
    input  wire [4:0] id_rs1,
    input  wire [4:0] id_rs2,
    input  wire [4:0] ex_rd,
    input  wire       ex_memread,
    output reg        stall,
    output reg        flush
);
    always @(*) begin
        stall = 0;
        flush = 0;
        if (ex_memread && ex_rd != 0 &&
            (ex_rd == id_rs1 || ex_rd == id_rs2)) begin
            stall = 1;
            flush = 1;
        end
    end
endmodule
