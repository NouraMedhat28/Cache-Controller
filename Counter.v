module Counter (
    input  wire       Enable,
    input  wire       CLK,
    input  wire       RST,
    output reg  [1:0] Count
);

    always @(posedge CLK or negedge RST) begin
        if(!RST) begin
            Count  <= 2'b00;
        end
        else if(Enable && Count!=2'b11) begin
            Count <= Count + 1;
        end
        else if (!Enable || Count==2'b11)begin
            Count <= 2'b00;
        end
        else begin
            Count <= Count;
        end
    end
endmodule