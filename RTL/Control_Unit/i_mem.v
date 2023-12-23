/*
Author: Tom Diederen
Date: Sept 2023
Title: Instruction Memory, part of Rudimentary Processor Design Project
Summary: ROM holding 16-bit instructions
https://github.com/TDIE/cpu_arch
*/
module i_mem #(parameter BUS_WIDTH=16)(input [BUS_WIDTH-1:0] instr_address
    , output reg [BUS_WIDTH-1:0] instruction
);

    wire [BUS_WIDTH-1:0] mem [65535:0]; //16 bit memory

    //Sample Program (rd: register, destination. rsA: register, source, A)
    //Load register x with value x (LDI)
    assign mem[0] = 16'b100_1100_000_000_000; //LDI: Load immediate: 7'b100_1100, rd: 3'b000, rsA: 3'b000 (don't care), rsB 3'b000: load 0 in reg0
    assign mem[1] = 16'b100_1100_001_000_001; //LDI: 1 -> reg1 
    assign mem[2] = 16'b100_1100_010_000_010; //LDI: 2 -> reg2
    assign mem[3] = 16'b100_1100_011_000_011; //LDI: 3 -> reg3
    assign mem[4] = 16'b100_1100_100_000_100; //LDI: 4 -> reg4
    assign mem[5] = 16'b100_1100_101_000_101; //LDI: 5 -> reg5
    assign mem[6] = 16'b100_1100_110_000_110; //LDI: 6 -> reg6
    assign mem[7] = 16'b100_1100_111_000_111; //LDI: 7 -> reg7
    
    //Perform arithmetic instructions
    assign mem[8] = 16'b000_0000_000_001_000; //MOVA: r1 -> r0
    assign mem[9] = 16'b000_0001_000_001_000; //INC: r1 + 1 -> r0
    assign mem[10] = 16'b000_0010_000_001_010; //ADD: r1 + r2 -> r0
    assign mem[11] = 16'b000_0101_000_001_010; //SUB: r4 - 2 -> r0
    assign mem[12] = 16'b000_0110_000_010_010; //DEC: r4 - 2 -> r0
    
    //Perform logic instructions
    assign mem[13] = 16'b000_1000_000_010_010; //Logic AND: r4 && r2 -> r0
    assign mem[14] = 16'b000_1001_000_010_010; //Logic OR: r4 || r2 -> r0
    assign mem[15] = 16'b000_1010_000_010_010; //Logic XOR: r4 ^ r2 -> r0
    assign mem[16] = 16'b000_1011_000_010_010; //NOT: !r4
    assign mem[17] = 16'b000_1100_000_010_010; //MOVB r2 -> r0 (not a logic op but done by the same execution unit so in same op code range)

    //Load/Store
    assign mem[18] = 16'b001_0000_000_010_010; //LDI: RAM[rsA] -> r0
    assign mem[19] = 16'b010_0000_000_010_010; //ST: r2 -> RAM[rsA]
    
    //Add/Load Immediate
    assign mem[20] = 16'b100_0010_000_010_010; //ADI: r2 + instr[2:0] -> r0
    assign mem[21] = 16'b100_1100_000_010_010; //LDI: instr[2:0] -> r0

    //Jump/Branch
    assign mem[22] = 16'b110_0000_000_010_010; //BRZ: rsA == 1'b0 ? prog_counter+= {instr[8:6], instr[2:0]} : prog_counter+=1 (rd and rsB: don't care)
    assign mem[23] = 16'b111_0000_000_010_010; //JMP: rsA -> prog_counter (rd and rsB: don't care)


    always @(instr_address) begin
        instruction = mem[instr_address];
    end
endmodule: i_mem