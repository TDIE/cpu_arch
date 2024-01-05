# TCL file to run simulation in Questa
# Author: Tom Diederen, Sept. 2023
# https://github.com/TDIE/cpu_arch

# Start sim
vsim -voptargs=+acc i_mem_tb

#Add waves
add wave -position end  sim:/i_mem_tb/instr_address 
add wave -position end  sim:/i_mem_tb/instruction

#Run sim + zoom full setting on wave screen
run -all
wave zoom full