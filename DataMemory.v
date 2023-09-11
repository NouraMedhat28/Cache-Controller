module DataMemory (
    input  wire [9:0]   Address,
    input  wire [31:0]  DataInCpu,
    input  wire         MemRead,
    input  wire         MemWrite,
    input  wire [1:0]   Count,
    input  wire         CLK,
    input  wire         RST,
    output reg          Ready,
    output reg  [127:0] DataOutMem
);

reg [31:0]  DataMem [0:1024];
reg [31:0]  address_int;
integer i;

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        Ready      <= 1'b0;
        DataOutMem <= 128'b0;

        for(i = 0; i<= 127; i=i+1) begin
                DataMem[i] <= 32'b0;
            end 
    end
    else if(MemRead) begin //Read miss
        case (Count)
         2'b00   : begin
            DataOutMem[31:0] <=   DataMem[{Address[9:2], Count}];
            Ready   <=   1'b0;
         end 
         2'b01 : begin
            DataOutMem[63:32] <=   DataMem[{Address[9:2], Count}];
            Ready   <=   1'b0;
         end
         2'b10 : begin
            DataOutMem[95:64] <=   DataMem[{Address[9:2], Count}];
            Ready   <=   1'b0;
         end
         2'b11 : begin
            DataOutMem[127:96] <=   DataMem[{Address[9:2], Count}];
            Ready   <=   1'b1;
         end
            default: begin
                DataOutMem <= 128'b0;
                Ready   <= 1'b0;
            end
        endcase
    end
    else if(MemWrite && Count!=2'b11) begin //Write miss
        DataMem[Address] <= DataInCpu;
        Ready <= 1'b0;
    end
    else if(MemWrite && Count == 2'b11) begin //4 clock cycles
        Ready <= 1'b1;
    end
end
    
endmodule