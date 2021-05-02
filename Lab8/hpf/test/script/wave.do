onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider UUT
add wave -noupdate /lpf_tb/clk
add wave -noupdate /lpf_tb/reset_n
add wave -noupdate /lpf_tb/filter_en
add wave -noupdate /lpf_tb/stop
add wave -noupdate /lpf_tb/audioSampleArray
add wave -noupdate /lpf_tb/UUT/clk
add wave -noupdate /lpf_tb/UUT/reset_n
add wave -noupdate /lpf_tb/UUT/filter_en
add wave -noupdate -radix decimal /lpf_tb/data_in
add wave -noupdate -radix decimal /lpf_tb/data_out
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix decimal /lpf_tb/UUT/data_in
add wave -noupdate -radix decimal /lpf_tb/UUT/data_out
add wave -noupdate -radix decimal /lpf_tb/UUT/temp_sum
add wave -noupdate /lpf_tb/UUT/reg_data
add wave -noupdate /lpf_tb/UUT/after_mul
add wave -noupdate /lpf_tb/UUT/after_mul_32
add wave -noupdate /lpf_tb/UUT/reset_edge
add wave -noupdate /lpf_tb/UUT/filter_edge
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {1660150 ps} {1723150 ps}
