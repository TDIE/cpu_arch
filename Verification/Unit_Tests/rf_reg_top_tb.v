/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for Register File, part of Rudimentary Processor Design Project
Summary: This part contains 7 registers with parameterized I/O bus widths (default is 16). Each rising edge of the clk, 2 registers selected by
rsA and rsB will be output to bus A and B. Also on the posedge of clk: a register selected by rd will be written to if regWrite is high.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module rf_reg_top_tb #(parameter BUS_WIDTH=16);
    reg regWrite;
    reg [BUS_WIDTH-1:0] D;
    reg [2:0] rd;
    reg clk;
    reg [2:0] rsA;
    reg [2:0] rsB;
    wire [BUS_WIDTH-1:0] A;
    wire [BUS_WIDTH-1:0] B;
    integer i;

    //Module Instantiation
    rf_reg_top #(.BUS_WIDTH(16)) reg_f0 (.regWrite(regWrite)
        , .D(D)
        , .rd(rd)
        , .clk(clk)
        , .rsA(rsA)
        , .rsB(rsB)
        , .A(A)
        , .B(B)
    );

    always #10 clk = ~clk;

    initial begin
        $monitor("time = %d \t regWrite = %b \t D = %h \t rd = %b \t clk = %b \t rsA = %b \t rsB = %b \t A = %h \t B = %h regSelect = %b \t reg_outputs =%p", $time, regWrite, D, rd, clk, rsA, rsB, A, B, reg_f0.regSelect, reg_f0.reg_outputs);   
        
        //Initial values
        clk = 1'b1;
        D = 16'h0000;
        rd = 3'b000;
        rsA = 3'b000;
        rsB = 3'b000;   
        #10
        regWrite = 1'b1;

        //Test cases
        //Write to all registers
        for (i=0; i<8; i=i+1) begin
            #20           
            D = 16'hFF00 + i;
            rd = i; 
        end
 
        #10 regWrite = 1'b0;
        #10D = 16'h0000;

        //Load from all registers
        for (i=0; i<8; i=i+1) begin
            #20
            rsA = 3'b000 + i;
            rsB = 3'b111 - i;
        end

        //Write and read
        #20 regWrite = 1'b1;
        D = 16'hFFFF;
        rd = 3'b000;
        rsA = 3'b001;
        rsB = 3'b010;
        #40 $stop;
    end
   

endmodule: rf_reg_top_tb