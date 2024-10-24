`timescale 1ns / 1ps
module lab3_2(
			input[5:0] money,
			input CLK,
			input vm, //0:VM0, 1:VM1
			input [2:0] productID, //000:sandwich, 001:chocolate, 11x: dont care
			input sugar, //0: No sugar, 1: With Sugar
			output reg [5:0] moneyLeft,
			output reg [4:0] itemLeft,
			output reg productUnavailable,//1:show warning, 0:do not show warning
			output reg insufficientFund , //1:full, 0:not full
			output reg notExactFund , //1:full, 0:not full
			output reg invalidProduct, //1: empty, 0:not empty
			output reg sugarUnsuitable, //1: empty, 0:not empty
			output reg productReady	//1:door is open, 0:closed
	);

	// Internal State of the Module
	// (you can change this but you probably need this)
	reg [4:0] numOfSandwiches = 10;
	reg [4:0] numOfChocolate = 10;
	reg [4:0] numOfWaterVM0 = 5;
	reg [4:0] numOfWaterVM1 = 10;
	reg [4:0] numOfCoffee = 10;
	reg [4:0] numOfTea = 10;
	

	initial begin ///initialize here
	end

	//Modify the lines below to implement your design
	always @(posedge CLK)
	begin
	
		invalidProduct = 0;
		productUnavailable = 0;
		sugarUnsuitable = 0;
		notExactFund = 0;
		insufficientFund = 0;
		productReady = 0;

	case (vm)
		0: begin
			case(productID)
				3'b000: begin
				if (numOfSandwiches) begin
					if (money == 20) begin
						moneyLeft = 0;
						numOfSandwiches = numOfSandwiches - 1;
						itemLeft = numOfSandwiches;
						productReady = 1;
					end
					else begin
						notExactFund = 1;
						moneyLeft = money;
					end
				end
				else begin
					productUnavailable = 1;
					moneyLeft = money;
				end
				end
				
				
				
				3'b001: begin
				if (numOfChocolate) begin
					if (money == 10) begin
						moneyLeft = 0;
						numOfChocolate = numOfChocolate - 1;
						itemLeft = numOfChocolate;
						productReady = 1;
					end
					else begin
						notExactFund = 1;
						moneyLeft = money;
					end
				end
				else begin
					productUnavailable = 1;
					moneyLeft = money;
				end
				end
				
				
				3'b010: begin
				if (numOfWaterVM0) begin
					if (sugar == 0) begin
						if (money == 5) begin
							moneyLeft = 0;
							numOfWaterVM0 = numOfWaterVM0 - 1;
							itemLeft = numOfWaterVM0;
							productReady = 1;
						end
						else begin
							notExactFund = 1;
							moneyLeft = money;
						end
					end
					else begin
					sugarUnsuitable = 1;
					moneyLeft = money;
					end
				end
				else begin
					productUnavailable = 1;
					moneyLeft = money;
				end
				end
				
				default: begin
					invalidProduct = 1;
					moneyLeft = money;
					end
					
			endcase
		end
				
	
		default: begin
			case(productID)
				3'b010: begin
					if (numOfWaterVM1) begin
						if (sugar == 0) begin
							if (money >= 5) begin
								moneyLeft = money - 5;
								numOfWaterVM1 = numOfWaterVM1 - 1;
								itemLeft = numOfWaterVM1;
								productReady = 1;
							end
							else begin
								insufficientFund = 1;
								moneyLeft = money;
							end
						end
						else begin
						sugarUnsuitable = 1;
						moneyLeft = money;
						end
					end
				else begin
					productUnavailable = 1;
					moneyLeft = money;
				end
				end
				
				3'b011: begin
					if (numOfCoffee) begin
						if (money >= 12) begin
							moneyLeft = money - 12;
							numOfCoffee = numOfCoffee - 1;
							itemLeft = numOfCoffee;
							productReady = 1;
						end
						else begin
							insufficientFund = 1;
							moneyLeft = money;
						end
					end
				else begin
					productUnavailable = 1;
					moneyLeft = money;
				end
				end
				
				
				3'b100: begin
					if (numOfTea) begin
						if (money >= 8) begin
							moneyLeft = money - 8;
							numOfTea = numOfTea - 1;
							itemLeft = numOfTea;
							productReady = 1;
						end
						else begin
							insufficientFund = 1;
							moneyLeft = money;
						end
					end
				else begin
					productUnavailable = 1;
					moneyLeft = money;
				end
				end
				
				
				default: begin
					invalidProduct = 1;
					moneyLeft = money;
				end
			endcase
		
		end //ending the default case
	endcase //ending case(vm)
	end //ending always@


endmodule



