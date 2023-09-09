module ControlUnit (
   input  wire [2:0]    Funct3,
   input  wire          Funct7,
   input  wire          Zero_Flag,
   input  wire          Sign,
   input  wire [6:0]    OpCode,
   output wire [1:0]    ImmSrc,
   output wire          MemWrite,
   output wire          ALUSrc,
   output wire          ResultSrc,
   output wire          MemReadCpu,
   output wire          RegWrite,
   output reg           PCSrc,
   output wire [2:0]    ALUControl_C
);
wire Branch;
wire  [1:0]   ALUOp_int_Control;
wire beq, bnq, blt;

assign beq = Branch & Zero_Flag; 
assign bnq = Branch & ~Zero_Flag;  
assign blt = Branch & Sign; 

always @(*) begin
case (Funct3)
            3'b000:  PCSrc = beq; 
            3'b001:  PCSrc = bnq; 
            3'b100:  PCSrc = blt; 
            default: PCSrc = 1'b0;
        endcase
end


MainDecoder                Main_Decoder_Control
( .Decoder_Input           (OpCode),
  .ImmSrc                  (ImmSrc),
  .MemWrite                (MemWrite),
  .Branch                  (Branch),
  .ALUSrc                  (ALUSrc),
  .ResultSrc               (ResultSrc),
  .RegWrite                (RegWrite),
  .ALUOp_MD                (ALUOp_int_Control),
  .MemReadCpu              (MemReadCpu)
);

ALUDecoder                ALU_Decoder_Control
( .ALUOp                  (ALUOp_int_Control),
  .Funct3                 (Funct3),
  .Funct7                 (Funct7),
  .Op                     (OpCode[5]),
  .ALU_Control            (ALUControl_C)
);
    
endmodule