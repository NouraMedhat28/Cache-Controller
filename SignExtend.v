module SignExtend (
    input  wire   [31:0]      InstrIn,
    input  wire   [1:0]       ImmSrc,
    output reg    [31:0]      SignImm
);


always @(*) begin
case (ImmSrc) 
2'b00 : begin
 SignImm = {{20{InstrIn[31]}}, InstrIn[31:20]};
end

2'b01 : begin
 SignImm = {{20{InstrIn[31]}}, InstrIn[31:25], InstrIn[11:7]};
end

2'b10 : begin
 SignImm = {{20{InstrIn[31]}}, InstrIn[7], InstrIn[30:25], InstrIn[11:8], 1'b0};
end

default : begin
SignImm = 'b0;
end
endcase
end
    
endmodule

