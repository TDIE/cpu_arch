/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for the instruction decoder, part of my Rudimentary Processor Design Project
Summary: the instruction decoder contains purely of combination logic that translates the instruction bits to the control word
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module instr_dec_tb ();
    
    //Connections to data inputs
    reg [15:0] instr;
    
    //Connections to data outputs
    wire MB;             //Datapath.MB
    wire RW;             //Datapath.RegWrite
    wire MD;             //Datapath.MD
    wire MW;             //RAM.MW (MemWrite)
    wire [3:0] op_select;//Datapath.op_select
    wire PL;             //PC.PL
    wire JB;             //PC.JB
    wire BC;             //PC.BC
    wire [2:0] rd;       //Datapath.rd (register, destination)
    wire [2:0] rsA;      //Datapath.rsA (register, source, A)
    wire [2:0] rsB;     //Datapath.rsB (register, source, B)
    
    //Module instantiation
    instr_dec idec(.instr(instr)
        , .MB(MB)
        , .RW(RW)
        , .MD(MD)
        , .MW(MW)
        , .op_select(op_select)
        , .PL(PL)
        , .JB(JB)
        , .BC(BC)
        , .rd(rd)
        , .rsA(rsA)
        , .rsB(rsB)
    );

    initial begin
        $monitor("time: %d \t Instr: %h \t MB: %b \t RW: %b \t MD: %b \t MW: %b \t op_select: %b \t PL: %b \t JB: %b \t BC: %b \t rd: %b \t rsA: %b \t rsB: %b"
        , $time
        , instr
        , MB
        , RW
        , MD
        , MW
        , op_select
        , PL
        , JB
        , BC
        , rd
        , rsA
        , rsB
        );
    
        //Testcases
        //instruction bits 15:9 are opcode, 8:6 rd (register, destination), 5:3 rsA (register, source, A) 2:0 rsB
        #10 instr = 16'b100_0010_000_001_010; // Add Immediate, rd: 0, rsA: 1, rsB: 2
        #10 instr = 16'b001_0000_111_101_100; // Load memory store in regs, rd: 7, rsA: Don't Care, rsB: DC
        #10 instr = 16'b010_0000_111_101_100; // Store reg content to memory, rsA: address, rsB: data to store
        #10 instr = 16'b000_1110_000_101_100; // shift left content of rsB, reg4 store in rd: 0
        #10 instr = 16'b000_1011_111_101_100; // Complement value of rsA, reg5, store in rd, reg7.
        #10 instr = 16'b110_0000_111_101_100; // Branch if rsA, reg5, has value of zero. Branch to PC + {instr[8:6], instr[2:0]}
        #10 instr = 16'b111_0000_111_110_100; // Unconditional jump, PC <- RsA (reg6) 
        #10 $stop;
    end
endmodule: instr_dec_tb