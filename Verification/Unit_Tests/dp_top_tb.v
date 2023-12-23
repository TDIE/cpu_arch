/*
Author: Tom Diederen
Date: Sept 2023
Title: testbench for top level of the datapath, part of my Rudimentary Processor Design Project
Summary: The datapath contains a register file and execution unit. Based on certain control values, 
provided by the control unit, micro-operations are performed and stored back in the register file the next clock cycle.
https://github.com/TDIE/cpu_arch
*/
//'timescale 10ns/1ns

module dp_top_tb #(parameter BUS_WIDTH=16);
    //Connections to dapath inputs
    reg regWrite;
    reg [2:0] rsA;
    reg [2:0] rsB;
    reg [2:0] rd;
    reg [2:0] constant_in;
    reg MB;
    reg MD;
    reg [3:0] op_select;
    reg [15:0] data_in;
    reg clk;

    //Connections to datapath outputs
    wire [BUS_WIDTH-1:0] address_out;
    wire [BUS_WIDTH-1:0] data_out;
    wire zero;

    //Integer for loops
    integer i;

    //Module Instantiation
    dp_top #(.BUS_WIDTH(16)) dut(.regWrite(regWrite)
        , .rsA(rsA)
        , .rsB(rsB)
        , .rd(rd)
        , .constant_in(constant_in)
        , .MB(MB)
        , .MD(MD)
        , .op_select(op_select)
        , .data_in(data_in)
        , .clk(clk)
        , .address_out(address_out)
        , .data_out(data_out)
        , .zero(zero)
    );

    //Clock
    always #10 clk = ~clk;

    //Perform EU operation, inputs: control signals that change for this type of op, task body: control signals that stay the same.
    task eu_op(input [2:0] t_rsA, t_rsb, t_rd, input [3:0] t_op_select); 
        begin
            #20
            regWrite = 1'b1;            //Enable write to registers
            rsA = t_rsA;                //Select register A
            rsB = t_rsb;                //Select register B
            rd = t_rd;                  //Select destination register 
            constant_in = 3'b000;       //MUX B == 1'b0, so value doesn't matter
            MB = 1'b0;                  //Select output of register file, not constant_in
            MD = 1'b0;                  //Select output of EU, no external memory
            op_select = t_op_select;    //For MOVA instruction these bits must be zero
            data_in = 16'hF000;         //Mux D == 1'b0, value doesn't matter
            //#20 regWrite = 1'b0;        //Disable register write again
        end
    endtask
    
    //Drive and Monitor Signals
    initial begin
        $monitor("Inputs: time= %d \t clk = %b \t regWrite = %b \t rsA = %b \t rsB = %b \t rd = %b \t constant_in = %b \t MB = %b \t MD = %b \t op_select = %b \t, data_in = %h"
        , $time
        , clk
        , regWrite
        , rsA
        , rsB
        , rd
        , constant_in
        , MB
        , MD
        , op_select
        , data_in
        );

        $monitor("Outputs: time = %d \t clk = %b \t rf_out_A: %h \t rf_out_B: %h \t EU_out: %h \t Bus_D: %h"
        , $time
        , clk
        , dut.rf_EU_A
        , dut.rf_MB
        , dut.EU_out
        , dut.bus_D
        );

        //Initial values
        clk = 1'b1;
        #10
        regWrite = 1'b0;
        rsA = 3'b001;
        rsB = 3'b010;
        rd = 3'b000;
        constant_in = 3'b000;
        MB = 1'b0;
        MD = 1'b0;
        op_select = 4'b0000;
        data_in = 16'h0000;
        
        //Load all 7 registers with arbitrary value from memory (LD
        for(i=0; i<8; i=i+1) begin
            #20
            regWrite = 1'b1;        //Enable write to registers
            rsA = 3'b001;           //MUX D == 1'b1, value doesn't matter
            rsB = 3'b010;           //MUX D == 1'b1, value doesn't matter
            rd = 3'b000 + i;        //destination register, value of data_in should show up here after 1 clk cycle
            constant_in = 3'b000;   //MUX B == 1'b0, value doesn't matter
            MB = 1'b0;              //Select output of register file, not constant_in
            MD = 1'b1;              //Select output of external memory, not EU
            op_select = 4'b0000;    //MUX D == 1'b1, value doesn't matter
            data_in = 16'hF000 + i; //Arbitrary input data
        end   

        //Load 1 register with value from constant_in
        #20
            regWrite = 1'b1;        //Enable write to registers
            rsA = 3'b001;           //MOVB, op_select == 4'b1100. Value of rsA doesn't matter
            rsB = 3'b010;           //MUX B == 1'b1, value of rsB doesn't matter
            rd = 3'b010;            //Destination register,
            constant_in = 3'b111;   //Value to be stored in rd, 
            MB = 1'b1;              //Select output of constant_in, not the register file
            MD = 1'b0;              //Select output of EU, not external memory
            op_select = 4'b1100;    //MOVB: r2 -> rd
            data_in = 16'hF000 + i; //MUX D == 1'b0, value doesn't matter

        //A few testcases for ALU/Shifter micro-operations (excluding jump / branch ops). Better coverage to be verified with UVM later.
            //Perform operations using the EU and register input. 
                //Arguments: rsA, rsB, rd, op_select. (rsA: register source A, rd register, destination)
                //Register addresses and op_select vary, other control signals are constant for these operations (set in task).
                
                //Arithmetic unit ops
                eu_op(3'b001, 3'b000, 3'b000, 4'b0000); //MOVA: r1 -> r0 rsb: don't care
                eu_op(3'b001, 3'b000, 3'b000, 4'b0001); //INC: r1 + 1 -> r0 rsb: don't care
                eu_op(3'b010, 3'b011, 3'b000, 4'b0010); //ADD: r2 + r3 -> r0
                eu_op(3'b010, 3'b011, 3'b000, 4'b0101); //SUB: r2 - r3 -> r0
                eu_op(3'b111, 3'b011, 3'b000, 4'b0110); //DEC: r7 -1 -> r0 rsb: don't care

                //Logic unit ops
                eu_op(3'b100, 3'b101, 3'b000, 4'b1000); //AND: r4 && r5 -> r0
                eu_op(3'b100, 3'b101, 3'b000, 4'b1001); //OR: r4 || r5 -> r0
                eu_op(3'b100, 3'b101, 3'b000, 4'b1010); //XOR: r4 ^ r5 -> r0
                eu_op(3'b101, 3'b101, 3'b000, 4'b1011); //NOT: /r5 -> r0 rsb: don't care

                //Shifter unit ops
                eu_op(3'b110, 3'b110, 3'b000, 4'b1100); //MOVB: r6 -> r0 rsa: don't care (pass-through, no shift)
                eu_op(3'b110, 3'b111, 3'b000, 4'b1101); //SHR: r6 >> 1 -> r0 rsa: don't care
                eu_op(3'b110, 3'b111, 3'b000, 4'b1110); //SHL: r6 << 1 -> r0 rsa: don't care

            //Perform ADI (add immediate): reg1 + constant in, store in reg0
             #20
            regWrite = 1'b1;        //Enable write to registers
            rsA = 3'b001;           //Pick value of reg1 as value to be added to (augend)
            rsB = 3'b010;           //value doesn't matter (constant_in will be added to reg1, not another register)
            rd = 3'b000;            //destination register
            constant_in = 3'b111;   //Value to be added "immediately" (addend)
            MB = 1'b1;              //Select output of register file, not constant_in
            MD = 1'b0;              //Select output of not EU not external memory
            op_select = 4'b0010;    //ADD: r1 + constant in (immediate value)
            data_in = 16'hF000; //Mux D == 1'b0, value doesn't matter
        #40 $stop;
    end
endmodule: dp_top_tb

