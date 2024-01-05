//The cpu driver sends signals through the cpu interface (cpu_if) to the DUT, i.e. the CPU.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "cpu_drv_bus_seq_item.svh"

class cpu_driver extends uvm_driver #(cpu_drv_bus_seq_item);
    //Register with the UVM Factory
    `uvm_component_utils(cpu_driver)

    //Constructor
    function new(string name="cpu_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    //Handle to virtual interface
    virtual cpu_if m_cpu_if;

    //Drive signals in run phase
    task run_phase(uvm_phase phase);
        cpu_drv_bus_seq_item drv_bus_txn;

        forever begin
            //`uvm_info(get_type_name(), $sformatf("Driver run phase started"), UVM_LOW); 
            seq_item_port.get_next_item(drv_bus_txn);
            // `uvm_info(get_type_name(), $sformatf("Driver received sequence item. %s", drv_bus_txn.convert2string()), UVM_LOW);
            drive(drv_bus_txn);
            seq_item_port.item_done(); 
        end
    endtask: run_phase

    virtual task drive(cpu_drv_bus_seq_item drv_bus_txn);
         @(m_cpu_if.cb);
                m_cpu_if.cb.reset <= drv_bus_txn.reset;
                m_cpu_if.cb.data_in <= drv_bus_txn.data_in;
    endtask: drive
endclass: cpu_driver
