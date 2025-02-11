module valueExtender(
    input [15:0] inpData,
    output reg [31:0] outData
);
initial begin
    $display("Initial value of jump is set to be zero");
    outData=32'b0;
end
always @(inpData) begin
    $display("Value of the input data is preserved with sign");
    outData[15:0] = {inpData};
    outData[31:16] = {16{inpData[15]}};

end
endmodule