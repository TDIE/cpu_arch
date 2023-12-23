/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for the Program Counter, part of my Rudimentary Processor Design Project
Summary: The Program Counter creates addresses for the instruction memory. It counts up sequenitally under normal operation and is capable of jumps and branches.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module pc_tb #(parameter BUS_WIDTH=16);
    //Connections to data inputs
    reg clk;                            //Clock
    reg reset;                          //Reset, PC address: all zeroes
    reg PL;                             //PC Load Enable
    reg JB;                             //Jump (1) Branch (0)
    reg [5:0] offset;                   //Address offset for branch instructions
    reg zero;                           //Zero flag from ALU output
    reg [BUS_WIDTH-1:0] address_bus_A;  //Connection to bus A, value is the address that jump instructions use to load the Program Counter
    
    //Connections to data output
    wire [BUS_WIDTH-1:0] instr_addr;    //Instruction address for the instruction memory

    //Module Instantiation
    pc #(.BUS_WIDTH(16)) pc0 (.clk(clk)
        , .reset(reset)
        , .PL(PL)
        , .JB(JB)
        , .offset(offset)
        , .zero(zero)
        , .address_bus_A(address_bus_A)
        , .instr_addr(instr_addr)
    );

    always #10 clk = ~clk;

    initial begin
        $monitor("$time: %d \t clk: %b \t  state: %b \t reset: %b \t PL: %b \t JB: %b \t offset: %b \t zero: %b \t address_bus_A: %h \t instr_addr: %h"
        , $time
        , clk
        , pc0.state
        , reset
        , PL
        , JB
        , offset
        , zero
        , address_bus_A
        , instr_addr
        );

        //Initial values
        clk = 1'b1;
        reset = 1'b0;
        PL = 1'b0;
        JB = 1'b0;
        zero = 1'b0;
        offset = 6'b000_010;
        address_bus_A = 16'hF0F0;
        
        //Testcases
        #10 reset = 1'b1;
        #20 reset = 1'b0;   //Leave reset condition. Test state transition: reset -> increment. 
        #20 zero = 1'b1;    //Set zero bit, no impact expected
        #40 reset = 1'b1;    //increment -> reset transition
        #40 reset = 1'b0;   //reset -> branch (non zero address on bus A)
            PL = 1'b1;
            JB = 1'b0;      
        #40 reset = 1'b1;   //branch -> reset
        #40 reset = 1'b0;   //reset -> jump
            PL = 1'b1;
            JB = 1'b1;    
        #40 reset = 1'b1;   //jump -> reset
        #40 reset = 1'b0;   //reset -> branch (zero address on bus A)
            address_bus_A = 16'h0000;
            PL = 1'b1;
            JB = 1'b0;
        #40 PL = 1'b0;      //branch -> incr
        #40 PL = 1'b1;      //incr -> branch
        #40 JB = 1'b1;      //branch -> jump
        #20 address_bus_A = 16'hF0F1; // 2 consectutive jumps (probably not very useful but test for wider coverage)
        #20 JB = 1'b0;      //jump -> branch
        #40 PL = 1'b0;      //branch -> incr
        #40 PL = 1'b1;
            JB = 1'b1;      //incr -> jump
        #40 PL = 1'b0;      //jump -> incr    
        #20 $stop;
    end
endmodule: pc_tb
