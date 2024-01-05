//Configuration Object for the cpu agent: configuration options are used by the test during the build phase
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"

class cpu_agent_config extends uvm_object;
    //Register with UVM Factory
    `uvm_object_utils(cpu_agent_config)

    //Virtual interface (cpu if handle)
    virtual cpu_if m_cpu_if;

    //Configuration
    uvm_active_passive_enum active = UVM_ACTIVE;

    //Constructor
    function new(string name="cpu_agent_config");
        super.new(name);
    endfunction

endclass: cpu_agent_config
