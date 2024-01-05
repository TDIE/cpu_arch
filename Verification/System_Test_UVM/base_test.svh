//UVM test. This is the only test for this project but it could be extended in the future. Hence the name, base test.
//Contains the environement and its configuration object
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "cpu_bus_seq.svh"

class base_test extends uvm_test;
    //Register with the UVM Factory
    `uvm_component_utils(base_test)

    //Environment + config
    cpu_env m_cpu_env;
    cpu_env_config m_cpu_env_config;
    cpu_agent_config m_cpu_agent_config;
    //register_model m_register_model;
    
    //Constructor
	function new(string name="my_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

    //Configure cpu_env
    function void configure_cpu_environment(cpu_env_config cfg);
        cfg.has_scoreboard = 1;
        cfg.has_functional_coverage = 0;
        cfg.has_reg_model = 0;
        //`uvm_info(get_type_name(), $sformatf("Configured: m_cpu_env_config"), UVM_LOW)
    endfunction: configure_cpu_environment

    //Configure cpu_agent
    function void configure_cpu_agent(cpu_agent_config cfg);
        cfg.active = UVM_ACTIVE;
        //`uvm_info(get_type_name(), $sformatf("Configured: m_cpu_agent_config"), UVM_LOW)
    endfunction: configure_cpu_agent

    //Build Phase
    function void build_phase(uvm_phase phase);
        m_cpu_env_config = cpu_env_config::type_id::create("m_cpu_env_config");
        m_cpu_agent_config = cpu_agent_config::type_id::create("m_cpu_agent_config");
        configure_cpu_environment(m_cpu_env_config);
        configure_cpu_agent(m_cpu_agent_config);

        //Get cpu_if handle
        if(!uvm_config_db #(virtual cpu_if)::get(this, "", "cpu_if", m_cpu_agent_config.m_cpu_if)) `uvm_fatal(get_type_name(), "cpu_if not found in uvm_config_db")

        //Set agent config object of environment config and put env config in uvm_config_db
        m_cpu_env_config.m_cpu_agent_config = m_cpu_agent_config;
        uvm_config_db #(cpu_env_config)::set(this, "*", "cpu_env_config", m_cpu_env_config);

        //Create environment
        m_cpu_env = cpu_env::type_id::create("m_cpu_env", this);
    endfunction: build_phase

    //Run Phase
    task run_phase(uvm_phase phase);
        cpu_bus_seq m_cpu_bus_seq = cpu_bus_seq::type_id::create("m_cpu_bus_seq");
        // `uvm_info(get_type_name(), "base_test: run phase started", UVM_LOW)
        phase.raise_objection(this, "Starting sequence: cpu_bus_seq.");
        m_cpu_bus_seq.start(m_cpu_env.m_cpu_agent.m_sequencer);
        phase.drop_objection(this, "Completed sequence: cpu_bus_seq.");
    endtask: run_phase

endclass: base_test