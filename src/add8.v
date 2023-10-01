// 8-bit Add Module

`define WIDTH 8

module add8 (
    input clock,
    input [`WIDTH-1:0] in0, in1,
    output [`WIDTH-1:0] out
);

reg [`WIDTH-1:0] in0_reg, in1_reg;
always@(posedge clock) begin
    in0_reg <= in0;
    in1_reg <= in1;
end

adder #(`WIDTH) adder0 (.in0(in0_reg), .in1(in1_reg), .out(out));
endmodule




module adder#( parameter W = 8 ) (
    input [`WIDTH-1:0] in0, in1,
    output [`WIDTH-1:0] out
);
assign out = in0 + in1;
endmodule