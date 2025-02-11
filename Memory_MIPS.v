module Memory(
    input memReadFlag,
    input memWriteFlag,
    input [31:0] MemAddress,
    input [31:0] WriteDataInput,
    output reg [31:0] ReadDataOutput
);

// Creating the memory bank
reg [31:0] memoryArray [127:0];
wire [6:0] memoryAccess;
assign memoryAccess = MemAddress[8:2];

integer loop_var;

// Initialize memory to zero
initial begin
    $display("[Memory] Initializing memory with null values");
    for (loop_var = 0; loop_var < 128; loop_var = loop_var + 1) begin
        memoryArray[loop_var] = 32'b0; // Use blocking assignment for initialization
    end
end

// Memory read and write operations
always @* begin
    // Default output
    ReadDataOutput = 32'b0;

    if (memReadFlag && ~memWriteFlag) begin
        $display("[Memory] Reading data from address: 0x%h", MemAddress);
        ReadDataOutput = memoryArray[memoryAccess];
    end
    else if (memWriteFlag && ~memReadFlag) begin
        $display("[Memory] Writing data to address: 0x%h, Data: 0x%h", MemAddress, WriteDataInput);
        memoryArray[memoryAccess] = WriteDataInput; // Use blocking assignment for write
    end
    else if (memReadFlag && memWriteFlag) begin
        $display("[Memory] Warning: Both read and write flags are asserted simultaneously. Ignoring operation.");
    end
end

endmodule