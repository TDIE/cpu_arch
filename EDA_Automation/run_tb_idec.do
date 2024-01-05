# TCL file to run simulation in Questa
# Author: Tom Diederen, Sept. 2023
# https://github.com/TDIE/cpu_arch

# Start sim
vsim -voptargs=+acc instr_dec_tb

#Add waves plus dividers
add wave -divider Instruction
add wave -position end  sim:/instr_dec_tb/instr

add wave -divider Output_bits_registers
add wave -position end  sim:/instr_dec_tb/rd
add wave -position end  sim:/instr_dec_tb/rsA
add wave -position end  sim:/instr_dec_tb/rsB

add wave -divider Output_bits_Muxes
add wave -position end  sim:/instr_dec_tb/MB
add wave -position end  sim:/instr_dec_tb/MD

add wave -divider Output_bits_Reg_Mem_write
add wave -position end  sim:/instr_dec_tb/RW
add wave -position end  sim:/instr_dec_tb/MW

add wave -divider Output_bits_Op_Select
add wave -position end  sim:/instr_dec_tb/op_select

add wave -divider Output_bits_JMP/Branch
add wave -position end  sim:/instr_dec_tb/PL
add wave -position end  sim:/instr_dec_tb/JB
add wave -position end  sim:/instr_dec_tb/BC

#Run sim + zoom full in wave screen
run -all
wave zoom full


