//The cpu agent contains the driver, monitor, and sequencer.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "cpu_driver.svh"
`include "cpu_monitor.svh"
// `include "cpu_bus_seq.svh"
// `include "cpu_drv_bus_seq_item.svh"
//`include "cpu_mon_bus_seq_item.svh"
//`include "cpu_agent_config.svh"

class cpu_agent extends uvm_agent;
    //Register with the UVM Factory
    `uvm_component_utils(cpu_agent)

    //Configuration Object
    cpu_agent_config m_cpu_agent_config;

    //Components
    cpu_driver m_cpu_driver;
    cpu_monitor m_cpu_monitor;
    uvm_analysis_port #(cpu_mon_bus_seq_item) ap;
    uvm_sequencer #(cpu_drv_bus_seq_item) m_sequencer;

    //Constructor
    function new(string name="cpu_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    //Build Phase: build the monitor (and sequencer+driver if config object is set accordingly)
    function void build_phase(uvm_phase phase);
        m_cpu_monitor = cpu_monitor::type_id::create("m_cpu_monitor", this);

        if(m_cpu_agent_config == null) begin
            if(!uvm_config_db #(cpu_agent_config)::get(this, "", "m_cpu_agent_config", m_cpu_agent_config)) `uvm_fatal(get_type_name(), "cpu_agent_config not found in uvm_config_db")
        end
        if(m_cpu_agent_config.active == UVM_ACTIVE) begin
            m_cpu_driver = cpu_driver::type_id::create("m_cpu_driver", this);
            m_sequencer = uvm_sequencer #(cpu_drv_bus_seq_item)::type_id::create("m_sequencer", this);
        end
    endfunction: build_phase

    //Connect Phase: assign handle to monitor's analysis port and set virtual if handle
    function void connect_phase(uvm_phase phase);
        ap = m_cpu_monitor.ap;
        m_cpu_monitor.m_cpu_if = m_cpu_agent_config.m_cpu_if;

        if(m_cpu_agent_config.active == UVM_ACTIVE) begin
            m_cpu_driver.seq_item_port.connect(m_sequencer.seq_item_export);
            m_cpu_driver.m_cpu_if = m_cpu_agent_config.m_cpu_if;
        end
    endfunction
endclass: cpu_agent

