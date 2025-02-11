module progCounterRegWrite(
    input clk,
    input reset, // Active-high reset
    input [31:0] instAddress_in,
    input controlPC,
    output reg [31:0] instAddress_out
);

// Reset and initialization
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the program counter to 0
        instAddress_out <= 32'b0;
        $display("[ProgramCounter] Reset: Program counter set to 0");
    end
    else if (controlPC) begin
        // Update the program counter with the input address
        instAddress_out <= instAddress_in;
        $display("[ProgramCounter] Update: Program counter updated to 0x%h", instAddress_in);
    end
end

endmodule