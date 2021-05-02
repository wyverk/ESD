vlib work
vcom -93 -quiet -work work ../../rising_edge_synchronizer.vhd
vcom -93 -quiet -work work ../../generic_reg.vhd
vcom -93 -quiet -work work ../../multiply.vhd
vcom -93 -quiet -work work ../../hpf.vhd
vcom -93 -quiet -work work ../src/hpf_tb.vhd
vsim -voptargs=+acc -msgmode both hpf_tb
do wave.do
run -all
