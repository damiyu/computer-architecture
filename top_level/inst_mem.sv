module mid_inst_mem #(parameter D=12)(
  input       [D-1:0] prog_ctr,
  output logic[ 8:0] mach_code);

  logic[8:0] core[2**D];
  initial begin
    $readmemb("C:/Users/Darren Yu/OneDrive/Documents/GitHub/cse-141l/mid_top_level/mach_code.txt",core);
  end
  always_comb  mach_code = core[prog_ctr];
endmodule