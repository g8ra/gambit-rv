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
  #300 $finish();
end

initial begin
    #280;

    $display("R1 = %0d", sc1.u11.regFile_array[1]);
    $display("R2 = %0d", sc1.u11.regFile_array[2]);
    $display("R3 = %0d", sc1.u11.regFile_array[3]);

    if (sc1.u11.regFile_array[1] !== 32'd5)
        // $display("ERROR: R1 is incorrect");
        $fatal(1, "R1 is incorrect: expected 5, got %0d", sc1.u11.regFile_array[1]);

    if (sc1.u11.regFile_array[2] !== 32'd7)
        // $display("ERROR: R2 is incorrect");
        $fatal(1, "R2 is incorrect: expected 7, got %0d", sc1.u11.regFile_array[2]);

    if (sc1.u11.regFile_array[3] !== 32'd12)
        // $display("ERROR: R3 is incorrect");
        $fatal(1, "R3 is incorrect: expected 12, got %0d", sc1.u11.regFile_array[3]);

    $display("PASS: MIPS addi/addi/add smoke test");

end

endmodule