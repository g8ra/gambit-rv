module controlUnit(
    input clk, 
    input reset,            // Active-high asynchronous reset
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

// Opcode parameters (verify with your ISA)
parameter RtypeIF   = 6'b000000;
parameter beq       = 6'b000001;
parameter bne       = 6'b000010;
parameter sw        = 6'b000011;
parameter lw        = 6'b000100;
parameter addi      = 6'b000101;
parameter andi      = 6'b000110;
parameter ori       = 6'b000111;
parameter slti      = 6'b001000;
parameter Jtype_IF  = 6'b001001;

// Asynchronous reset with synchronous operation
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all control signals
        ALUOpCode     <= 3'b0;
        regDestFlag   <= 1'b0;
        regWriteFlag  <= 1'b0;
        ALUSrcFlag    <= 1'b0;
        MemReadFlag   <= 1'b0;
        MemWriteFlag  <= 1'b0;
        MemToRegFlag  <= 1'b0;
        BranchFlag    <= 1'b0;
        JumpFlag      <= 1'b0;
        $display("[Control Unit] Reset asserted");
    end
    else begin
        // Normal operation
        $display("[Control Unit] Processing opcode: 0b%b", InstOpCode);
        case (InstOpCode)
            RtypeIF: begin
                ALUOpCode     <= 3'b010;
                regDestFlag   <= 1'b1;
                regWriteFlag  <= 1'b1;
                ALUSrcFlag    <= 1'b0;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            beq: begin
                ALUOpCode     <= 3'b001;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b0;
                ALUSrcFlag    <= 1'b0;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b1;
                JumpFlag      <= 1'b0;
            end
            bne: begin
                ALUOpCode     <= 3'b001;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b0;
                ALUSrcFlag    <= 1'b0;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            sw: begin
                ALUOpCode     <= 3'b000;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b0;
                ALUSrcFlag    <= 1'b1;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b1;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            lw: begin
                ALUOpCode     <= 3'b000;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b1;
                ALUSrcFlag    <= 1'b1; // Fixed: ALUSrcFlag should be 1 for lw
                MemReadFlag   <= 1'b1;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b1;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            addi: begin
                ALUOpCode     <= 3'b000;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b1;
                ALUSrcFlag    <= 1'b1;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            andi: begin
                ALUOpCode     <= 3'b011;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b1;
                ALUSrcFlag    <= 1'b1;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            ori: begin
                ALUOpCode     <= 3'b100;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b1;
                ALUSrcFlag    <= 1'b1;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            slti: begin
                ALUOpCode     <= 3'b111;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b1;
                ALUSrcFlag    <= 1'b1;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
            Jtype_IF: begin
                ALUOpCode     <= 3'b000;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b0;
                ALUSrcFlag    <= 1'b0;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b1;
            end
            default: begin
                // Handle undefined opcodes
                $display("[Control Unit] Undefined opcode: 0b%b", InstOpCode);
                ALUOpCode     <= 3'b000;
                regDestFlag   <= 1'b0;
                regWriteFlag  <= 1'b0;
                ALUSrcFlag    <= 1'b0;
                MemReadFlag   <= 1'b0;
                MemWriteFlag  <= 1'b0;
                MemToRegFlag  <= 1'b0;
                BranchFlag    <= 1'b0;
                JumpFlag      <= 1'b0;
            end
        endcase
    end
end

endmodule