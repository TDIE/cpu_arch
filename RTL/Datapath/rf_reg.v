/*
Author: Tom Diederen
Date: Sept 2023
Title: Register for Register File, part of Rudimentary Processor Design Project
Summary: single register with one input bus and 2 output busses. To be used in register file.
https://github.com/TDIE/cpu_arch
*/
module rf_reg #(parameter BUS_WIDTH=16)(input regWrite
    , input [BUS_WIDTH-1:0] in
    , input clk
    , output [BUS_WIDTH-1:0] out
    );

    reg [BUS_WIDTH-1:0] data;

    always@(posedge clk) begin
        if (regWrite == 1'b1) data <= in;
    end

    assign out = data;
endmodule: rf_reg
