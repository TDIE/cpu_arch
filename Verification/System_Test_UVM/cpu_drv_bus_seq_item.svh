//This file defines the cpu bus sequence item that is sent to the driver.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"

class cpu_drv_bus_seq_item extends uvm_sequence_item;
    //Register with the UVM Factory
    `uvm_object_utils(cpu_drv_bus_seq_item)

    rand logic[15:0]    data_in;
    logic               reset;

    //Constructor
    function new(string name="cpu_drv_bus_seq_item");
		super.new(name);
	endfunction

    //Convenience Methods
    function void do_copy(uvm_object rhs);
        cpu_drv_bus_seq_item rhs_;

        if(!$cast(rhs_, rhs)) begin
            uvm_report_error("do_copy:", "Cast Failed");
            return;
        end
        super.do_copy(rhs);
        data_in = rhs_.data_in;
        reset = rhs_.reset;
    endfunction: do_copy

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        cpu_drv_bus_seq_item rhs_;

        if(!$cast(rhs_, rhs)) begin
            return 0;
        end
        return((super.do_compare(rhs, comparer)) &&
            (data_in == rhs_.data_in ) &&
            (reset == rhs_.reset));
    endfunction: do_compare

    function string convert2string();
        string s;
        s = super.convert2string();
        $sformat(s, "%s\n data_in: \t%0h\n reset: \t%0h\n", s, data_in, reset);
        return s;
    endfunction: convert2string

    function void do_print(uvm_printer printer);
        printer.m_string = convert2string();
    endfunction: do_print

    function void do_record(uvm_recorder recorder);
        super.do_record(recorder);
        `uvm_record_field("data_in", data_in)
        `uvm_record_field("reset", reset)
    endfunction: do_record
endclass: cpu_drv_bus_seq_item
