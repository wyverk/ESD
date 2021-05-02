onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider UUT
add wave -noupdate /filter_tb/UUT/clk
add wave -noupdate /filter_tb/UUT/reset_n
add wave -noupdate /filter_tb/UUT/reset_edge
add wave -noupdate /filter_tb/UUT/address
add wave -noupdate /filter_tb/UUT/write
add wave -noupdate -radix decimal /filter_tb/UUT/writedata
add wave -noupdate -radix decimal /filter_tb/UUT/readdata
add wave -noupdate /filter_tb/UUT/RAM
add wave -noupdate -radix decimal /filter_tb/UUT/coefs
add wave -noupdate -radix decimal -childformat {{/filter_tb/UUT/reg_data(15) -radix decimal} {/filter_tb/UUT/reg_data(14) -radix decimal} {/filter_tb/UUT/reg_data(13) -radix decimal} {/filter_tb/UUT/reg_data(12) -radix decimal} {/filter_tb/UUT/reg_data(11) -radix decimal} {/filter_tb/UUT/reg_data(10) -radix decimal} {/filter_tb/UUT/reg_data(9) -radix decimal} {/filter_tb/UUT/reg_data(8) -radix decimal} {/filter_tb/UUT/reg_data(7) -radix decimal} {/filter_tb/UUT/reg_data(6) -radix decimal} {/filter_tb/UUT/reg_data(5) -radix decimal} {/filter_tb/UUT/reg_data(4) -radix decimal} {/filter_tb/UUT/reg_data(3) -radix decimal} {/filter_tb/UUT/reg_data(2) -radix decimal} {/filter_tb/UUT/reg_data(1) -radix decimal} {/filter_tb/UUT/reg_data(0) -radix decimal}} -subitemconfig {/filter_tb/UUT/reg_data(15) {-radix decimal} /filter_tb/UUT/reg_data(14) {-radix decimal} /filter_tb/UUT/reg_data(13) {-radix decimal} /filter_tb/UUT/reg_data(12) {-radix decimal} /filter_tb/UUT/reg_data(11) {-radix decimal} /filter_tb/UUT/reg_data(10) {-radix decimal} /filter_tb/UUT/reg_data(9) {-radix decimal} /filter_tb/UUT/reg_data(8) {-radix decimal} /filter_tb/UUT/reg_data(7) {-radix decimal} /filter_tb/UUT/reg_data(6) {-radix decimal} /filter_tb/UUT/reg_data(5) {-radix decimal} /filter_tb/UUT/reg_data(4) {-radix decimal} /filter_tb/UUT/reg_data(3) {-radix decimal} /filter_tb/UUT/reg_data(2) {-radix decimal} /filter_tb/UUT/reg_data(1) {-radix decimal} /filter_tb/UUT/reg_data(0) {-radix decimal}} /filter_tb/UUT/reg_data
add wave -noupdate -divider {New Divider}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {63000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 256
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {9330158 ps} {9727042 ps}
