`timescale 1ns/1ns
module tb_paritygen_8bit;
reg [7:0]d;
reg v,en;
wire pb;
paritygen_8bit uut(.d(d),.v(v),.en(en),.pb(pb));
initial begin
$dumpfile("tb_paritygen_8bit.vcd");
$dumpvars(0,tb_paritygen_8bit);
d=8'b01001011;
v=1'b1;
en=1'b0;
#30 $finish;
end
always #1 d[0]=~d[0];
always #1 d[1]=~d[1];
always #2 d[2]=~d[2];
always #3 d[3]=~d[3];
always #0.5 d[4]=~d[4];
always #1 d[5]=~d[5];
always #3 d[6]=~d[6];
always #2 d[7]=~d[7];
always #1 v=~v;
always #2 en=~en;
endmodule