module ALUDecoder (
    input  wire  [1:0]  ALUOp,
    input  wire  [2:0]  Funct3,
    input  wire         Funct7,
    input  wire         Op,
    output reg   [2:0]  ALU_Control
);

always @(*) begin
    case (ALUOp) 
        2'b00 : begin
            ALU_Control = 3'b000; 
        end
        2'b01 : begin
        case (Funct3) 
        3'b000, 3'b001, 3'b100 : begin
            ALU_Control = 3'b010; 
        end
        default : begin
            ALU_Control = 3'b000;
            end 
            endcase 
        end

        2'b10 : begin
            case (Funct3) 
                3'b000 : begin
                    case ({Op, Funct7}) 
                    2'b00, 2'b01, 2'b10 : begin
                    ALU_Control = 3'b000;
                end
                    2'b11 : begin
                    ALU_Control = 3'b010;
                    end
                    endcase
                end
                3'b001 : begin
                    ALU_Control = 3'b001;
                end
                3'b100 : begin
                    ALU_Control = 3'b100;
                end
                3'b101 : begin
                    ALU_Control = 3'b101;
                end

                3'b110 : begin
                    ALU_Control = 3'b110;
                end

                3'b111 : begin
                    ALU_Control = 3'b111;
                end

                default : begin
                    ALU_Control = 3'b000;
                end
                endcase
        end
        default : begin
            ALU_Control = 3'b000;
        end
    endcase
end    
endmodule