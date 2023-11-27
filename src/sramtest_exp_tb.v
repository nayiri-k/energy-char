`timescale 1ns/10ps


module sramtest_exp_tb;

    parameter DATA_WIDTH = 4 ;
    parameter ADDR_WIDTH = 6 ;
    parameter WMASK_WIDTH = 2 ;
    //parameter RAM_DEPTH = 1 << ADDR_WIDTH;

    reg clk = 0;
    always #(`CLOCK_PERIOD/2.0) clk = ~clk;

    reg  we_reg; // write enable
    wire [WMASK_WIDTH-1:0] wmask; // write mask
    reg [ADDR_WIDTH-1:0]  addr_reg; // address
    reg [DATA_WIDTH-1:0]  din_reg; // data in
    wire [DATA_WIDTH-1:0] dout; // data out

    sram22_64x4m4w2 sram_dut (
      .clk(clk),
      .we(we_reg),
      .wmask(wmask),
      .addr(addr_reg),
      .din(din_reg),
      .dout(dout)
    );

    assign wmask = {WMASK_WIDTH{1'b1}};

    initial begin
        din_reg = {DATA_WIDTH{4'd1}};
        //wmask = {WMASK_WIDTH{1'b1}};
        addr_reg = {ADDR_WIDTH{1'b0}};
        we_reg = 1'b0;

        @(negedge clk);
        we_reg = 1'b1;

        @(posedge clk); // we --> we_reg in sramtest

        @(negedge clk);

        $fsdbDumpfile("output.fsdb");
        $fsdbDumpvars("+all");
        $fsdbDumpon;
        //$vcdplusfile("sramtest.vpd");
        //$vcdpluson;
        //$vcdplusmemon;

        // perform SRAM write
        @(posedge clk);

        // stop dumping
        @(negedge clk);
        $display("Wrote %d to address %d",din_reg,addr_reg);
        //$vcdplusoff;
        //$fsdbDumpoff;

        // sanity check: re-read same value
        we_reg = 1'b0; // enable SRAM read
        @(posedge clk); // we --> we_reg in sramtest
        $fsdbDumpoff;
        @(posedge clk); // perform SRAM read
        @(negedge clk); // read out data
        $display("Read %d from address %d",dout,addr_reg);
        //$fsdbDumpoff;
        $finish;
    end

endmodule
