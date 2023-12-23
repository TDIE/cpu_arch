/*
Author: Tom Diederen
Date: Sept 2023
Title: Program Counter, part of Rudimentary Processor Design Project.
Summary: The Program Counter provides addresses for the instruction memory. It will go through addresses sequentially unless it receives input signals corresponiding to a jump or branch instruction. (or overflows, handling out of scope for this project)
https://github.com/TDIE/cpu_arch
*/

module pc #(parameter BUS_WIDTH=16) (input clk
    , input reset
    , input PL
    , input JB
    , input [5:0] offset
    , input zero
    , input [BUS_WIDTH-1:0] address_bus_A
    , output reg [BUS_WIDTH-1:0] instr_addr
    );

    //State Encoding
    localparam  STATE_RESET = 3'b000;   //Reset, PC Address: all zeroes.
    localparam  STATE_INCR1 = 3'b001;   //Normal operation, increase address in program counter by 1.
    localparam  STATE_INCR2 = 3'b101;   //Normal operation, increase address in program counter by 1.
    localparam  STATE_JUMP1 = 3'b010;    //Jump to new address. PL = 1'b1, JB = 1'b1.
    localparam  STATE_JUMP2 = 3'b110;    //Jump to new address. PL = 1'b1, JB = 1'b1.
    localparam  STATE_BRANCH1 = 3'b011;  //Branch to PC address + offset. PC Load Enabled (PL = 1'b1 ), JB (jump/branch) = 1'b0.
    localparam  STATE_BRANCH2 = 3'b111;  //Branch to PC address + offset. PC Load Enabled (PL = 1'b1 ), JB (jump/branch) = 1'b0.

    //Current and next state storage
    reg [2:0] state;
    reg [2:0] next_state;

    //State Transition
    always @(posedge clk) begin
        if(reset) state <= STATE_RESET;
        else state <= next_state;
    end

    //Next state determnination
    // reset -> STATE_RESET
    // PL 0, JB DC -> STATE_INCR, if multiple clock cycles, keep toggling between states 1 and 2 and increase PC by 1 every cycle
    // PL 1, JB 0 -> STATE_BRANCH, if multiple clock cycles, keep toggling between states 1 and 2 and offset PC every cycle
    // PL 1, JB 1 -> STATE_JUMP, if multiple clock cycles, keep toggling between states 1 and 2 and jump to new address every cycle
    always @(*) begin
        next_state = state;
        case(state) 
            STATE_RESET     :   begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A))  next_state = STATE_BRANCH1;
                    else next_state = STATE_INCR1;
                end
                else if (!PL) next_state = STATE_INCR1;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP1;
            end

            STATE_INCR1      :    begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A)) next_state = STATE_BRANCH1;
                    else next_state = STATE_INCR2;
                end
                else if (!PL) next_state = STATE_INCR2;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP1;
                else next_state = STATE_INCR2;
            end
            STATE_INCR2      :    begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A)) next_state = STATE_BRANCH1;
                    else next_state = STATE_INCR1;
                end
                else if (!PL) next_state = STATE_INCR1;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP1;
                else next_state = STATE_INCR1;
            end

            STATE_JUMP1      :   begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A)) next_state = STATE_BRANCH1;
                    else next_state = STATE_INCR1;
                end
                else if (!PL) next_state = STATE_INCR1;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP2;
            end
            STATE_JUMP2      :   begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A)) next_state = STATE_BRANCH1;
                    else next_state = STATE_INCR1;
                end
                else if (!PL) next_state = STATE_INCR1;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP1;
            end

            STATE_BRANCH1    :   begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A)) next_state = STATE_BRANCH2;
                    else next_state = STATE_INCR1;
                end
                else if (!PL) next_state = STATE_INCR1;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP1;
            end
            STATE_BRANCH2    :   begin
                if (reset) next_state = STATE_RESET;
                else if ({PL, JB} == 2'b10) begin
                    if (&(~address_bus_A)) next_state = STATE_BRANCH1;
                    else next_state = STATE_INCR1;
                end
                else if (!PL) next_state = STATE_INCR1;
                else if ({PL, JB} == 2'b11) next_state = STATE_JUMP1;
            end
        endcase
    end

    //Outputs
    always @(state) begin
        case(state)
            STATE_RESET : instr_addr = 16'h0000;
            STATE_INCR1 : instr_addr = instr_addr +1;
            STATE_INCR2 : instr_addr = instr_addr +1;
            STATE_JUMP1 : instr_addr = address_bus_A;
            STATE_JUMP2 : instr_addr = address_bus_A;
            STATE_BRANCH1 : instr_addr = instr_addr + offset;
            STATE_BRANCH2 : instr_addr = instr_addr + offset;
        endcase 
    end

endmodule: pc