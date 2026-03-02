module id_ex_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        flush,

    /* data */
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [31:0] imm_in,

    /* register numbers */
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,

    /* control */
    input  wire        regwrite_in,
    input  wire        memread_in,
    input  wire        memwrite_in,
    input  wire        memtoreg_in,
    input  wire        alusrc_in,
    input  wire        branch_in,
    input  wire [2:0]  aluop_in,

    /* outputs */
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,
    output reg  [31:0] imm_out,

    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,

    output reg         regwrite_out,
    output reg         memread_out,
    output reg         memwrite_out,
    output reg         memtoreg_out,
    output reg         alusrc_out,
    output reg         branch_out,
    output reg  [2:0]  aluop_out
);

    always @(posedge clk) begin
        if (reset || flush) begin
            rs1_data_out <= 0;
            rs2_data_out <= 0;
            imm_out      <= 0;

            rs1_out <= 0;
            rs2_out <= 0;
            rd_out  <= 0;

            regwrite_out <= 0;
            memread_out  <= 0;
            memwrite_out <= 0;
            memtoreg_out <= 0;
            alusrc_out   <= 0;
            branch_out   <= 0;
            aluop_out    <= 0;
        end else begin
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            imm_out      <= imm_in;

            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out  <= rd_in;

            regwrite_out <= regwrite_in;
            memread_out  <= memread_in;
            memwrite_out <= memwrite_in;
            memtoreg_out <= memtoreg_in;
            alusrc_out   <= alusrc_in;
            branch_out   <= branch_in;
            aluop_out    <= aluop_in;
        end
    end

endmodule
