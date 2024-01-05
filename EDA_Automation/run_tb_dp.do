# TCL file to run simulation in Questa
# Author: Tom Diederen, Sept. 2023
# https://github.com/TDIE/cpu_arch

# Start sim
vsim -voptargs=+acc dp_top_tb

#Add Clock
add wave -position end  sim:/dp_top_tb/clk

#Add other waves plus dividers
add wave -divider Input_Write
add wave -position end  sim:/dp_top_tb/regWrite
add wave -position end  sim:/dp_top_tb/rd
add wave -position end  sim:/dp_top_tb/data_in
add wave -position end  sim:/dp_top_tb/constant_in

add wave -divider Input_Read
add wave -position end  sim:/dp_top_tb/rsA
add wave -position end  sim:/dp_top_tb/rsB

add wave -divider Muxes
add wave -position end  sim:/dp_top_tb/MB
add wave -position end  sim:/dp_top_tb/MD

add wave -divider Output
add wave -position end  sim:/dp_top_tb/dut/EU_out
add wave -position end  sim:/dp_top_tb/dut/bus_D

add wave -divider Op
add wave -position end  sim:/dp_top_tb/op_select

add wave -divider Reg_File_Output
add wave -position end  sim:/dp_top_tb/dut/rf_reg0/reg_outputs

#Run sim + zoom full setting on wave screen
run -all
wave zoom full
