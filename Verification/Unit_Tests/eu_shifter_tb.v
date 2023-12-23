/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for Execution Unit Shifter, part of Rudimentary Processor Design Project
Summary: This is a tb for the shifter part of the Execution Unit. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module eu_shifter_tb #(parameter BUS_WIDTH=16);
    reg [BUS_WIDTH-1:0] B;
    reg [3:0] op_select;
	wire [BUS_WIDTH-1:0] data_out;  

     eu_shifter #(.BUS_WIDTH(16)) dut (.B(B)
        , .op_select(op_select)
        , .data_out(data_out)        
    );	

    initial begin
        $monitor("time = %d \t op_select = %b \t B = %h \t data_out = %h ", $time, op_select, B, data_out);    
        op_select = 4'b0000;   
        B = 16'h0000;

        //Test cases
        //MOVB
        #10
        op_select = 4'b1100;   
        B = 16'hface;
        #10
        B = 16'hcafe;
        //SHR
        #10
        op_select = 4'b1101;   
        B = 16'h1001;
        #10
        B = 16'h0001;
        //SHL
        #10
        op_select = 4'b1110;   
        B = 16'h1001;
        #10
        B = 16'h0001;
    end

endmodule: eu_shifter_tb
