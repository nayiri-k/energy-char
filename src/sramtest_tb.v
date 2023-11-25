`timescale 1ns/10ps


module sramtest_tb;

    parameter DATA_WIDTH = 4 ;
    parameter ADDR_WIDTH = 6 ;
    parameter WMASK_WIDTH = 2 ;
    parameter RAM_DEPTH = 1 << ADDR_WIDTH;

    reg clk = 0;
    always #(`CLOCK_PERIOD/2.0) clk = ~clk;

    reg  we; // write enable
    reg [WMASK_WIDTH-1:0] wmask; // write mask
    reg [ADDR_WIDTH-1:0]  addr; // address
    reg [DATA_WIDTH-1:0]  din; // data in
    wire [DATA_WIDTH-1:0] dout; // data out

    sramtest sramtest_dut (
        .clock(clk),.we(we),.wmask(wmask),
        .addr(addr),.din(din),.dout(dout)
    );

    initial begin
        // reset - SRAM behavioral verilog resets all values to 0
        din = {DATA_WIDTH{'d13}};
        wmask = {DATA_WIDTH{1'b1}};
        addr = {DATA_WIDTH{'b0}};
        we = 1'b0;

        // load vals
        @(negedge clk);

        // enable SRAM write
        we = 1'b1;

        @(posedge clk); // we --> we_reg in sramtest

        @(negedge clk);

        $fsdbDumpfile("output.fsdb");
        $fsdbDumpvars("+all");
        $fsdbDumpon;

        // perform SRAM write
        @(posedge clk);

        // stop dumping
        @(negedge clk);
        $display("Wrote %d to address %d",din,addr);
        $fsdbDumpoff;

        // sanity check: re-read same value
        we = 1'b0; // enable SRAM read
        @(posedge clk); // we --> we_reg in sramtest
        @(posedge clk); // perform SRAM read
        @(negedge clk); // read out data
        $display("Read %d from address %d",dout,addr);
        // $fsdbDumpoff;
        $finish;
    end

endmodule
