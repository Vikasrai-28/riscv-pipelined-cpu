module if_id_reg (
    input  wire clk,
    input  wire reset,
    input  wire stall,
    input  wire flush,
    input  wire [31:0] pc_in,
    input  wire [31:0] instr_in,
    output reg  [31:0] pc_out,
    output reg  [31:0] instr_out
);
    always @(posedge clk) begin
        if (reset || flush) begin
            pc_out <= 0;
            instr_out <= 32'h00000013;
        end else if (!stall) begin
            pc_out <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule
