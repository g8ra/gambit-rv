module IF_ID_register(
    input clk,
    input reset,          // Active-high reset
    input [31:0] nextPCInput,
    input [31:0] instrOutInput,
    output reg [31:0] nextPCOutput,
    output reg [31:0] instrOutOutput,
    input IFIDControl
);

// Sequential logic with async reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all pipeline registers
        nextPCOutput <= 32'b0;
        instrOutOutput <= 32'b0;
        $display("[IF/ID Register] Reset: Pipeline flushed");
    end
    else if (IFIDControl) begin
        // Normal operation
        nextPCOutput <= nextPCInput;
        instrOutOutput <= instrOutInput;
        $display("[IF/ID Register] Update: PC=0x%h, Instruction=0x%h", 
                 nextPCInput, instrOutInput);
    end
    else begin
        // Hold state (pipeline stall)
        $display("[IF/ID Register] Stall: Holding current state");
    end
end

endmodule