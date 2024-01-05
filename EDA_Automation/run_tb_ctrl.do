# TCL file to run simulation in Questa
# Author: Tom Diederen, Sept. 2023
# https://github.com/TDIE/cpu_arch

# Start sim
vsim -voptargs=+acc ctrl_top_tb

#Add Clock
add wave -position end  sim:/ctrl_top_tb/clk

#Add Inputs
add wave -divider Inputs
add wave -position end  sim:/ctrl_top_tb/reset
add wave -position end  sim:/ctrl_top_tb/dp_eu_zero
add wave -position end  sim:/ctrl_top_tb/dp_address_out

#Add Outputs
#Program Counter Address Output
add wave -divider PC_Out
add wave -position end  sim:/ctrl_top_tb/dut/pc0/instr_addr

#Instruction: Fetch
add wave -divider Instruction
add wave -position end  sim:/ctrl_top_tb/dut/imem0/instruction

#Instruction: Decode
add wave -divider Ctrl_Word
add wave -position end  sim:/ctrl_top_tb/rd
add wave -position end  sim:/ctrl_top_tb/rsA
add wave -position end  sim:/ctrl_top_tb/rsB
add wave -position end  sim:/ctrl_top_tb/op_select
add wave -position end  sim:/ctrl_top_tb/constant_in
add wave -position end  sim:/ctrl_top_tb/MW
add wave -position end  sim:/ctrl_top_tb/MB
add wave -position end  sim:/ctrl_top_tb/MD
add wave -position end  sim:/ctrl_top_tb/RW
add wave -position end  sim:/ctrl_top_tb/dut/idec0/PL
add wave -position end  sim:/ctrl_top_tb/dut/idec0/JB

#Run sim + zoom full setting on wave screen
run -all
wave zoom full