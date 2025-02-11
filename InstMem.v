module InstMem(
    input instRead,
    input [31:0] instAddress,
    output reg [31:0] InstRead
);

// Memory array instantiation
reg [31:0] instArray [255:0];

// Loop to initialize memory to 0
integer loop_var;
initial begin
    $display("[InstMem] Initializing instruction memory to zero");
    for (loop_var = 0; loop_var < 256; loop_var = loop_var + 1) begin
        instArray[loop_var] = 32'b0; // Use blocking assignment for initialization
    end
end

// When instruction is received, read the instruction memory
always @(instRead or instAddress) begin
    if (instRead) begin
        $display("[InstMem] Reading instruction at address: 0x%h", instAddress);
        InstRead <= instArray[instAddress[7:0]]; // Use lower 8 bits for indexing
    end
    else begin
        InstRead <= 32'b0; // Default output when `instRead` is not asserted
    end
end

endmodule