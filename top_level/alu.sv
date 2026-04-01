module mid_alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
	       zero      // NOR (output)
);

always_comb begin
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = !rslt;
  pari = ^rslt;
  case(alu_cmd)
    3'b000: // MOV
      rslt = inA;
    3'b001: // NAND
      rslt = ~ (inA & inB);
    3'b010: begin// ADD
      rslt = inA + inB;
      pari = ^(inA + inB);
    end
    3'b011: // LDR
      rslt = inB;
    3'b100: // STR
      rslt = inA;
    3'b101: // SET
      rslt = inA;
    3'b110: // ROR
      rslt = (inB << (8 - inA)) | (inB >> inA);
    3'b111: // BNE
      if(inA != inB)
	rslt = 8'b1;
      else
	rslt = 8'b0;
  endcase
  pari = ^rslt;
end
endmodule