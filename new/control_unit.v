`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,
    output reg regwrite,
    output reg memread,
    output reg memwrite,
    output reg memtoreg,
    output reg alusrc,
    output reg branch,
    output reg [2:0] aluop
);
    always @(*) begin
        regwrite = 0; memread = 0; memwrite = 0;
        memtoreg = 0; alusrc = 0; branch = 0; aluop = 3'b000;

        case (opcode)
            7'b0010011: begin // ADDI
                regwrite = 1;
                alusrc = 1;
            end
            7'b0000011: begin // LW
                regwrite = 1;
                memread = 1;
                memtoreg = 1;
                alusrc = 1;
            end
            7'b0100011: begin // SW
                memwrite = 1;
                alusrc = 1;
            end
            7'b1100011: begin // BEQ
                branch = 1;
                aluop = 3'b001;
            end
        endcase
    end
endmodule
