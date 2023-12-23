/*
Author: Tom Diederen
Date: Sept 2023
Title: ALU / Execution Unit, part of Rudimentary Processor Design Project
Summary: This is the shifter part of the Execution Unit. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/
module eu_shifter #(parameter BUS_WIDTH)(input [3:0] op_select
    , input [BUS_WIDTH-1:0] B
    , output reg [BUS_WIDTH-1:0] data_out
);

    reg[BUS_WIDTH-1:0] result;

    always@(op_select, B) begin
        if(op_select[3:2] == 2'b11) begin //The architecture has op_select values of 4'b11xx go to the shifter
            case(op_select[1:0])
                2'b00  : result = B;    //MOVB                        
                2'b01  : result = B >> 1;    //SHR              
                2'b10  : result = B << 1;    //SHL 
            endcase
        end
    data_out = result;
    end

endmodule: eu_shifter
