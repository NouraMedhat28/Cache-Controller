module Cache (
    input   wire [9:0]   Address, //10 bit address [5 cache line, 2 word]
    input   wire         CLK,
    input   wire         RST,
    input   wire [127:0] DataMemOut, //Data coming from the data memory (16 bytes = 128 bits = 4 words = 1 block)
    input   wire         CacheRead,
    input   wire         CacheWrite,
    input   wire [31:0]  DataInCpu,
    input   wire         fill,    //control signal to write in the cache
    output  reg  [31:0]  DataOutCpu,    //32 bit data
    output  wire         Valid,
    output  wire  [2:0]  Tag
);

reg [31:0] CacheMemory [0:127]; //1bit for the valid signal and 31 for the data
reg [2:0] tag [0:127];
reg valid [0:127];
integer i;

    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            for(i = 0; i<= 127; i=i+1) begin
                CacheMemory[i] <= 32'b0;
                valid[i]       <= 1'b0;
                tag[i]         <= 3'b0;
                DataOutCpu     <= 32'b0;
            end
    end
    else if(CacheRead) begin //In case of read hit
        valid [Address[6:0]]   <= 1'b1;
        tag   [Address[6:0]]   <= Address[9:7];
        DataOutCpu  <= CacheMemory[Address[6:0]];
    end
    
    else if(CacheWrite) begin //write hit
        CacheMemory[Address[6:0]] <= DataInCpu; 
        tag [Address[6:0]]        <= Address[9:7]; 
        valid[Address[6:0]]       <= 1'b1;
    end 
    end

    always @(*) begin
        if(fill) begin //In case of read miss
        CacheMemory[{Address[6:2], 2'b00}]  <= DataMemOut[31:0];
        CacheMemory[{Address[6:2], 2'b01}]  <= DataMemOut[63:32];
        CacheMemory[{Address[6:2], 2'b10}]  <= DataMemOut[95:64];
        CacheMemory[{Address[6:2], 2'b11}]  <= DataMemOut[127:96];

        //Setting the valid 
        valid [{Address[6:2], 2'b00}] <= 1'b1;
        valid [{Address[6:2], 2'b01}] <= 1'b1;
        valid [{Address[6:2], 2'b10}] <= 1'b1;
        valid [{Address[6:2], 2'b11}] <= 1'b1;

        tag   [{Address[6:2], 2'b00}] <= Address[9:7];
        tag   [{Address[6:2], 2'b01}] <= Address[9:7];
        tag   [{Address[6:2], 2'b10}] <= Address[9:7];
        tag   [{Address[6:2], 2'b11}] <= Address[9:7];

        DataOutCpu <= CacheMemory[Address[6:0]];
    end
    else if(CacheRead) begin //In case of read hit
        valid [Address[6:0]]   <= 1'b1;
        tag   [Address[6:0]]   <= Address[9:7];
        DataOutCpu  <= CacheMemory[Address[6:0]];
    end
    end

    assign Tag   = tag[Address[6:0]];
    assign Valid = valid[Address[6:0]];
endmodule