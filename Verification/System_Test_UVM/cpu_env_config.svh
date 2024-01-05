//Configuration Object for the UVM environment: configuration options are used by the test during the build phase
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "cpu_agent_config.svh"
//`include "register_model.svh"

class cpu_env_config extends uvm_object;
    `uvm_object_utils(cpu_env_config)

    //Virtual interface (cpu if handle)
    virtual cpu_if cpu_if;

    //Agent Config Object
    cpu_agent_config m_cpu_agent_config;

    //Register Model
    //register_model m_reg_model;
    //Config Options
    bit has_scoreboard = 1;
    bit has_functional_coverage = 0;
    bit has_reg_model = 0;

    //Constructor
    function new(string name="cpu_env_config");
        super.new(name);
    endfunction

endclass: cpu_env_config
