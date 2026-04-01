"""
usage: python assembler.py [assembly file] [machine code file]

requires python 3.x

This assembler is assuming the bit breakdown as follows:
R-Type: 3 bit opcode, 3 bit operand register, and 3 bit operand register
I-Type: 3 bit opcode, 3 bit operand register, and 3 bit immediate
B-Type: 3 bit opcode, 3 bit operand register, and 3 bit operand register
"""

import sys

# map registers to binary
registers_three_bit = {
    "r0": "000",
    "r1": "001",
    "r2": "010",
    "r3": "011",
    "r4": "100",
    "r5": "101",
    "r6": "110",
    "RES": "111",
    }

# map opcode to binary
opcode = {
    "MOV": "000",
    "NAND": "001",
    "ADD": "010",
    "LDR": "011",
    "STR": "100",
    "SET": "101",
    "ROR": "110",
    "BNE": "111",
    }

sudoopcode = {'AND', 'ORR', 'EOR'}

# classify instructions into different types
rtype = ['MOV', 'NAND', 'ADD', 'LDR', 'STR']
sudotype = ['AND', 'ORR', 'EOR']
itype = ['SET', 'ROR']
btype = ['BNE']
comment_char = '//'

def sudoOp(oper, reg1, reg2):
    if oper == "EOR":
        return [opcode["MOV"]+registers_three_bit["r0"]+reg1,
                opcode["MOV"]+registers_three_bit["RES"]+reg2,
                opcode["NAND"]+registers_three_bit["r0"]+reg2,
                opcode["NAND"]+registers_three_bit["RES"]+registers_three_bit["r0"],
                opcode["NAND"]+registers_three_bit["r0"]+reg1,
                opcode["NAND"]+registers_three_bit["r0"]+registers_three_bit["RES"],
                opcode["MOV"]+reg1+registers_three_bit["r0"]]
    elif oper == "AND":
        return [opcode["NAND"]+reg1+reg2,
                opcode["NAND"]+reg1+reg1]
    elif oper == "ORR":
        return [opcode["NAND"]+reg1+reg1,
                opcode["MOV"]+registers_three_bit["RES"]+reg2,
                opcode["NAND"]+registers_three_bit["RES"]+registers_three_bit["RES"],
                opcode["NAND"]+reg1+registers_three_bit["RES"]]
    return []

with open(sys.argv[1], "r") as read, open(sys.argv[2], "w") as write:

# with automatically handles file (no need for open and close)
    line = read.readline() # read a line
    lineNum = 0
    # for every line
    while line:
        lineNum += 1
        # strip takes away whitespace from left and right
        line = line.strip()

        # split your comments out
        line = line.split(comment_char, 1)

        # store instruction and comment
        inst = line[0].strip()
        comment = ""
        if len(line) > 1:
            comment = line[1].strip()

        # split instruction into arguments
        if len(inst) < 1:
            line = read.readline()
            continue
        inst = inst.split(' ')

        # initialize the string that contains the machine code binary
        writeline = ''

        inst[0] = inst[0].upper()
        # check valid opcodes and sudos
        if inst[0] not in opcode and inst[0] not in sudoopcode:
            # if it an instruction that doesn't exist, exit
            print("Invalid opcode instruction at line ", lineNum - 1)
            sys.exit()

        # if it's r-type or b-type, then you know you have 2 args after
        if inst[0] in rtype or inst[0] in btype:
            writeline += opcode[inst[0]]
            writeline += registers_three_bit[inst[1]]
            writeline += registers_three_bit[inst[2]]
        if inst[0] in sudotype:
            specialIns = sudoOp(inst[0], registers_three_bit[inst[1]], registers_three_bit[inst[2]])
            for i in range(len(specialIns)):
                write.write(specialIns[i]+"\n")
                print(specialIns[i])
            line = read.readline()
            continue
        elif inst[0] in itype:
            writeline += opcode[inst[0]]
            writeline += registers_three_bit[inst[1]]

            # remove the hashtag and check if there's a valid immediate
            inst[2] = inst[2][1:len(inst[2])]
            if int(inst[2]) > 7:
                print("Invalid set instruction immediate at line ", lineNum - 1)
                sys.exit()
            
            inst[2] = str(bin(int(inst[2])))
            inst[2] = inst[2][2:len(inst[2])]
            if len(inst[2]) < 3:
                inst[2] = '0' * (3 - len(inst[2])) + inst[2]
            writeline += inst[2]

        print(writeline)
        # SystemVerilog ignores comments prepended with // with readmemb or readmemh
        if len(comment) > 0:
            writeline += '//' + comment
        writeline += '\n'

        # write the line into the desired file
        write.write(writeline)

        # read the next line
        line = read.readline()