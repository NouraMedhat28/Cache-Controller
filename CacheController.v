module CacheController (
    input  wire [9:0]  Address,       //From the CPU
    input  wire [2:0]  Tag,           //From the Cache
    input  wire        Valid,         //From the Cache
    input  wire        CLK,
    input  wire        RST,
    input  wire        Ready,
    input  wire        MemWriteCpu,   //From the CPU
    input  wire        MemReadCpu,    //From the CPU
    output reg         CacheRead,     //In case of the hit,
    output reg         CacheWrite,
    output reg         MemWrite,  
    output reg         MemRead,
    output reg         Fill,         //In case of the miss
    output reg         Stall,        //To stop the RISC for 4 clock cycle
    output reg         CounterEn
);

localparam IDLE  = 2'b00,
           Read  = 2'b01,
           Write = 2'b11;

reg [1:0] PresentState;
reg [1:0] NextState;

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        PresentState <= IDLE;
    end
    else begin
        PresentState <= NextState;
    end
end

always @(*) begin
   case (PresentState)
   IDLE : begin
        CacheRead = 1'b0;
        MemRead = 1'b0;
        MemWrite= 1'b0;
        Fill = 1'b0;
        Stall = 1'b0;
        CounterEn = 1'b0;
        CacheWrite = 1'b0;

    if(Valid && Tag == Address[9:7] && MemReadCpu) begin //Read hit
        CacheRead = 1'b1; //to read one word
        MemRead = 1'b0;   //No read to read from the data memory
        MemWrite= 1'b0;
        Fill = 1'b0;
        Stall = 1'b0;
        CounterEn = 1'b0;
        CacheWrite = 1'b0;
        NextState = IDLE;
        
    end
    else if(Valid && Tag == Address[9:7] && MemWriteCpu) begin //Write hit
        NextState = Write;
        CacheRead = 1'b0; 
        MemRead = 1'b0;   
        MemWrite= 1'b1;  //Updating the value in the data memory
        Fill = 1'b0;
        Stall = 1'b1; 
        CounterEn = 1'b1;
        CacheWrite = 1'b1; //Updating the value in the cache, too

    end
    

    else if((!Valid || !Tag) && MemReadCpu) begin //Read miss
        NextState = Read;
        CacheRead = 1'b0; 
        MemRead = 1'b1;   //To read one block from the data memory
        MemWrite= 1'b0;
        Fill = 1'b0;
        Stall = 1'b1;
        CounterEn = 1'b1;
        CacheWrite = 1'b0;
    end
    

    else if((!Valid || !Tag) && MemWriteCpu) begin //Write miss
        NextState = Write;
        CacheRead = 1'b0; 
        MemRead = 1'b0;   
        MemWrite= 1'b1;
        Fill = 1'b0;
        Stall = 1'b1;
        CounterEn = 1'b1;
        CacheWrite = 1'b0;
    
    end

    else begin
        NextState <= IDLE;
        CacheRead = 1'b0;
        MemRead = 1'b0;
        MemWrite= 1'b0;
        Fill = 1'b0;
        Stall = 1'b0;
        CounterEn = 1'b0;
        CacheWrite = 1'b0;
    end
    end 
        
Read : begin //Read miss
    if(Ready) begin
        NextState = IDLE; 
        CacheRead = 1'b0;
        MemRead = 1'b0;
        MemWrite= 1'b0;
        Fill = 1'b1;
        Stall = 1'b0;
        CounterEn = 1'b0;
        CacheWrite = 1'b0;
    end
        else begin
        NextState = Read;
        CacheRead = 1'b0;
        MemRead = 1'b1;
        MemWrite= 1'b0;
        Fill = 1'b0;
        Stall = 1'b1;
        CounterEn = 1'b1;
        CacheWrite = 1'b0;
    end
end

Write : begin
    if(Ready) begin
        if((!Valid || !Tag) && MemWriteCpu) begin //write miss
            NextState = IDLE;
            CacheRead = 1'b0;
            MemRead = 1'b0;
            MemWrite= 1'b0;
            Fill = 1'b0;
            Stall = 1'b0;
            CounterEn = 1'b0;
            CacheWrite = 1'b0;
        end
        else begin   //write hit
            NextState = IDLE;
            CacheRead = 1'b0;
            MemRead = 1'b0;
            MemWrite= 1'b0;
            Fill = 1'b0;
            Stall = 1'b0;
            CounterEn = 1'b0;
            CacheWrite = 1'b1;
        end     
    end
        else begin
        NextState = Write;
        if((!Valid || !Tag) && MemWriteCpu) begin //write miss
            CacheRead = 1'b0;
            MemRead = 1'b0;
            MemWrite= 1'b1;
            Fill = 1'b0;
            Stall = 1'b1;
            CounterEn = 1'b1;
            CacheWrite = 1'b0;
        end
        else begin   //write hit
            CacheRead = 1'b0;
            MemRead = 1'b0;
            MemWrite= 1'b1;
            Fill = 1'b0;
            Stall = 1'b1;
            CounterEn = 1'b1;
            CacheWrite = 1'b0; 
        end     
    end
end
    default: begin
        NextState = IDLE;
        CacheRead = 1'b0;
        MemRead = 1'b0;
        MemWrite= 1'b0;
        Fill = 1'b0;
        Stall = 1'b0;
        CounterEn = 1'b0;
        CacheWrite = 1'b0;
    end
   endcase 
end
    
endmodule