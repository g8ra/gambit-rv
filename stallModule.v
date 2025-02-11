module stallUnit(
    input clk,
    input reset, // Active-high reset
    input [4:0] Rs,
    input [4:0] Rt,
    input [5:0] InstOpCode,
    input [31:0] IR_ID,
    input [31:0] IR_EX,
    input [31:0] IR_MEM,
    input [4:0] regWB,
    input WWB,
    input [31:0] IR_WB,
    output reg stallFlag
);

reg We1, We2, We3;
reg [4:0] Ws1, Ws2, Ws3;
reg Res, Ret;

// Reset and initialization
always @(posedge clk or posedge reset) begin
    if (reset) begin
        stallFlag <= 1'b1;
        We1 <= 1'b0;
        We2 <= 1'b0;
        We3 <= 1'b0;
        Res <= 1'b0;
        Ret <= 1'b0;
        $display("[StallUnit] Reset: All signals initialized to default values");
    end
    else begin
        // Determine Res and Ret based on InstOpCode
        case (InstOpCode)
            6'b000000: begin // R-type
                Res <= 1'b1;
                Ret <= 1'b1;
            end
            6'b100011: begin // lw
                Res <= 1'b1;
                Ret <= 1'b0;
            end
            6'b101011: begin // sw
                Res <= 1'b1;
                Ret <= 1'b1;
            end
            6'b000010: begin // jump
                Res <= 1'b0;
                Ret <= 1'b0;
            end
            6'b000100: begin // beq
                Res <= 1'b1;
                Ret <= 1'b1;
            end
            6'b000101: begin // bne
                Res <= 1'b1;
                Ret <= 1'b1;
            end
            default: begin // I-type
                Res <= 1'b1;
                Ret <= 1'b0;
            end
        endcase

        // Determine We1 and Ws1 based on IR_EX
        if (IR_EX != 32'b0) begin
            case (IR_EX[31:26])
                6'b000000: begin // R-type
                    We1 <= 1'b1;
                    Ws1 <= IR_EX[15:11];
                end
                6'b100011: begin // lw
                    We1 <= 1'b1;
                    Ws1 <= IR_EX[20:16];
                end
                default: begin
                    We1 <= 1'b0;
                    Ws1 <= 5'b0;
                end
            endcase
        end
        else begin
            We1 <= 1'b0;
            Ws1 <= 5'b0;
        end

        // Determine We2 and Ws2 based on IR_MEM
        if (IR_MEM != 32'b0) begin
            case (IR_MEM[31:26])
                6'b000000: begin // R-type
                    We2 <= 1'b1;
                    Ws2 <= IR_MEM[15:11];
                end
                6'b100011: begin // lw
                    We2 <= 1'b1;
                    Ws2 <= IR_MEM[20:16];
                end
                default: begin
                    We2 <= 1'b0;
                    Ws2 <= 5'b0;
                end
            endcase
        end
        else begin
            We2 <= 1'b0;
            Ws2 <= 5'b0;
        end

        // Determine We3 and Ws3 based on IR_WB
        if (IR_WB != 32'b0) begin
            We3 <= WWB;
            Ws3 <= regWB;
        end
        else begin
            We3 <= 1'b0;
            Ws3 <= 5'b0;
        end

        // Stall flag logic
        stallFlag <= ~((((Rs == Ws1) & We1) | ((Rs == Ws2) & We2) | ((Rs == Ws3) & We3)) & Res |
                       (((Rt == Ws1) & We1) | ((Rt == Ws2) & We2) | ((Rt == Ws3) & We3)) & Ret);
        $display("[StallUnit] Stall flag updated: %b", stallFlag);
    end
end

endmodule