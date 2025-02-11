module EX_MEM_register(
    input clk,
    input reset, // Active-high reset

    input regDestsFlagInput,
    input regWriteFlagInput,
    input ALUSrcInput,
    input memReadFlagInput,
    input memWriteFlagInput,
    input MemToRegInput,
    input BranchsFlagInput,
    input JumpsFlagInput,
    input [3:0] ALUControlInput,
    input [31:0] IRInput,
    input [31:0] PCInput,
    input [31:0] BInput,
    input [31:0] ResultInput,
    input [4:0] regDestAddressInput,
    input [31:0] BranchAddressInput,
    input [31:0] JumpAddressInput,
    input ZeroFlagInput,
    
    output reg regDestsFlagOutput,
    output reg regWriteFlagOutput,
    output reg ALUSrcOutput,
    output reg memReadFlagOutput,
    output reg memWriteFlagOutput,
    output reg MemToRegOutput,
    output reg BranchsFlagOutput,
    output reg JumpsFlagOutput,
    output reg [3:0] ALUControlOutput,
    output reg [31:0] IROutput,
    output reg [31:0] PCOutput,
    output reg [31:0] BOutput,
    output reg [31:0] ResultOutput,
    output reg [4:0] regDestAddressOutput,
    output reg [31:0] BranchAddressOutput,
    output reg [31:0] JumpAddressOutput,
    output reg ZeroFlagOutput,
    input controlSignal
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all outputs to 0
        regDestsFlagOutput <= 1'b0;
        regWriteFlagOutput <= 1'b0;
        ALUSrcOutput <= 1'b0;
        memReadFlagOutput <= 1'b0;
        memWriteFlagOutput <= 1'b0;
        MemToRegOutput <= 1'b0;
        BranchsFlagOutput <= 1'b0;
        JumpsFlagOutput <= 1'b0;
        ALUControlOutput <= 4'b0;
        IROutput <= 32'b0;
        PCOutput <= 32'b0;
        BOutput <= 32'b0;
        ResultOutput <= 32'b0;
        JumpAddressOutput <= 32'b0;
        BranchAddressOutput <= 32'b0;
        regDestAddressOutput <= 5'b0;
        ZeroFlagOutput <= 1'b0;
    end
    else if (controlSignal) begin
        // Update outputs with inputs
        regDestsFlagOutput <= regDestsFlagInput;
        regWriteFlagOutput <= regWriteFlagInput;
        ALUSrcOutput <= ALUSrcInput;
        memReadFlagOutput <= memReadFlagInput;
        memWriteFlagOutput <= memWriteFlagInput;
        MemToRegOutput <= MemToRegInput;
        BranchsFlagOutput <= BranchsFlagInput;
        JumpsFlagOutput <= JumpsFlagInput;
        ALUControlOutput <= ALUControlInput;
        IROutput <= IRInput;
        PCOutput <= PCInput;
        BOutput <= BInput;
        ResultOutput <= ResultInput;
        JumpAddressOutput <= JumpAddressInput;
        BranchAddressOutput <= BranchAddressInput;
        regDestAddressOutput <= regDestAddressInput;
        ZeroFlagOutput <= ZeroFlagInput;
    end
end

endmodule
