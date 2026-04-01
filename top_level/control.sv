// control decoder
module mid_control #(parameter opwidth = 3, mcodebits = 3)(
  input [mcodebits-1:0] instr,
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite);

always_comb begin   // defaults
  RegDst     =   0; // 1: not in place  just leave 0
  Branch     =   0; // 1: branch (jump)
  MemWrite   =   0; // 1: store to memory
  ALUSrc     =   0; // 1: immediate  0: second reg file output
  RegWrite   =   0; // 0: for store  1: most other operations 
  MemtoReg   =   0; // 1: load -- route memory instead of ALU to reg_file data in

case(instr)
  'b000:  begin                    // MOV
            RegWrite = 1;      
          end
  'b001:  begin                    // NAND
            RegWrite = 1;
          end
  'b010:  begin                     // ADD
            RegWrite = 1;
          end
  'b011:  begin                     // LDR
            RegWrite = 1;
            MemtoReg = 1;
          end
  'b100:  begin                     // STR
            MemWrite = 1;
          end
  'b101:  begin                     // SET
            RegWrite = 1;
            ALUSrc = 1;
          end
  'b110:  begin                     // ROR
            RegWrite = 1;
            ALUSrc = 1;
          end
  'b111:  begin                     // BNE
            Branch = 1;
          end
endcase
end
endmodule