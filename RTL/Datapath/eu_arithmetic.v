/*
Author: Tom Diederen
Date: Sept 2023
Title: ALU, part of Rudimentary Processor Design Project
Summary: This is the arithmetic part of the ALU. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
module eu_arithmetic #(parameter BUS_WIDTH = 16) (input [3:0] op_select
    , input [BUS_WIDTH-1:0] A
    , input [BUS_WIDTH-1:0] B
    , output reg [BUS_WIDTH-1:0] data_out
    , output reg zero
);

    reg [BUS_WIDTH-1:0] result;

    always @(op_select, A, B) begin

        if(op_select[3] == 0) begin //The architecture has op_select values of 4'b0xxx go to the arithmetic unit
            case(op_select[2:0])
                3'b000  : result = A;       //MOVA                        
                3'b001  : result = A + 1;   //INC                
                3'b010  : result = A + B;   //ADD                                   
                3'b101  : result = A - B;   //SUB
                3'b110  : result = A - 1;   //DEC                               
            //default: X? Z?
            endcase
        end 

        // check for zero 
        zero = result == '0 ? 1'b1 : 1'b0;
        // Drive output with result of calculations
        data_out = result;
    end   
    
endmodule: eu_arithmetic
