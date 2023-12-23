/*
Author: Tom Diederen
Date: Sept 2023
Title: Instruction Decoder, part of Rudimentary Processor Design Project
Summary: Combinational logic that makes up the instruction decoder
https://github.com/TDIE/cpu_arch
*/
module instr_dec(input [15:0] instr
    , output MB             //Datapath.MB
    , output RW             //Datapath.RegWrite
    , output MD             //Datapath.MD
    , output MW             //RAM.MW (MemWrite)
    , output [3:0] op_select//Datapath.op_select
    , output PL             //PC.PL
    , output JB             //PC.JB
    , output BC             //PC.BC
    , output [2:0] rd       //Datapath.rd (register, destination)
    , output [2:0] rsA      //Datapath.rsA (register, source, A)
    , output [2:0] rsB      //Datapath.rsB (register, source, B)
);
    //Map control signals to instruction bits.
    //Refer to design doc, section 3.2.2.3, for background: https://github.com/TDIE/cpu_arch.
    wire i15_and_i14 = instr[15] && instr[14]; 

    assign MB = instr[15];                              //Mux B, selects between constant input (1) or register file output (0)
    assign RW = !instr[14];                             //RW: RegWrite, write to register selected with rd enabled if high
    assign MD = instr[13];                              //Mux D, selects between RAM input (1) or Execution Unit output (0)
    assign MW = (!instr[15]) && instr[14];              //Memwrite, indicates output should be written to RAM
    assign op_select[3] = instr[12];                    //op select bits, select an operation from the EU. 
    assign op_select[2] = instr[11];                    // 0xxx: Arithmetic, 10xx: Logic, 11xx: shifter. 
    assign op_select[1] = instr[10];                    //
    assign op_select[0] = instr[9] && !i15_and_i14;     //LSB is also used for branch condition, BC, additional logic chekcs that no jump or branch op is active to prevent collision.
    assign PL = i15_and_i14;                            //Program Counter Load (PC Load-> PL). 
    assign JB = instr[13];                              //Jump (1) / Branch (0). Used in conjunction with PL == 1
    assign BC = instr[9];                               //Branch condition, not used in this design (e.g. branch on zero vs branch on negative)
    assign rd = instr[8:6];                             //Register, destination
    assign rsA = instr[5:3];                            //Register, source, A
    assign rsB = instr[2:0];                            //Register, source, B
endmodule: instr_dec
