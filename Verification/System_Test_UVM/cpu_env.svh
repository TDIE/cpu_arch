//UVM environment. Depending on its config object it contains the cpu_agent, scoreboard, coverage collector, and/or register model.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "cpu_env_config.svh"
// `include "cpu_agent.svh"
`include "scoreboard.svh"
//`include "coverage_collector.svh"

class cpu_env extends uvm_env;
    //Register with the UVM Factory.
    `uvm_component_utils(cpu_env)

    //Configuration Object
    cpu_env_config m_cpu_env_config;
    
    //Components
    cpu_agent m_cpu_agent;
    scoreboard m_scoreboard;
    //coverage_collector m_coverage_collector;
    //register_model m_reg_model

    //Constructor
    function new(string name="cpu_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    //Build Phase
    function void build_phase(uvm_phase phase);
        //Get handle to environment config object
        if(!uvm_config_db #(cpu_env_config)::get(this, "", "cpu_env_config", m_cpu_env_config)) `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration cpu_env_config from uvm_config_db. Is it set()?")
        
        //Store agent config in uvm_config_db
        uvm_config_db #(cpu_agent_config)::set(this, "m_cpu_agent*", "m_cpu_agent_config", m_cpu_env_config.m_cpu_agent_config);

        //Create agent
        m_cpu_agent = cpu_agent::type_id::create("m_cpu_agent", this);

        //Depending on config object value: create scoreboard and coverage collector
        if(m_cpu_env_config.has_scoreboard) begin
            m_scoreboard = scoreboard::type_id::create("m_scoreboard", this);
        end
        // if(m_cpu_env_config.has_functional_coverage) begin
        //     m_coverage_collector = coverage_collector::type_id::create("m_coverage_collector", this);
        // end
        // if(m_cpu_env_config.has_reg_model) begin
        //     m_reg_model - register_model::typde_id::create("m_reg_model", this);
        // end
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(m_cpu_env_config.has_scoreboard) begin
            m_cpu_agent.ap.connect(m_scoreboard.scoreboard_analysis_imp);
        end
        // else if (m_cpu_env_config.has_functional_coverage) begin
        //     m_cpu_agent.ap.connect(m_coverage_collector.cov_col_analysis_imp);
        // end
    endfunction: connect_phase
endclass: cpu_env
