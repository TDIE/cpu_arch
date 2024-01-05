//The coverage collector tracks which instructions have been observed and which registers have been used.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "cpu_mon_bus_seq_item.svh"

class coverage_collector; //extends uvm_subscriber #(cpu_mon_bus_seq_item);
	//Register with UVM Factory
	`uvm_component_utils(coverage_collector)  
    
    cpu_mon_bus_seq_item seq_item;
    uvm_analysis_imp #(cpu_mon_bus_seq_item, coverage_collector) cov_col_analysis_imp;  
    
    // covergroup cpu_ops_covergroup;
    //     all_ops : coverpoint seq_item.instruction[15:9] {
    //         bins MOVA   = {7'b000_0000};
    //         bins INC    = {7'b000_0001};
    //         bins ADD    = {7'b000_0010};
    //         bins SUB    = {7'b000_0101};
    //         bins DEC    = {7'b000_0110};
    //         bins AND    = {7'b000_1000};
    //         bins OR     = {7'b000_1001};
    //         bins XOR    = {7'b000_1010};
    //         bins NOT    = {7'b000_1011};
    //         bins MOVB   = {7'b000_1100};
    //         bins SHR    = {7'b000_1101};
    //         bins SHL    = {7'b000_1110};
    //         bins LD     = {7'b001_0000};
    //         bins ST     = {7'b010_0000};
    //         bins ADI    = {7'b100_0010};
    //         bins LDI    = {7'b100_1100};
    //         bins BRZ    = {7'b110_0000};
    //         bins JMP    = {7'b111_0000};          
    //     }
    //     rd      : coverpoint seq_item.instruction[8:6];
    //     rsA     : coverpoint seq_item.instruction[5:3];
    //     rsB     : coverpoint seq_item.instruction[2:0];
    // endgroup //cpu_ops_covergroup

    //Constructor
	// function new(string name = "coverage_collector", uvm_component parent = null);
    //     super.new(name, parent);
    //     // cpu_ops_covergroup = new();
    // endfunction: new

    // //Write function is called by the analysis port of the monitor
    // virtual function void write(cpu_mon_bus_seq_item t);
    //     $cast(seq_item, t.clone());
    //     cpu_ops_covergroup.sample();
    // endfunction: write
endclass:coverage_collector
