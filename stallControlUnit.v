module stallControlUnit(
    input clk,
    input reset, // Active-high reset
    input [5:0] Operand1,
    input [5:0] Operand2,
    input [5:0] Operand3,
    output reg stallFlag
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        stallFlag <= 1'b1; // Default to no stall on reset
        $display("[StallControlUnit] Reset: stallFlag set to 1");
    end
    else begin
        if (Operand1 == 6'b000100 || Operand1 == 6'b000101 || Operand1 == 6'b000010 || 
            Operand2 == 6'b000100 || Operand2 == 6'b000101 || Operand2 == 6'b000010 || 
            Operand3 == 6'b000100 || Operand3 == 6'b000101 || Operand3 == 6'b000010) begin
            stallFlag <= 1'b0; // Stall detected
            $display("[StallControlUnit] Stall detected due to Operand match");
        end
        else begin
            stallFlag <= 1'b1; // No stall
            $display("[StallControlUnit] No stall detected");
        end
    end
end

endmodule

module nopSet(
    input clk,
    input reset, // Active-high reset
    input S1,
    input S2,
    input [31:0] OldF,
    input [31:0] OldD,
    output reg [31:0] NewF,
    output reg [31:0] NewD
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        NewF <= 32'b0;
        NewD <= 32'b0;
        $display("[nopSet] Reset: NewF and NewD set to 0");
    end
    else begin
        if (S1 == 1'b0 && S2 == 1'b0) begin
            NewF <= 32'b0;
            NewD <= 32'b0;
            $display("[nopSet] Both S1 and S2 are 0: NewF and NewD set to 0");
        end
        else if (S1 == 1'b0 && S2 == 1'b1) begin
            NewD <= 32'b0;
            $display("[nopSet] S1 is 0 and S2 is 1: NewD set to 0");
        end
        else if (S1 == 1'b1 && S2 == 1'b0) begin
            NewF <= 32'b0;
            $display("[nopSet] S1 is 1 and S2 is 0: NewF set to 0");
        end
        else begin
            NewD <= OldD;
            NewF <= OldF;
            $display("[nopSet] No stall: NewF and NewD updated with OldF and OldD");
        end
    end
end

endmodule