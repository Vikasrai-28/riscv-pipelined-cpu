module if_stage (
    input  wire clk,
    input  wire reset,
    input  wire stall,
    output reg  [31:0] pc_out
);
    always @(posedge clk) begin
        if (reset)
            pc_out <= 32'b0;
        else if (!stall)
            pc_out <= pc_out + 32'd4;
    end
endmodule
