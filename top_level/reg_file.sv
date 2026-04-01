// cache memory/register file
module mid_reg_file #(parameter pw=3)(
  input[7:0] dat_in,
  input      clk,
  input      wr_en,
  input      pari,
  input[pw-1:0] wr_addr, // write address pointer
                rd_addrA, // read address pointers
		rd_addrB,
  output logic[7:0] datA_out,
                    datB_out,
		    branchVal);

  logic[7:0] core[2**pw]; // 2-dim array  8 wide 8 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];
  assign branchVal = core[3'b111];

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    core[3'b110] <= {7'b0000000,pari};
    if(wr_en)
      core[wr_addr] <= dat_in;
  end
endmodule