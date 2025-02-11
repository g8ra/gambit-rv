module regFile(
    input clk,
    input regWriteControl,
    input [4:0] readRegAddress1,
    input [4:0] readRegAddress2,
    input [4:0] writeRegAddress,
    input [31:0] writeRegData,
    output reg [31:0] readData1,
    output reg [31:0] readData2
);

// Creating the register file
reg [31:0] regFile_array [31:0];

// Initializing the register array
integer loop_var;
initial begin
    $display("[Register File] Initializing all registers to 0");
    for (loop_var = 0; loop_var < 32; loop_var = loop_var + 1) begin
        regFile_array[loop_var] = 32'b0; // Use blocking assignment for initialization
    end
end

// Writing back to the register
always @(posedge clk) begin
    if (regWriteControl == 1'b1 && writeRegAddress != 5'b0) begin
        // Write to the register only if regWriteControl is enabled and the address is not 0
        $display("[Register File] Writing value 0x%h to register %d", writeRegData, writeRegAddress);
        regFile_array[writeRegAddress] <= writeRegData;
    end
    // Ensure register 0 is always hardwired to 0
    regFile_array[0] <= 32'b0;
end

// Reading data from the register file
always @* begin
    // Combinational logic for reading registers
    readData1 = regFile_array[readRegAddress1];
    readData2 = regFile_array[readRegAddress2];
    $display("[Register File] Read data: reg1=0x%h, reg2=0x%h", readData1, readData2);
end

endmodule