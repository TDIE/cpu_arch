# TCL file to run simulation in Questa
# Author: Tom Diederen, Sept. 2023
# https://github.com/TDIE/cpu_arch

# Start sim
vsim -voptargs=+acc top_tb

#Add Clock
add wave -position end  sim:/top_tb/clk

#Add other waves plus dividers
add wave -divider Input
add wave -position end  sim:/top_tb/reset
add wave -position end  sim:/top_tb/data_in

#Add testbench outputs
#add wave -divider TDO_Ctrl
#add wave -position end  sim:/top_tb/tdo_instr_addr
#add wave -position end  sim:/top_tb/tdo_instruction
#add wave -divider TDO_Datapath
#add wave -position end  sim:/top_tb/tdo_op_select
#add wave -position end  sim:/top_tb/tdo_bus_D
#add wave -position end  sim:/top_tb/tdo_zero
#add wave -position end  sim:/top_tb/dut0/dp_top0/zero
#add wave -position end  sim:/top_tb/dut0/dp_top0/eu0/zero
#add wave -position end  sim:/top_tb/dut0/dp_top0/eu0/arithm/zero

add wave -divider PC_Out
add wave -position end  sim:/top_tb/dut0/ctrl_top0/pc0/instr_addr

add wave -divider Instruction
add wave -position end  sim:/top_tb/dut0/ctrl_top0/imem0/instruction

add wave -divider Reg_File_Input
add wave -position end  sim:/top_tb/dut0/dp_top0/rf_reg0/D

add wave -divider Reg_File_Output
add wave -position end  sim:/top_tb/dut0/dp_top0/rf_reg0/reg_outputs

add wave -divider Datapath_In
add wave -position end  sim:/top_tb/dut0/dp_top0/constant_in

add wave -divider Mux_B_Out
add wave -position end sim:/top_tb/dut0/dp_top0/MB_EU_B

add wave -divider EU_Out
add wave -position end  sim:/top_tb/dut0/dp_top0/EU_out

add wave -divider Mux_D_Out
add wave -position end sim:/top_tb/dut0/dp_top0/bus_D


add wave -divider Ctrl_Word
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/RW
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/rsB
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/rsA
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/rd
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/PL
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/op_select
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/MW
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/MD
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/MB
add wave -position end  sim:/top_tb/dut0/ctrl_top0/idec0/JB

add wave -divider Output
add wave -position end  sim:/top_tb/address_out
add wave -position end  sim:/top_tb/data_out

#Run sim + zoom full setting on wave screen
run -all
wave zoom full


