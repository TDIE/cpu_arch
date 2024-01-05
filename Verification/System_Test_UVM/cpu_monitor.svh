//The cpu monitor captures signals through the cpu interface (cpu_if). 
//Signals are broadcasted through its analysis port. 
//Depending on the environment config, the monitor output can be sent to: the scoreboard, coverage collector, and/or the register model.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "cpu_agent_config.svh"
`include "cpu_mon_bus_seq_item.svh"

class cpu_monitor extends uvm_monitor;
    //Register with the UVM Factory
    `uvm_component_utils(cpu_monitor)

    uvm_analysis_port #(cpu_mon_bus_seq_item) ap;    //Analysis port
    virtual cpu_if m_cpu_if;                        //Virtual interface handle
    cpu_agent_config m_cpu_agent_config;            //Config object (containt virt. if. handle)
    cpu_mon_bus_seq_item mon_bus_txn;               //Monitor sequence item at bus level

    //Constructor
    function new(string name="cpu_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        ap = new("ap", this);
        
        //Get config object from uvm_config_db and set virtual interface handle
        if(!uvm_config_db #(cpu_agent_config)::get(this, "", "m_cpu_agent_config", m_cpu_agent_config)) `uvm_error("Config Error", "Cannot find cpu_agent_config in uvm_config_db")
        m_cpu_if = m_cpu_agent_config.m_cpu_if;
    endfunction
    
    //Run Phase
    task run_phase(uvm_phase phase);
        mon_bus_txn = cpu_mon_bus_seq_item::type_id::create("mon_bus_txn");

        forever begin
            @(posedge m_cpu_if.cb)
                //Populate mon_bus_txn
                mon_bus_txn.instruction = m_cpu_if.instruction;
                mon_bus_txn.instr_addr = m_cpu_if.instr_addr;
                mon_bus_txn.op_select = m_cpu_if.op_select;
                mon_bus_txn.bus_D = m_cpu_if.bus_D;
                mon_bus_txn.address_out = m_cpu_if.address_out;
                mon_bus_txn.data_out = m_cpu_if.data_out;
                mon_bus_txn.zero = m_cpu_if.zero;
                mon_bus_txn.data_in = m_cpu_if.data_in;
                mon_bus_txn.reset = m_cpu_if.reset;
                // `uvm_info(get_type_name(), $sformatf("Monitor output:  %s", mon_bus_txn.convert2string()), UVM_LOW);
                ap.write(mon_bus_txn);
        end
    endtask
endclass: cpu_monitor
