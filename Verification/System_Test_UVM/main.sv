//Main File of the UVM Testbench. Instantiates RTL and starts test.
//https://github.com/TDIE/cpu_arch

module hdl_top();
    import uvm_pkg::*;
    import base_test_pkg::*;
    //`include "cpu_if.svh"

    bit clk;
    
    //Instantiate interface to DUT: cpu_if
    cpu_if cpu_if0(.clk(clk));

    //Connect if to DUT
    top cpu_dut(
        .clk(clk),
        .reset(cpu_if0.reset),
        .data_in(cpu_if0.data_in),
        .address_out(cpu_if0.address_out),
        .data_out(cpu_if0.data_out),
        .tdo_instr_addr(cpu_if0.instr_addr),
        .tdo_instruction(cpu_if0.instruction),
        .tdo_op_select(cpu_if0.op_select),
        .tdo_bus_D(cpu_if0.bus_D),
        .tdo_zero(cpu_if0.zero)
    );

    initial begin
        uvm_config_db #(virtual cpu_if)::set(null, "uvm_test_top", "cpu_if", cpu_if0);//Add interface handle to uvm_config_db
        clk = 1'b1; //Initial clock value
    end

    always #25 clk = ~clk;

endmodule: hdl_top

module hvl_top();
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    initial begin
        uvm_config_db #(int)::set(null, "*", "recording_detail", 1); //Enable UVM Transaction Recording in Questa Sim
        run_test("base_test");
    end
endmodule: hvl_top