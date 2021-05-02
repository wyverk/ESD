onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider UUT
add wave -noupdate /servo_controller_tb/UUT/clk
add wave -noupdate /servo_controller_tb/UUT/reset_n
add wave -noupdate /servo_controller_tb/UUT/write
add wave -noupdate /servo_controller_tb/UUT/address
add wave -noupdate /servo_controller_tb/UUT/writedata
add wave -noupdate /servo_controller_tb/UUT/out_wave_export
add wave -noupdate /servo_controller_tb/UUT/irq
add wave -noupdate /servo_controller_tb/UUT/current_state
add wave -noupdate /servo_controller_tb/UUT/next_state
add wave -noupdate /servo_controller_tb/UUT/reg
add wave -noupdate /servo_controller_tb/UUT/maxAngleCount
add wave -noupdate /servo_controller_tb/UUT/minAngleCount
add wave -noupdate /servo_controller_tb/UUT/currCount
add wave -noupdate /servo_controller_tb/UUT/angleCount
add wave -noupdate /servo_controller_tb/UUT/out_wave
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
WaveRestoreZoom {0 ps} {63 ns}
