/*
Author: Tom Diederen
Date: Sept 2023
Title: Testbench for the Instruction Memory, part of Rudimentary Processor Design Project
Summary: Testbench cycles through first 24 addresses.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns
module i_mem_tb #(parameter BUS_WIDTH=16);
    //Connection to data input
    reg [BUS_WIDTH-1:0] instr_address;

    //Connection to data output
    wire [BUS_WIDTH-1:0] instruction;

    //Module Instantiation
    i_mem #(.BUS_WIDTH(16)) i_mem0 (.instr_address(instr_address)
        , .instruction(instruction)
    );

    integer i;

    initial begin
        $monitor("time: \t instr_address: %h \t instruction: %h"
        , $time
        , instr_address
        , instruction      
        );

        for(i=0; i<24; i=i+1) #10 instr_address = 16'h0000 + i;
         #10 $stop;
    end   
endmodule: i_mem_tb