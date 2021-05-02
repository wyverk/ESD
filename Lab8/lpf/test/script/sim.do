vlib work
vcom -93 -quiet -work work ../../rising_edge_synchronizer.vhd
vcom -93 -quiet -work work ../../generic_reg.vhd
vcom -93 -quiet -work work ../../multiply.vhd
vcom -93 -quiet -work work ../../lpf.vhd
vcom -93 -quiet -work work ../src/lpf_tb.vhd
vsim -voptargs=+acc -msgmode both lpf_tb
do wave.do
run -all
