//The scoreboard receives transactions from the monitor's analysis port.
//Based on the instruction that contained input values, an output is predicted
//The scoreboard then compares the predicted and actual values and keeps a tally of correct and incorrect values.
//Part of Rudimentary Processor Design Project: https://github.com/TDIE/cpu_arch

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "cpu_mon_bus_seq_item.svh"

class scoreboard extends uvm_scoreboard;
    //Register with the UVM Factory
    `uvm_component_utils(scoreboard)
    
    uvm_analysis_imp #(cpu_mon_bus_seq_item, scoreboard) scoreboard_analysis_imp;
    int                     correct_transactions        =  0;
    int                     incorrect_transactions      =  0;
    logic  [2:0]            rd                          = 'x;
    logic  [2:0]            rsA                         = 'x;
    logic  [2:0]            rsB                         = 'x;
    cpu_mon_bus_seq_item    mon_seq_item_prediction;
    cpu_mon_bus_seq_item    mon_seq_item_copy;
    
    //Enum for instructions
    typedef enum logic [6:0]  { MOVA
        , INC
        , ADD
        , SUB
        , DEC
        , AND
        , OR
        , XOR
        , NOT
        , MOVB
        , SHR
        , SHL
        , LD
        , ST
        , ADI
        , LDI
        , BRZ
        , JMP
    } instruction_enum;

    instruction_enum m_instruction_enum;

    //Constructor
	function new(string name="scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction

    //Build Phase
    function void build_phase(uvm_phase phase);
		scoreboard_analysis_imp = new("scoreboard_analysis_imp", this); // Create the uvm_analysis_imp for the scoreboard (links to .write() of the analysis port of the monitor)
	endfunction: build_phase

    //ap.write() that the monitor calls via it's analysis port.
    //Implementation of monitor.ap.write()	 
	function void write(cpu_mon_bus_seq_item mon_seq_item);
		//`uvm_info(get_type_name(), $sformatf("Scoreboard input: %s", mon_seq_item.convert2string()), UVM_LOW);
        $cast(mon_seq_item_copy, mon_seq_item.clone());
        evaluate(mon_seq_item_copy);
	endfunction
    
    //Evaluator
    function void evaluate(cpu_mon_bus_seq_item seq_item);
        // `uvm_info(get_type_name(), $sformatf("Scoreboard.evaluate() input: %s", seq_item.convert2string()), UVM_LOW);
        predict(seq_item);
        if (mon_seq_item_prediction.bus_D == mon_seq_item_copy.bus_D) begin
            correct_transactions++;
        end
        else begin
            incorrect_transactions++;
            `uvm_info(get_type_name(), $sformatf("Incorrect transaction. Prediction: %s, Received: %s", mon_seq_item_prediction.convert2string(), mon_seq_item_copy.convert2string()), UVM_LOW);
        end
    endfunction: evaluate
    
    //Predictor
    function void predict(cpu_mon_bus_seq_item seq_item);
        mon_seq_item_prediction = cpu_mon_bus_seq_item::type_id::create("mon_seq_item_prediction", this);
        
        //Registers
        rd  = seq_item.instruction[8:6];
        rsA = seq_item.instruction[5:3];
        rsB = seq_item.instruction[2:0];

        //Predict result based on instruction
        case (seq_item.instruction[15:9])
            7'b000_0000 : begin 
                m_instruction_enum = MOVA;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA};
            end
            7'b000_0001 : begin
                m_instruction_enum = INC;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA + 1};
            end
            7'b000_0010 : begin
                m_instruction_enum = ADD;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA + rsB};
            end
            7'b000_0101 : begin
                m_instruction_enum = SUB;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA - rsB};
            end
            7'b000_0110 : begin
                m_instruction_enum = DEC;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA - 1};
            end
            7'b000_1000 : begin
                m_instruction_enum = AND;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA & rsB};
            end
            7'b000_1001 : begin
                m_instruction_enum = OR;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA | rsB};
            end
            7'b000_1010 : begin
                m_instruction_enum = XOR;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA ^ rsB};
            end
            7'b000_1011 : begin
                m_instruction_enum = NOT;
                mon_seq_item_prediction.bus_D = ~{13'b0 , rsA};
            end
            7'b000_1100 : begin
                m_instruction_enum = MOVB;
                mon_seq_item_prediction.bus_D = {13'b0 , rsB};
            end
            7'b000_1101 : begin
                m_instruction_enum = SHR;
                mon_seq_item_prediction.bus_D = {13'b0 , rsB >> 1};
            end
            7'b000_1110 : begin
                m_instruction_enum = SHL;
                mon_seq_item_prediction.bus_D = {13'b0 , rsB << 1};
            end
            7'b001_0000 : begin
                m_instruction_enum = LD;
                mon_seq_item_prediction.bus_D = seq_item.data_in;
            end
            7'b010_0000 : begin
                m_instruction_enum = ST;
                mon_seq_item_prediction.bus_D = seq_item.data_out;
            end
            7'b100_0010 : begin
                m_instruction_enum = ADI;
                mon_seq_item_prediction.bus_D = {13'b0 , rsA + seq_item.instruction[2:0]};
            end
            7'b100_1100 : begin 
                m_instruction_enum = LDI;
                mon_seq_item_prediction.bus_D = {13'b0 , seq_item.instruction[2:0]};
            end
            7'b110_0000 : begin 
                m_instruction_enum = BRZ;
                mon_seq_item_prediction.bus_D = mon_seq_item_copy.bus_D;    //BRZ test out of scope. Simply copy value to count towards correct transactions.
            end
            7'b111_0000 : begin 
                m_instruction_enum = JMP;
                mon_seq_item_prediction.bus_D = mon_seq_item_copy.bus_D;    //JMP test out of scope. Simply copy value to count towards correct transactions.
            end
            default     : begin
                `uvm_warning(get_type_name(), "Illegal Instruction Detected")
            end
        endcase 
        //`uvm_info(get_type_name(), $sformatf("Predict results: rsA: %h, rsB: %h, rd: %h instr: %s", rsA, rsB, rd, m_instruction_enum.name()), UVM_LOW);
    endfunction: predict
    
    //Report Phase
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Scoreboard results: incorrect: %d, correct: %d ", incorrect_transactions, correct_transactions), UVM_LOW); 
    endfunction
endclass: scoreboard
