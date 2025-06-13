module controlUnit(
    input clk,
    input reset,
    input [5:0] InstOpCode,
    input [5:0] ALUOperation,
    input [31:0] IR,
    output reg [2:0] ALUOpCode,
    output reg regDestFlag,
    output reg regWriteFlag,
    output reg ALUSrcFlag,
    output reg MemReadFlag,
    output reg MemWriteFlag,
    output reg MemToRegFlag,
    output reg BranchFlag,
    output reg JumpFlag
);

// opcode encodings.
localparam [5:0] OP_RTYPE = 6'b000000;
localparam [5:0] OP_BEQ   = 6'b000100;
localparam [5:0] OP_BNE   = 6'b000101;
localparam [5:0] OP_J     = 6'b000010;
localparam [5:0] OP_ADDI  = 6'b001000;
localparam [5:0] OP_ANDI  = 6'b001100;
localparam [5:0] OP_ORI   = 6'b001101;
localparam [5:0] OP_SLTI  = 6'b001010;
localparam [5:0] OP_LW    = 6'b100011;
localparam [5:0] OP_SW    = 6'b101011;

always @* begin
    ALUOpCode    = 3'b000;
    regDestFlag  = 1'b0;
    regWriteFlag = 1'b0;
    ALUSrcFlag   = 1'b0;
    MemReadFlag  = 1'b0;
    MemWriteFlag = 1'b0;
    MemToRegFlag = 1'b0;
    BranchFlag   = 1'b0;
    JumpFlag     = 1'b0;

    if (reset || IR == 32'b0) begin
        // Reset and the all-zero instruction are treated as NOPs.
    end else begin
        case (InstOpCode)
            OP_RTYPE: begin
                ALUOpCode    = 3'b010;
                regDestFlag  = 1'b1;
                regWriteFlag = 1'b1;
            end
            OP_BEQ: begin
                ALUOpCode = 3'b001;
                BranchFlag = 1'b1;
            end
            OP_BNE: begin
                ALUOpCode = 3'b001;
                BranchFlag = 1'b1;
            end
            OP_J: begin
                JumpFlag = 1'b1;
            end
            OP_ADDI: begin
                regWriteFlag = 1'b1;
                ALUSrcFlag = 1'b1;
            end
            OP_ANDI: begin
                ALUOpCode = 3'b011;
                regWriteFlag = 1'b1;
                ALUSrcFlag = 1'b1;
            end
            OP_ORI: begin
                ALUOpCode = 3'b100;
                regWriteFlag = 1'b1;
                ALUSrcFlag = 1'b1;
            end
            OP_SLTI: begin
                ALUOpCode = 3'b111;
                regWriteFlag = 1'b1;
                ALUSrcFlag = 1'b1;
            end
            OP_LW: begin
                regWriteFlag = 1'b1;
                ALUSrcFlag = 1'b1;
                MemReadFlag = 1'b1;
                MemToRegFlag = 1'b1;
            end
            OP_SW: begin
                ALUSrcFlag = 1'b1;
                MemWriteFlag = 1'b1;
            end
            default: begin
                // Unsupported opcode
            end
        endcase
    end
end

endmodule