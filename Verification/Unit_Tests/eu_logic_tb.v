/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for EU Logic, part of Rudimentary Processor Design Project
Summary: This is a tb for the logic part of the ALU. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module eu_logic_tb#(parameter BUS_WIDTH = 16)();
	reg [BUS_WIDTH-1:0] A;
    reg [BUS_WIDTH-1:0] B;
    reg [3:0] op_select;
	wire [BUS_WIDTH-1:0] data_out;

    eu_logic #(.BUS_WIDTH(16)) dut (.A(A)
        , .B(B)
        , .op_select(op_select)
        , .data_out(data_out)        
    );		

    initial begin
	
		$monitor("time = %d \t op_select = %b \t A = %h \t B = %h \t data_out = %h ", $time, op_select, A, B, data_out);
        op_select = 4'b0000;   
        A = 16'h0000;
        B = 16'h0000;

        //Test cases
        // AND
        #10
        op_select = 4'b1000;   
        A = 16'h0000;
        B = 16'h0000;
        #10
        op_select = 4'b1000;   
        A = 16'h0001;
        B = 16'h0000;
        #10
        op_select = 4'b1000;   
        A = 16'hcafe;
        B = 16'hcafe;
        // OR
        #10
        op_select = 4'b1001;   
        A = 16'h0000;
        B = 16'h0010;
        #10
        op_select = 4'b1001;   
        A = 16'h1000;
        B = 16'h1000;
        // XOR
        #10
        op_select = 4'b1010;   
        A = 16'h0000;
        B = 16'h0000;
        #10
        op_select = 4'b1010;   
        A = 16'h0000;
        B = 16'h1000;
        #10
        op_select = 4'b1010;   
        A = 16'h1000;
        B = 16'h1000;
        //Negate/NOT
        #10
        op_select = 4'b1011;   
        A = 16'h0000;
        #10
        op_select = 4'b1011;   
        A = 16'hFF11;    
    end
endmodule: eu_logic_tb