/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for EU arithmetic, part of Rudimentary Processor Design Project
Summary: This is a tb for the arithmetic part of the ALU. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module eu_arithmetic_tb#(parameter BUS_WIDTH = 16)();
	reg [BUS_WIDTH-1:0] A;
    reg [BUS_WIDTH-1:0] B;
    reg [3:0] op_select;
	wire [BUS_WIDTH-1:0] data_out;
	wire zero; 

    eu_arithmetic #(.BUS_WIDTH(16)) dut (.A(A)
        , .B(B)
        , .op_select(op_select)
        , .data_out(data_out)
        , .zero(zero)
    );				 
	
	initial begin
	
		$monitor("time = %d \t op_select = %b \t A = %h \t B = %h \t data_out = %h \t zero = %b", $time, op_select, A, B, data_out, zero);
    
        //Testcases
        //Zero flag
		A = 16'h0000;
        B = 16'h0000;
        op_select = 4'b0000;      

        //MOVA
		#10 
        A = 16'h0001;
        op_select = 4'b0000;

        //INC
            //1. Non Overflow
            #10
            A = 16'h00FF;
            op_select = 4'b0001;      
            //2. Overflow
            #10 
            A = 16'h7FFF;
            op_select = 4'b0001;   

        //ADD
            //1. Non Overflow
            #10 
            A = 16'h00FF;
            B = 16'h0000;
            op_select = 4'b0010;      
            //2. Overflow
            #10 
            A = 16'hFFF1;
            B = 16'h000F;
            op_select = 4'b0010;   
        //SUB
            //1. Positive result
            #10
            A = 16'h00FF;
            B = 16'h000F;
            op_select = 4'b0101;  
            //2. Negative result
            #10
            A = 16'h0000;
            B = 16'h0001;
            op_select = 4'b0101;  
        //DEC
        //1. Positive result
            #10
            A = 16'h0001;
            op_select = 4'b0110;  
            //2. Negative result
            #10
            A = 16'h0000;
            op_select = 4'b0110; 
	
		#20 $stop;
	end
endmodule: eu_arithmetic_tb