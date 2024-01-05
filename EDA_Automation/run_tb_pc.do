# TCL file to run simulation in Questa
# Author: Tom Diederen, Sept. 2023
# https://github.com/TDIE/cpu_arch

# Start sim
vsim -voptargs=+acc -fsmdebug pc_tb

#Add Clock
add wave -position end  sim:/pc_tb/clk

#State
add wave -divider State
add wave -position end  sim:/pc_tb/pc0/state


#Add other waves plus dividers
add wave -divider Input_Ctr
add wave -position end  sim:/pc_tb/reset 
add wave -position end  sim:/pc_tb/PL
add wave -position end  sim:/pc_tb/JB

add wave -divider Input_Aux
add wave -position end  sim:/pc_tb/offset 
add wave -position end  sim:/pc_tb/zero
add wave -position end  sim:/pc_tb/address_bus_A

add wave -divider Output
add wave -position end  sim:/pc_tb/instr_addr

#Run sim + zoom full setting on wave screen
run -all
wave zoom full