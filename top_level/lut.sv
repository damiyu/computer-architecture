module mid_lut #(parameter D=12)(
  input       [7:0] addr,
		    jumpr,
  input       [2:0] opcode,
  input       [11:0] prog_ctr,
  output logic        jumpa,
  output logic[D-1:0] target);

  always_comb case(prog_ctr)
	118: begin
		if(opcode == 3'b111 && addr == 8'b1)
			target = 12'b000001101010;
	     	else
			target = 'b0;
		jumpa = 0;
	end
	251: begin
		if(opcode == 3'b111 && addr == 8'b1)
			target = 12'b000001110010;
       	        else
			target = 'b0;
                jumpa = 0;
	end
	263: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd1;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	321: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd594;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	356: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	376: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	396: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	417: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	441: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	465: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	489: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	513: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	538: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	564: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	590: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	593: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd613;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	620: begin
		if (opcode == 3'b111 && addr == 8'b1) begin
			target = 12'd1;
			jumpa = 1;
	      	end
	      	else begin
			target = 'b0;
			jumpa = 0;
	      	end
	end
	default: begin
		if(opcode == 3'b111 && addr == 8'b1)
			  target = {4'b0,jumpr};
  	        else
			  target = 'b0;
		jumpa = 0;
	end
  endcase
endmodule