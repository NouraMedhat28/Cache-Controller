module SingleCycleRISC #(
    parameter Data_Width_Top = 'd32,
              Address_Width_Top = 'd5,
              ALU_Control_Top = 'd3,
              Depth_Top = 'd100
) (
    input  wire                                 CLK,
    input  wire                                 RST
); 


wire    [Data_Width_Top-1:0]    SrcA;
wire    [Data_Width_Top-1:0]    ImmExt;
wire    [Data_Width_Top-1:0]    SrcB;
wire    [Data_Width_Top-1:0]    RD2;
wire    [Data_Width_Top-1:0]    PCOut;
wire    [Data_Width_Top-1:0]    PCNext;
wire    [Data_Width_Top-1:0]    Instruction;
wire    [Data_Width_Top-1:0]    ALUResult;
wire    [Data_Width_Top-1:0]    ReadData;
wire    [Data_Width_Top-1:0]    WD3;
wire                            ALUSrc;
wire                            PCSrc;
wire                            WE3;
wire                            MemWriteCpu;
wire                            Zero_Flag;
wire    [1:0]                   ImmSrc;
wire                            Sign;
wire                            ResultSrc;
wire    [2:0]                   ALUControl;
wire                            Stall;
wire                            MemReadCpu;

InstructionMemory               InstructionMemoryTop
(.A_Instr                       (PCOut),
 .Instr                         (Instruction)
);

ProgrammCounter                 ProgrammCounterTop
(.next_instr                    (PCNext),
 .CLK                           (CLK),
 .RST                           (RST),
 .current_instr                 (PCOut),
 .Stall                         (Stall)
);

PCCalc                          ProgrammCounterIntermediate
(.ImmEx                         (ImmExt), 
 .PCOut                         (PCOut),
 .PCSrc                         (PCSrc),
 .PCNext                        (PCNext),
 .Stall                         (Stall)
);

RegisterFile                    RegFileTop
(.A1                            (Instruction[19:15]),
 .A2                            (Instruction[24:20]),
 .A3                            (Instruction[11:7]),
 .CLK                           (CLK),
 .RST                           (RST),
 .WE3                           (WE3),
 .WD3                           (WD3),
 .RD1                           (SrcA),
 .RD2                           (RD2)
);

MUX                             SecondOperandMUX
(.SEL                           (ALUSrc),
 .IN0                           (RD2),
 .IN1                           (ImmExt),
 .Out                           (SrcB)
);

SignExtend                      SignExtendTop
(.InstrIn                       (Instruction),
 .ImmSrc                        (ImmSrc),
 .SignImm                       (ImmExt)
);

MUX                             Result
(.SEL                           (ResultSrc),
 .IN0                           (ALUResult),
 .IN1                           (ReadData),
 .Out                           (WD3)
);

ALU                             ALUTop
(.SrcA                          (SrcA),
 .SrcB                          (SrcB),
 .ALUControl                    (ALUControl),
 .ALUResult                     (ALUResult),
 .Zero                          (Zero_Flag),
 .Sign                          (Sign)
);

ControlUnit                    ControlUnitTop
(.Funct3                       (Instruction[14:12]),
 .Funct7                       (Instruction[30]),
 .Zero_Flag                    (Zero_Flag),
 .OpCode                       (Instruction[6:0]),
 .ImmSrc                       (ImmSrc),
 .MemWrite                     (MemWriteCpu),
 .ALUSrc                       (ALUSrc),
 .ResultSrc                    (ResultSrc),
 .RegWrite                     (WE3),
 .PCSrc                        (PCSrc),
 .ALUControl_C                 (ALUControl),
 .Sign                         (Sign),
 .MemReadCpu                   (MemReadCpu)
);

CacheModule                   CacheModuleTop
(.MemReadCpu                  (MemReadCpu),
 .MemWriteCpu                 (MemWriteCpu),
 .Address                     (ALUResult[9:0]),
 .CLK                         (CLK),
 .RST                         (RST),
 .DataIn                      (RD2),
 .Stall                       (Stall),
 .DataOut                     (ReadData)
);
endmodule