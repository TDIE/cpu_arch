/*
Author: Tom Diederen
Date: Sept 2023
Title: Datapath top layer, part of Rudimentary Processor Design Project
Summary: The datapath contains a register file and execution unit. Based on certain control values, 
provided by the control unit, micro-operations are performed and stored back in the register file the next clock cycle.
https://github.com/TDIE/cpu_arch
*/

module dp_top #(parameter BUS_WIDTH=16)(input regWrite //RW
        , input [2:0] rsA
        , input [2:0] rsB
        , input [2:0] rd
        , input [2:0] constant_in
        , input MB
        , input MD
        , input [3:0] op_select
        , input [BUS_WIDTH-1:0] data_in
        , input clk
        , output [BUS_WIDTH-1:0] address_out
        , output [BUS_WIDTH-1:0] data_out
        , output zero

        , output [BUS_WIDTH-1:0] tdo_bus_D          //Test Data Out (to testbench)
        //, output [BUS_WIDTH-1:0] tdo_address_out    //Test Data Out (to testbench)
        //, output [BUS_WIDTH-1:0] tdo_data_out       //Test Data Out (to testbench)
        , output                 tdo_zero           //Test Data Out (to testbench)
    );

    //Declarations of internal connections (naming convention: from_to)
    wire [BUS_WIDTH-1:0] rf_EU_A;
    wire [BUS_WIDTH-1:0] rf_MB;
    wire [BUS_WIDTH-1:0] MB_EU_B;
    wire [BUS_WIDTH-1:0] EU_out;
    wire [BUS_WIDTH-1:0] bus_D;

    //Module Instantiation of the Register File
    rf_reg_top #(.BUS_WIDTH(16)) rf_reg0 (.regWrite(regWrite)
        , .D(bus_D)
        , .rd(rd)
        , .clk(clk)
        , .rsA(rsA)
        , .rsB(rsB)
        , .A(rf_EU_A)
        , .B(rf_MB)
    );

    //Module Instantiation of the Execution Unit (ALU + Shifter)
    eu_top #(.BUS_WIDTH(16)) eu0 (.op_select(op_select)
        , .A(rf_EU_A)
        , .B(MB_EU_B)
        , .data_out(EU_out)
        , .zero(zero)
    );

    //Internal connections (naming convention: from_to) 
    assign MB_EU_B = MB? {13'b0_0000_0000_0000, constant_in} : rf_MB; //Mux B
    assign bus_D = MD? data_in : EU_out; //Mux D
    assign address_out = rf_EU_A;
    assign data_out = MB_EU_B;

    //Test Data Out, tdo, connections (to testbench)
    assign tdo_bus_D = bus_D;
    //assign tdo_address_out = rf_EU_A;
    //assign tdo_data_out = MB_EU_B;
    assign tdo_zero = zero;

endmodule: dp_top
