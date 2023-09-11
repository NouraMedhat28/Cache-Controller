module MemorySystemTB ();
    reg         MemReadCpu;
    reg         MemWriteCpu;
    reg [9:0]   Address;
    reg         CLK;
    reg         RST;
    reg [31:0]  DataIn;
    wire        Stall;
    wire [31:0] DataOut;  

    MemorySystem          MemSys
    (.MemReadCpu          (MemReadCpu),
     .MemWriteCpu         (MemWriteCpu),
     .Address             (Address),
     .CLK                 (CLK),
     .RST                 (RST),
     .DataIn              (DataIn),
     .Stall               (Stall),
     .DataOut             (DataOut)
    );

    always #50 CLK = ~CLK;

    initial begin
        CLK         = 1'b1;
        RST         = 1'b0;
        MemReadCpu  = 1'b0;
        MemWriteCpu = 1'b1;
        Address     = 10'b00000_00000;
        DataIn      = 32'h2805;

        #100
        if(DataOut == 32'b0) begin
            $display("Reset TC: Passed!");
        end

        else begin
            $display("Reset TC: Failed!");
        end

        RST         = 1'b1;
        #100
        if(Stall == 1'b1 && DataOut == 32'b0) begin
            $display("Write miss TC1: Passed!");
        end

        else begin
            $display("Write miss TC1: Failed!");
        end
        #350

        
        MemReadCpu  = 1'b1;
        MemWriteCpu = 1'b0;
        Address     = 10'b00000_00000;
        #550

        if(DataOut == 32'h2805 && Stall == 1'b0) begin
            $display("Read miss TC1: Passed!");
        end

        else begin
            $display("Read miss TC1: Failed!");
        end


        MemReadCpu  = 1'b0;
        MemWriteCpu = 1'b1;
        Address     = 10'b00000_00000;
        DataIn      = 32'h3008;
        #100
        if(DataOut == 32'h2805 && Stall == 1'b1) begin
            $display("Write hit TC1: Passed!");
        end

        else begin
            $display("Write hit TC1: Failed!");
        end
        #400

        MemReadCpu  = 1'b1;
        MemWriteCpu = 1'b0;
        Address     = 10'b00000_00000;
        #150
        if(DataOut == 32'h3008 && Stall == 1'b0) begin
            $display("Read hit TC1: Passed!");
        end

        else begin
            $display("Read hit TC1: Failed!");
        end

        MemReadCpu  = 1'b1;
        MemWriteCpu = 1'b0;
        Address     = 10'b00000_00001;
        #150
        if(DataOut == 32'h0000_0000 && Stall == 1'b0) begin
            $display("Read hit TC2: Passed!");
        end

        else begin
            $display("Read hit TC2: Failed!");
        end

        MemReadCpu  = 1'b0;
        MemWriteCpu = 1'b1;
        Address     = 10'b00000_00101;
        DataIn      = 32'h30205;
        #100
        if(DataOut == 32'h0000_0000 && Stall == 1'b1) begin
            $display("Write miss TC2: Passed!");
        end

        else begin
            $display("Write miss TC2: Failed!");
        end
        #400


        MemReadCpu  = 1'b1;
        MemWriteCpu = 1'b0;
        Address     = 10'b00000_00100;
        #550

        if(DataOut == 32'h0000_0000 && Stall == 1'b0) begin
            $display("Read miss TC2 and Cache Alignment TC1: Passed!");
        end

        else begin
            $display("Read miss TC2 and Cache Alignment TC1: Failed!");
        end


        MemReadCpu  = 1'b1;
        MemWriteCpu = 1'b0;
        Address     = 10'b00000_00101;
        #150
        if(DataOut == 32'h30205 && Stall == 1'b0) begin
            $display("Read hit TC3 and Cache Alignment TC2: Passed!");
        end

        else begin
            $display("Read hit TC3 and Cache Alignment TC1: Failed!");
        end
    end
        
endmodule