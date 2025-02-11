module ALUControl(
    input [5:0] ALUOperation,
    input [2:0] ALUOpcode,
    output reg [3:0] ALUOutputSignal
);

always @(ALUOpcode or ALUOperation) begin
    $display("Deciding the control signal based on the format of the code");

    case (ALUOpcode)
        3'b000: ALUOutputSignal = 4'b0000; // Example: ADD
        3'b001: ALUOutputSignal = 4'b0001; // Example: SUB
        3'b010: begin
            case (ALUOperation)
                6'b100000: ALUOutputSignal = 4'b0000; // ADD
                6'b100010: ALUOutputSignal = 4'b0001; // SUB
                6'b100100: ALUOutputSignal = 4'b0010; // AND
                6'b100101: ALUOutputSignal = 4'b0011; // OR
                6'b101010: ALUOutputSignal = 4'b0100; // SLT
                default: begin
                    ALUOutputSignal = 4'b1111; // Undefined operation
                    $display("Warning: Undefined ALU operation: 0b%b", ALUOperation);
                end
            endcase
        end
        3'b011: ALUOutputSignal = 4'b0010; // Example: ANDI
        3'b100: ALUOutputSignal = 4'b0011; // Example: ORI
        3'b111: ALUOutputSignal = 4'b0101; // Example: SLTI
        default: begin
            ALUOutputSignal = 4'b1111; // Undefined opcode
            $display("Warning: Undefined ALU opcode: 0b%b", ALUOpcode);
        end
    endcase
end

endmodule
