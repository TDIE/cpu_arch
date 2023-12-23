/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for Execution Unit, part of Rudimentary Processor Design Project
Summary: This is a testbench for the Execution Unit. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module eu_top_tb #(parameter BUS_WIDTH=16);
    reg [3:0] op_select;
    reg [BUS_WIDTH-1:0] A;
    reg [BUS_WIDTH-1:0] B;
	wire [BUS_WIDTH-1:0] data_out;  
    wire zero;

    eu_top #(.BUS_WIDTH(16)) eu0 (.op_select(op_select)
        , .A(A) 
        , .B(B) 
        , .data_out(data_out)
        , .zero(zero)
        );		

    initial begin
        $monitor("time = %d \t op_select = %b \t A = %h \t B = %h \t data_out = %h \t zero = %b", $time, op_select, A, B, data_out, zero);   

        //test cases
        //MOVA
        #10
        op_select = 4'b000;
        A = 16'h10FF;
        B = 16'h1000;
        //INC
        #10
        op_select = 4'b0001;
        A = 16'h10FF;
        B = 16'h1000;
        //ADD
        #10
        op_select = 4'b0010;
        A = 16'h10FF;
        B = 16'h1000;
        //SUB
        #10
        op_select = 4'b0101;
        A = 16'h10FF;
        B = 16'h1000;
        //DEC
        #10
        op_select = 4'b0110;
        A = 16'h10FF;
        B = 16'h1000;
        //AND
        #10
        op_select = 4'b1000;
        A = 16'h10FF;
        B = 16'h1000;
        //OR
        #10
        op_select = 4'b1001;
        A = 16'h10FF;
        B = 16'h1000;
        //XOR
        #10
        op_select = 4'b1010;
        A = 16'h10FF;
        B = 16'h1000;
        //NOT
        #10
        op_select = 4'b1011;
        A = 16'h10FF;
        B = 16'h1000;
        //MOVB
        #10
        op_select = 4'b1100;
        A = 16'h10FF;
        B = 16'h1000;
        //SHR
        #10
        op_select = 4'b1101;
        A = 16'h10FF;
        B = 16'h1000;
        //SHL
        #10
        op_select = 4'b1110;
        A = 16'h10FF;
        B = 16'h1000;
    end
endmodule: eu_top_tb