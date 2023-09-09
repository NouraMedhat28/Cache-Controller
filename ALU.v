module ALU #(
    parameter ALU_Width = 'd32,
              ALU_Control_Signal = 'd3
) (
    input  wire  [ALU_Width-1:0]              SrcA,
    input  wire  [ALU_Width-1:0]              SrcB,
    input  wire  [ALU_Control_Signal-1:0]     ALUControl,
    output reg   [ALU_Width-1:0]              ALUResult,
    output reg                                Zero,
    output reg                                Sign
);

always @(*) begin
    case (ALUControl)
    3'b000 : begin
        ALUResult = SrcA + SrcB;
        Sign = ALUResult[31];
    end 

    3'b001 : begin
        ALUResult = SrcA << SrcB;
        Sign = ALUResult[31];
    end

    3'b010 : begin
        ALUResult = SrcA - SrcB;
        Sign = ALUResult[31];
    end

    3'b100 : begin
        ALUResult = SrcA ^ SrcB;
        Sign = ALUResult[31];
    end

    3'b101 : begin
        ALUResult = SrcA >> SrcB;
        Sign = ALUResult[31];
    end

    3'b110 : begin
        ALUResult = SrcA | SrcB;
        Sign = ALUResult[31];
    end

    3'b111 : begin
        ALUResult = SrcA & SrcB;
        Sign = ALUResult[31];
    end

        default : begin
            ALUResult = 32'b0;
            Sign = ALUResult[31];
        end
    endcase 
    Zero = (ALUResult == 32'b0 && ALUControl!=3'b011);
end

endmodule