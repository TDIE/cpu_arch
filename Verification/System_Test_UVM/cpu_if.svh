//https://github.com/TDIE/cpu_arch
// Interface that connects the cpu (DUT) to the UVM testbench.

interface cpu_if(input bit clk);
    logic [15:0]    instruction;    //Instruction to be performed. Output of the Program Counter.
    logic [15:0]    instr_addr;     //Instruction Address. Input of the Program Counter.
    logic  [3:0]    op_select;      //Operation Select for the Execution Unit.
    logic [15:0]    bus_D;          //Output of the Execution Unit.
    logic [15:0]    address_out;    //A.k.a. bus_A. Output 1/2 of the register file. Used for addresses.
    logic [15:0]    data_out;       //A.k.a. bus_b. Output 2/2 of the register file. Used for data 
    logic           zero;           //Status bit of the Arithmetic Unit: op result is 0.
    logic [15:0]    data_in;        //External data input (designed for RAM output)
    logic           reset;          //Reset (active high)

    clocking cb @(posedge clk);
        output #5 reset, data_in;
    endclocking: cb

    modport mp_mon (input instruction, instr_addr, op_select, bus_D, address_out, data_out, zero, data_in, reset);

    modport mp_drv(clocking cb);
endinterface: cpu_if