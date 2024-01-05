//The cpu bus sequence generates bus sequence items for the cpu_driver.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "cpu_drv_bus_seq_item.svh"

class cpu_bus_seq extends uvm_sequence #(cpu_drv_bus_seq_item);
    //Register with UVM Factory
    `uvm_object_utils(cpu_bus_seq)

    cpu_drv_bus_seq_item drv_bus_txn;
    int n_times = 24;

    //Constructor
    function new(string name="cpu_bus_seq");
        super.new(name);
    endfunction

    task body();
        drv_bus_txn = cpu_drv_bus_seq_item::type_id::create("drv_bus_txn");

        //First sequence item resets the CPU
        start_item(drv_bus_txn);
        drv_bus_txn.reset = 1;
        drv_bus_txn.data_in = 16'h0000;
        finish_item(drv_bus_txn);

        //RAM output is simulated this project. 
        //Send randomly chosen input data 24 times (sample program contains 24 instructions, some of which need RAM input)
        for (int i = 0; i < 24; i++) begin
            start_item(drv_bus_txn);
            drv_bus_txn.reset = 0;
            drv_bus_txn.data_in = 16'h0000 + i;
            finish_item(drv_bus_txn);
        end
    endtask: body
endclass: cpu_bus_seq
