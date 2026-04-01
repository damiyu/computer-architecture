// sample top level design
module mid_top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12, // program counter width
    A = 3; // ALU command bit width
  wire[D-1:0] target,
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,datM, // register and data memory
              branchVal,
	      muxA, muxR, 
	      rslt, mem, // alu output and data memory
              immed;
  logic sc_in, // shift/carry out from/to ALU
   	pariQ, // registered parity flag from ALU
	zeroQ; // registered zero flag from ALU 
  wire  relj,
	absj;  // from control to PC; relative jump enable
  wire  pari,
        zero,
	sc_clr,
	sc_en,
        MemWrite,
        ALUSrc,
	MemtoReg; // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code; // machine code
  wire[2:0]   rd_addrA, rd_addrB; // address pointers to reg_file

  
// fetch subassembly
  mid_pc #(.D(D)) 					  // D sets program counter width
  pc1 (.reset(reset),
          .clk(clk),
          .reljump_en(relj),
	  .absjump_en(absj),
          .target(target),
          .prog_ctr(prog_ctr));

// lookup table to facilitate jumps/branches
  mid_lut #(.D(D))
    pl1 (.addr(rslt),
	 .jumpr(branchVal),
	 .opcode(alu_cmd),
	 .prog_ctr(prog_ctr),
	 .jumpa(absj),
         .target(target));   

// contains machine code
  mid_inst_mem ir1(.prog_ctr(prog_ctr),
                   .mach_code(mach_code));

  assign immed = {5'b00000,mach_code[2:0]};
  assign rd_addrA = mach_code[2:0];
  assign rd_addrB = mach_code[5:3];
  assign alu_cmd  = mach_code[8:6];
  mid_control ctl1(.instr(alu_cmd),
  		   .RegDst(), 
 		   .Branch(relj), 
                   .MemWrite(MemWrite), 
                   .ALUSrc(ALUSrc), 
                   .RegWrite(RegWrite),     
                   .MemtoReg(MemtoReg));

  assign muxR = MemtoReg ? mem : rslt;
  mid_reg_file #(.pw(3)) rf1(.dat_in(muxR), // loads, most ops
                             .clk(clk),
              		     .wr_en(RegWrite),
			     .pari(pari),
             		     .rd_addrA(rd_addrA),
           	   	     .rd_addrB(rd_addrB),
          		     .wr_addr(rd_addrB), // in place operation
          		     .datA_out(datA),
        	             .datB_out(datB),
			     .branchVal(branchVal)); 

  assign muxA = ALUSrc ? immed : datA;
  mid_alu alu1(.alu_cmd(alu_cmd),
               .inA(muxA),
	       .inB(datB),
	       .sc_i(sc), // output from sc register
               .rslt(rslt)       ,
	       .sc_o(sc_o), // input to sc register
	       .pari(pari));  

  assign datM = MemWrite ? datB : datA;
  mid_dat_mem dm1(.dat_in(rslt),  // from reg_file
                  .clk(clk),
		  .wr_en(MemWrite), // stores
		  .addr(datM),
                  .dat_out(mem));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 1024;
 
endmodule