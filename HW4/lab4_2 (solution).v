`timescale 1ns / 1ps
module SelectionOfAvatar(
	input [1:0] mode,
	input [5:0] userID,
	input [1:0] candidate, // 00:Air 01:Fire, 10:Earth, 11: Water
	input CLK,
	output reg [1:0] ballotBoxId,
	output reg [5:0] numberOfRegisteredVoters,
	output reg [5:0] numberOfVotesWinner, // number of votes of winner
	output reg [1:0] WinnerId,
	output reg AlreadyRegistered,
	output reg AlreadyVoted,
	output reg NotRegistered,
	output reg VotingHasNotStarted,
	output reg RegistrationHasEnded
	);

integer cycle = 0, i;
reg [5:0] numOfReg = 0;
reg [5:0] numOfVotes [0:3];
reg voted [0:3][0:15];
reg registered [0:3][0:15];

	initial begin
		for (i = 0; i < 16; i = i + 1) begin
			registered[0][i] = 0;
			registered[1][i] = 0;
			registered[2][i] = 0;
			registered[3][i] = 0;
			voted[0][i] = 0;
			voted[1][i] = 0;
			voted[2][i] = 0;
			voted[3][i] = 0;
			
		end
		
		numOfVotes[0] = 0;
		numOfVotes[1] = 0;
		numOfVotes[2] = 0;
		numOfVotes[3] = 0;
		
		numberOfRegisteredVoters = 0;
		numberOfVotesWinner = 0;
		WinnerId = 0;
		
		AlreadyRegistered = 0;
		AlreadyVoted = 0;
		NotRegistered = 0;
		VotingHasNotStarted = 0;
		RegistrationHasEnded = 0;
		
	end

	always @(posedge CLK)
	begin
	
		numberOfRegisteredVoters = numOfReg;
		numberOfVotesWinner = 0;
		WinnerId = 0;
		
		AlreadyRegistered = 0;
		AlreadyVoted = 0;
		NotRegistered = 0;
		VotingHasNotStarted = 0;
		RegistrationHasEnded = 0;
		
		cycle = cycle + 1;

		//////////////////////////////////////////////////
		
		if (cycle <= 100) begin // 1st phase
			
			ballotBoxId = userID[5:4];
			
			if (mode == 1) VotingHasNotStarted = 1;
			else begin
				if (registered[ballotBoxId][userID[3:0]] == 0) begin
					registered[ballotBoxId][userID[3:0]] = 1;
					numOfReg = numOfReg + 1;
				end
				else AlreadyRegistered = 1;
			end
			
			numberOfRegisteredVoters = numOfReg;
			
		end //ending if cycle <= 100 (line 27)
		
		//////////////////////////////////////////////////
		
		else if (cycle <= 200) begin // 2nd phase
			
			ballotBoxId = userID[5:4];
			numberOfRegisteredVoters = numOfReg;
			
			if (mode == 0) RegistrationHasEnded = 1;
			else begin
				
				if (registered[ballotBoxId][userID[3:0]] == 0) NotRegistered = 1;
				else begin
					if (voted[ballotBoxId][userID[3:0]] == 1) AlreadyVoted = 1;
					else begin
						numOfVotes[candidate] = numOfVotes[candidate] + 1;
						voted[ballotBoxId][userID[3:0]] = 1;
					end
				end
				
			end
			
		end //ending if cycle <= 200
		
		//////////////////////////////////////////////////
		
		else begin // last phase
			
			cycle = cycle - 1; //so it doesnt overflow
			
			numberOfRegisteredVoters = numOfReg;
			
			//finding the max
			
			numberOfVotesWinner = numOfVotes[0];
			WinnerId = 0;
			
			for (i = 1; i < 4; i = i + 1) begin
				if (numOfVotes[i] > numberOfVotesWinner) begin
					numberOfVotesWinner = numOfVotes[i];
					WinnerId = i;
				end
			end
			
		end //ending last phase
		
		//////////////////////////////////////////////////
		
	end

endmodule
