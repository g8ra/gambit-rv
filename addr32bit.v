module addr32bit(
    input [31:0] inp_1,
    input [31:0] inp_2,
    output reg [31:0] out_addr
);

always@(inp_1, inp_2) begin
    $display("Adding %b and %b", inp_1, inp_2);
    out_addr<=inp_1+inp_2;
end

endmodule