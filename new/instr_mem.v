module instr_mem (
    input  wire [31:0] addr,
    output reg  [31:0] instr
);
    reg [31:0] mem [0:255];
    integer i;

    initial begin
        // default NOPs
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000013; // NOP
        end

        // program
        mem[0] = 32'h00500093; // addi x1, x0, 5
        mem[1] = 32'h00300113; // addi x2, x0, 3
        mem[2] = 32'h002081b3; // add  x3, x1, x2
    end

    always @(*) begin
        instr = mem[addr[9:2]];
    end
endmodule
