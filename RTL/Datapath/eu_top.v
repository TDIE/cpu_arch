/*
Author: Tom Diederen
Date: Sept 2023
Title: Execution Unit, part of Rudimentary Processor Design Project
Summary: This EU contains an ALU and Shifter. Depending on the value of op_select, a certain micro-operation is performed.
https://github.com/TDIE/cpu_arch
*/

module eu_top#(parameter BUS_WIDTH)(input [3:0] op_select
    , input [BUS_WIDTH-1:0] A
    , input [BUS_WIDTH-1:0] B
    , output [BUS_WIDTH-1:0] data_out
    , output zero
);

    wire [BUS_WIDTH-1:0] arithm_res, logic_res, shifter_res;

    //Module Instantiations
    eu_arithmetic #(.BUS_WIDTH(16)) arithm (.A(A)
            , .B(B)
            , .op_select(op_select)
            , .data_out(arithm_res)
            , .zero(zero)
        );				 

    eu_logic #(.BUS_WIDTH(16)) logic_unit (.A(A)
        , .B(B)
        , .op_select(op_select)
        , .data_out(logic_res)        
    );		

    eu_shifter #(.BUS_WIDTH(16)) shifter (.B(B)
        , .op_select(op_select)
        , .data_out(shifter_res)        
    );	
   
    //Output select
    //op_select[3:2]:
    //00 or 01: arithmetic unit
    //10: logic unit
    //11: shifter
    assign data_out = op_select[3]? (op_select[2] ? shifter_res : logic_res) : (arithm_res);
endmodule: eu_top