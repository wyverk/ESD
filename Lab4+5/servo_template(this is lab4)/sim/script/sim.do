vlib work
vcom -93 -quiet -work work ../../src/servo_controller.vhd
vcom -93 -quiet -work work ../src/servo_controller_tb.vhd
vsim -voptargs=+acc -msgmode both servo_controller_tb
do wave.do
run -all
