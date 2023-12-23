/*
Author: Tom Diederen
Date: Sept 2023
Title: Control Unit top layer, part of Rudimentary Processor Design Project
Summary: The Control Unit provides input to the datapath. It contains a Program Counter, PC, Instruction Memory, and Instruction Decoder.
https://github.com/TDIE/cpu_arch
*/

module ctrl_top #(parameter BUS_WIDTH=16)(input clk
    , input reset
    , input dp_eu_zero
    , input [BUS_WIDTH-1:0] dp_address_out       
    , output MB
    , output RW
    , output MD
    , output MW
    , output [3:0] op_select
    , output [2:0] rd
    , output [2:0] rsA
    , output [2:0] rsB
    , output [2:0] constant_in
    , output [BUS_WIDTH-1:0] tdo_instr_addr    //Test Data Out (to testbench)
    , output [BUS_WIDTH-1:0] tdo_instruction   //Test Data Out (to testbench)
    );

    //Internal connections (naming convention: from_to)
    wire [BUS_WIDTH-1:0] pc_imem;
    wire [BUS_WIDTH-1:0] imem_idec;
    wire PL; //idec to PC
    wire JB; //idec to PC

    //Module Instantiation: PC
    pc #(.BUS_WIDTH(16)) pc0 (.clk(clk)
        , .reset(reset)
        , .PL(PL)
        , .JB(JB)
        , .offset({imem_idec[8:6], imem_idec[2:0]})
        , .zero(dp_eu_zero)
        , .address_bus_A(dp_address_out)
        , .instr_addr(pc_imem)
    );
    
    //Module Instantiation: Instruction Memory
    i_mem #(.BUS_WIDTH(16)) imem0 (.instr_address(pc_imem)
        , .instruction(imem_idec)
    );

    //Module Instantiation: Instruction Decoder
    instr_dec idec0 (.instr(imem_idec)
        , .MB(MB)
        , .RW(RW)
        , .MD(MD)
        , .MW(MW)
        , .op_select(op_select)
        , .PL(PL)
        , .JB(JB)
        , .BC()//Not needed
        , .rd(rd)
        , .rsA(rsA)
        , .rsB(rsB)
    );

    assign constant_in = imem_idec[2:0];
    assign tdo_instr_addr = pc_imem;    //Test Data Out (to testbench)
    assign tdo_instruction = imem_idec; //Test Data Out (to testbench)
endmodule: ctrl_top
