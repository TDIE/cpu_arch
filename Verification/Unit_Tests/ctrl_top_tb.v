/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for top level of the control unit, part of my Rudimentary Processor Design Project
Summary: The control unit contains the program counter, read-only instruction memory, and an instruction decoder.
         The PC is sequential and the instruction memory and instruction decoder are combinational in order to facilitate single cycle execution (favoring simplicity over performance for this project)
*/
//'timescale 10ns/1ns

module ctrl_top_tb #(parameter BUS_WIDTH=16);
    //Connections to ctrl unit inputs
    reg clk;
    reg reset;
    reg dp_eu_zero;
    reg [BUS_WIDTH-1:0] dp_address_out;

    //Connections to ctrl unit outputs
    wire MB;
    wire RW;
    wire MD;
    wire MW;
    wire [3:0] op_select;
    wire [2:0] rd;
    wire [2:0] rsA;
    wire [2:0] rsB;
    wire [2:0] constant_in;

    //Module instantiation
    ctrl_top #(.BUS_WIDTH(16)) dut (.clk(clk)
        , .reset(reset)
        , .dp_eu_zero(dp_eu_zero)
        , .dp_address_out(dp_address_out)
        , .MB(MB)
        , .RW(RW)
        , .MD(MD)
        , .MW(MW)
        , .op_select(op_select)
        , .rd(rd)
        , .rsA(rsA)
        , .rsB(rsB)
        , .constant_in(constant_in)
    );

    //Clock
    always #10 clk = ~clk;

    //Drive and Monitor Signals
    initial begin
        $monitor("time: %d \t clk: %b \t reset: %b \t bus_A: %h \t MB: %b \t MD: %b \t MW: %b \t op_select: %b \t RW: %b \t rd: %b \t rsA: %b \t rsB: %b"
        , $time
        , clk
        , reset
        , dp_address_out
        , MB
        , MD
        , MW
        , op_select
        , RW
        , rd
        , rsA
        , rsB 
        );

    //Initial values
    clk <= 1'b1;
    reset <= 1'b1;
    dp_eu_zero <= 1'b0;
    dp_address_out <= 16'h000a;
    //Run program
    #30 reset = 1'b0;
    #490 reset = 1'b1;
    #30 $stop;
    end
endmodule: ctrl_top_tb
