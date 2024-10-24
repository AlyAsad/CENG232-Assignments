`timescale 1ns / 1ps



// BH Flip-Flop module:
module bh(input B, input H, input clk, output reg Q);

initial Q = 1;
always@(posedge clk)
begin
	if (B == 0 && H == 0)
		Q = !Q;
	else if (B == 0 && H == 1)
		Q = 1;
	else if (B == 1 && H == 0)
		Q = 0;
end

endmodule




// ic1337 Module
module ic1337(input A0, input A1, input A2, input clk, 
					output Q0, output Q1, output Z);
					
bh bh1((A0^(!A1)) | A2, A0 & (!A2), clk, Q0);
bh bh2(A0 & !A2, ~(!A0 | A1) & A2, clk, Q1);
assign Z = Q0 ~^ Q1;

endmodule

