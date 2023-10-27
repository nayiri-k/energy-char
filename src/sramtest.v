
module sramtest (
    clock,we,wmask,addr,din,dout
);

  parameter DATA_WIDTH = 4 ;
  parameter ADDR_WIDTH = 6 ;
  parameter WMASK_WIDTH = 2 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;

  input  clock; // clock
  input  we; // write enable
  input [WMASK_WIDTH-1:0] wmask; // write mask
  input [ADDR_WIDTH-1:0]  addr; // address
  input [DATA_WIDTH-1:0]  din; // data in
  output [DATA_WIDTH-1:0] dout; // data out

sram22_64x4m4w2 mem0 (
  .clk(clock),.we(we),.wmask(wmask),
  .addr(addr),.din(din),.dout(dout)
  );

endmodule