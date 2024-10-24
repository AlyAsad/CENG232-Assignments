`timescale 1ns / 1ps

module ROM (
input [2:0] addr,
output reg [7:0] dataOut);
always@(addr) begin

	if (addr == 0) dataOut = 8'b00000000;
	
	if (addr == 1) dataOut = 8'b01010101;
	
	if (addr == 2) dataOut = 8'b10101010;
	
	if (addr == 3) dataOut = 8'b00110011;
	
	if (addr == 4) dataOut = 8'b11001100;
	
	if (addr == 5) dataOut = 8'b00001111;
	
	if (addr == 6) dataOut = 8'b11110000;
	
	if (addr == 7) dataOut = 8'b11111111;

end
endmodule

module Difference_RAM (
input mode,
input [2:0] addr,
input [7:0] dataIn,
input [7:0] mask,
input CLK,
output reg [7:0] dataOut);

reg[7:0] memory [0:7];

initial begin
dataOut = 0;
memory[0] = 0;
memory[1] = 0;
memory[2] = 0;
memory[3] = 0;
memory[4] = 0;
memory[5] = 0;
memory[6] = 0;
memory[7] = 0;
end

always@(mode or addr) begin //read mode
	if (mode == 1) dataOut = memory[addr];
end

always@(posedge CLK) //write mode
begin
	if (mode == 0) memory[addr] = (dataIn > mask) ? dataIn - mask : mask-dataIn;
end

endmodule


module EncodedMemory (
input mode,
input [2:0] index,
input [7:0] number,
input CLK,
output [7:0] result);

	wire [7:0] mask;

	ROM R(index, mask);
	Difference_RAM DR(mode, index, number, mask, CLK, result);

endmodule


