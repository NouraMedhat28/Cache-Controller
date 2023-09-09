module PCCalc (
input wire [31:0] ImmEx, PCOut,
input wire        Stall,
input wire PCSrc,
output reg [31:0] PCNext
);

always@(*) begin
    if(!Stall) begin
        if(PCSrc) begin
           PCNext <= PCOut + ImmEx;
     end
        else begin
           PCNext <= PCOut + 32'd4;
     end 
    end
end 
endmodule