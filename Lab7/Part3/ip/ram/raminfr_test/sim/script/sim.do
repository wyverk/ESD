vlib work
vcom -93 -quiet -work work ../../../raminfr_be.vhd
vcom -93 -quiet -work work ../src/template_tb.vhd
vsim -voptargs=+acc -msgmode both template_tb
do wave.do
run -all
