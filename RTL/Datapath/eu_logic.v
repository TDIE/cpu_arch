/*
Author: Tom Diederen
Date: Sept 2023
Title: ALU, part of Rudimentary Processor Design Project
Summary: This is the Logic part of the ALU. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
module eu_logic #(parameter BUS_WIDTH)(input [3:0] op_select
    , input [BUS_WIDTH-1:0] A
    , input [BUS_WIDTH-1:0] B
    , output reg [BUS_WIDTH-1:0] data_out
);

    reg[BUS_WIDTH-1:0] result;

    always @(op_select, A, B) begin
        if(op_select[3:2] == 2'b10 ) begin //The architecture has op_select values of 4'b10xx go to the logic unit
            case(op_select[1:0])
                2'b00  : result = A & B;    //AND                        
                2'b01  : result = A | B;    //OR                
                2'b10  : result = A ^ B;    //XOR                                  
                2'b11  : result = ~A;       //NOT
            //default: X? Z?
            endcase
        end     
        //Output result of calculations
        data_out = result;
    end
endmodule: eu_logic