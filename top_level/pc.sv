module mid_pc #(parameter D=12)(
  input reset,
        clk,
	reljump_en, // rel. jump enable
        absjump_en, // abs. jump enable
  input       [D-1:0] target, // how far/where to jump
  output logic[D-1:0] prog_ctr
);

always_ff @(posedge clk)
	if(reset)
	 prog_ctr <= '0;
	else if(absjump_en)
	 prog_ctr <= target;
	else if(reljump_en && target != 12'b0) begin
	 if(target[7] == 1'b1)
	  prog_ctr <= prog_ctr + {5'b0,target[6:0]};
	 else
	  prog_ctr <= prog_ctr - {5'b0,target[6:0]};
	 end
	else
	 prog_ctr <= prog_ctr + 'b1;
endmodule