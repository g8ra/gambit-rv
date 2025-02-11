`include "Processor_MIPS.v"

module TB;
reg clk;
reg reset;
Processor_MIPS sc1(clk,reset);

// In your testbench

initial begin
    
    clk=1'b0;
    forever begin
        #10 clk =~clk;
    end
end

initial begin
    reset = 1'b1;  // Assert reset
    #30 reset = 1'b0;  // Release reset after 20ns
    // Continue with normal operations
    #100 $finish();
end



endmodule