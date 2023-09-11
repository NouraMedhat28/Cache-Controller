module MemorySystem (
    input  wire         MemReadCpu,
    input  wire         MemWriteCpu,
    input  wire [9:0]   Address,
    input  wire         CLK,
    input  wire         RST,
    input  wire [31:0]  DataIn,
    output wire         Stall,
    output wire [31:0]  DataOut      
);

wire [127:0] DataInCache;
wire [1:0]   Count;
wire         Enable;
wire         Ready;
wire         MemWrite;
wire         MemRead;
wire         CacheRead;
wire         CacheWrite;
wire         Fill;
wire         Valid;
wire [2:0]   Tag;


   Cache                 CacheTop
   (.Address             (Address),
    .CLK                 (CLK),
    .RST                 (RST),
    .DataMemOut          (DataInCache), //128
    .CacheRead           (CacheRead),
    .fill                (Fill),   
    .DataInCpu           (DataIn),
    .CacheWrite          (CacheWrite), 
    .DataOutCpu          (DataOut),    
    .Valid               (Valid),
    .Tag                 (Tag)
   ); 

   DataMemory            DataMemoryTop
   (.Address             (Address),
    .DataInCpu           (DataIn),
    .MemRead             (MemRead),
    .MemWrite            (MemWrite),
    .Count               (Count),
    .CLK                 (CLK),
    .RST                 (RST),
    .Ready               (Ready),
    .DataOutMem          (DataInCache)
   );   

   Counter              CounterTop
   (.Enable             (Enable),
    .CLK                (CLK),
    .RST                (RST),
    .Count              (Count)
   );

   CacheController      ControllerTop
   (.Address            (Address),      
    .Tag                (Tag),           
    .Valid              (Valid),        
    .CLK                (CLK),
    .RST                (RST),
    .Ready              (Ready),
    .MemWriteCpu        (MemWriteCpu),   
    .MemReadCpu         (MemReadCpu),    
    .CacheRead          (CacheRead),     
    .CacheWrite         (CacheWrite),
    .MemWrite           (MemWrite),  
    .MemRead            (MemRead),
    .Fill               (Fill),      
    .Stall              (Stall),        
    .CounterEn          (Enable)
   ); 

endmodule