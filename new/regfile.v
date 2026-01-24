module regfile (
    input wire clk, we,
    input wire [4:0] ra1, ra2, wa,
    input wire [31:0] wd,
    output wire [31:0] rd1, rd2
);
    reg [31:0] r[31:0];
    assign rd1 = (ra1==0)?0:r[ra1];
    assign rd2 = (ra2==0)?0:r[ra2];
    always @(posedge clk)
        if (we && wa!=0) r[wa] <= wd;
endmodule
