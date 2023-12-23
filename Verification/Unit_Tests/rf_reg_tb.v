/*
Author: Tom Diederen
Date: Sept 2023
Title: Testbench for register, part of Rudimentary Processor Design Project
Summary: single register with one input bus and 2 output busses. To be used in register file.
https://github.com/TDIE/cpu_arch
*/
module rf_reg_tb #(parameter BUS_WIDTH=16);
    reg regWrite;
    reg [BUS_WIDTH-1:0] in;
    reg clk;
    wire [BUS_WIDTH-1:0] out;

    rf_reg #(.BUS_WIDTH(16)) rf_reg0 (.regWrite(regWrite)
        ,.in(in)
        ,.clk(clk)
        ,.out(out)
    );

    //clk generation
	always #10 clk = ~clk;

    initial begin
        $monitor("time = %d \t regWrite = %b \t in = %h \t clk = %b \t out = %h \t", $time, regWrite, in, clk, out);
        clk = 1'b1;
        //test cases
        //Write
        #10
        regWrite = 1'b1;
        in = 16'h0F0F;
        #20
        regWrite = 1'b0;
        //Read
        #10
        //Write
         #10
        regWrite = 1'b1;
        in = 16'hFFFF;
        #20
        regWrite = 1'b0;
        #100
        $stop;
    end
endmodule: rf_reg_tb