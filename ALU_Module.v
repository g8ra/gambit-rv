module ALU_Module(
    input [31:0] data_in1,
    input [31:0] data_in2,
    input [3:0] ALUOpCode,
    output reg [31:0] resultOut,
    output reg zeroFlag,
    output reg lessThanFlag,
    output reg greaterThanFlag
);

always @* begin
    // Reset flags
    zeroFlag = 1'b0;
    greaterThanFlag = 1'b0;
    lessThanFlag = 1'b0;

    // ALU operation
    case (ALUOpCode)
        4'b0000: resultOut = data_in1 + data_in2; // ADD
        4'b0001: resultOut = data_in1 - data_in2; // SUB
        4'b0010: resultOut = data_in1 & data_in2; // AND
        4'b0011: resultOut = data_in1 | data_in2; // OR
        default: resultOut = 32'b0; // Undefined operation
    endcase

    // Comparison logic
    if (data_in1 > data_in2) begin
        $display("Greater than true");
        greaterThanFlag = 1'b1;
    end
    else if (data_in1 < data_in2) begin
        $display("Lesser than true");
        lessThanFlag = 1'b1;
    end
    else begin
        $display("Both are equal");
    end

    // Zero flag logic
    if (resultOut == 32'd0) begin
        zeroFlag = 1'b1;
        $display("Zero flag set");
    end
end

endmodule