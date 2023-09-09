`timescale 1ns/1ns
module SingleCycleRISCTB ();
reg CLK, RST;

always #50 CLK = ~CLK;

SingleCycleRISC               SingleCycleRISCTesting
(.CLK                         (CLK),
 .RST                         (RST)
);
initial begin
  RST = 1'b0;
  CLK = 1'b1;
  #200

  RST = 1'b1;
  #6000;
end
endmodule