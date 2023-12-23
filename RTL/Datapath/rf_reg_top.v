/*
Author: Tom Diederen
Date: Sept 2023
Title: Register File top layer, part of Rudimentary Processor Design Project
Summary: register file holding 8 registers. 2 source registers, rsA and rsB, can be selected as well as one destination regsiter: rd. 
  A clock signal and the busses that connect to the two source registers and destination register complete the design.
https://github.com/TDIE/cpu_arch
*/
module rf_reg_top #(
      parameter BUS_WIDTH=16
   ) (
      input                       clk 
    , input  [BUS_WIDTH-1:0]      D
    , input  [2:0]                rd
    , input  [2:0]                rsA
    , input  [2:0]                rsB
    , input                       regWrite
    , output reg [BUS_WIDTH-1:0]  A
    , output reg [BUS_WIDTH-1:0]  B
);

  //Internal connections demux to registers
  reg [7:0] regSelect;
  wire [BUS_WIDTH-1:0] reg_outputs [7:0];

  //Select destination register for write operation
  always@(rd, regWrite) begin
    regSelect = 8'b0 | regWrite << rd;
    // case(rd)
    //   3'b000 : regSelect = {7'b0000_000, regWrite};
    //   3'b001 : regSelect = {6'b0000_00, regWrite, 1'b0};
    //   3'b010 : regSelect = {5'b0000_0, regWrite, 2'b00};
    //   3'b011 : regSelect = {4'b0000, regWrite, 3'b000};
    //   3'b100 : regSelect = {3'b000, regWrite, 4'b0000};
    //   3'b101 : regSelect = {2'b00, regWrite, 5'b0000_0};
    //   3'b110 : regSelect = {1'b0, regWrite, 6'b0000_00};
    //   3'b111 : regSelect = {regWrite, 7'b0000_000}; 
    //   //default : regSelect[7:0] = 8'b000_0000;
    // endcase
  end

  //Generate registers
  genvar i;
  generate
    for(i=0; i<8; i=i+1) begin
      rf_reg #(.BUS_WIDTH(16)) rf_register (.regWrite(regSelect[i])
        , .in(D)
        , .clk(clk)
        , .out(reg_outputs[i])
        );    
    end    
  endgenerate

  //Select source register A for read operation
  always@(rsA, reg_outputs) begin
    case(rsA)
      3'b000 : A = reg_outputs[0];
      3'b001 : A = reg_outputs[1];
      3'b010 : A = reg_outputs[2];
      3'b011 : A = reg_outputs[3];
      3'b100 : A = reg_outputs[4];
      3'b101 : A = reg_outputs[5];
      3'b110 : A = reg_outputs[6];
      3'b111 : A = reg_outputs[7];
      //default : ;
    endcase
  end

 //Select source register B for read operation
  always@(rsB, reg_outputs) begin
    case(rsB)
      3'b000 : B = reg_outputs[0];
      3'b001 : B = reg_outputs[1];
      3'b010 : B = reg_outputs[2];
      3'b011 : B = reg_outputs[3];
      3'b100 : B = reg_outputs[4];
      3'b101 : B = reg_outputs[5];
      3'b110 : B = reg_outputs[6];
      3'b111 : B = reg_outputs[7];
      //default : ;
    endcase
  end
endmodule: rf_reg_top

