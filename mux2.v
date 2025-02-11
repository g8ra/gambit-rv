module mux2(
    input in1,
    input in2,
    input control,
    output reg out_reg
);

always @(control) begin
    if (control) begin 
        out_reg <= in2;
        // $display("Choosing line 2");
    end
    else begin 
        out_reg <= in1;    
        // $display("Chooosing line 1");
    end
end

endmodule