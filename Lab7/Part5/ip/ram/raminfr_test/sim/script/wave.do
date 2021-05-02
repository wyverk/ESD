onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider UUT
add wave -noupdate /template_tb/clk
add wave -noupdate /template_tb/reset_n
add wave -noupdate /template_tb/write_n
add wave -noupdate -radix hexadecimal /template_tb/address
add wave -noupdate -radix hexadecimal /template_tb/writedata
add wave -noupdate -radix hexadecimal -childformat {{/template_tb/readdata(31) -radix hexadecimal} {/template_tb/readdata(30) -radix hexadecimal} {/template_tb/readdata(29) -radix hexadecimal} {/template_tb/readdata(28) -radix hexadecimal} {/template_tb/readdata(27) -radix hexadecimal} {/template_tb/readdata(26) -radix hexadecimal} {/template_tb/readdata(25) -radix hexadecimal} {/template_tb/readdata(24) -radix hexadecimal} {/template_tb/readdata(23) -radix hexadecimal} {/template_tb/readdata(22) -radix hexadecimal} {/template_tb/readdata(21) -radix hexadecimal} {/template_tb/readdata(20) -radix hexadecimal} {/template_tb/readdata(19) -radix hexadecimal} {/template_tb/readdata(18) -radix hexadecimal} {/template_tb/readdata(17) -radix hexadecimal} {/template_tb/readdata(16) -radix hexadecimal} {/template_tb/readdata(15) -radix hexadecimal} {/template_tb/readdata(14) -radix hexadecimal} {/template_tb/readdata(13) -radix hexadecimal} {/template_tb/readdata(12) -radix hexadecimal} {/template_tb/readdata(11) -radix hexadecimal} {/template_tb/readdata(10) -radix hexadecimal} {/template_tb/readdata(9) -radix hexadecimal} {/template_tb/readdata(8) -radix hexadecimal} {/template_tb/readdata(7) -radix hexadecimal} {/template_tb/readdata(6) -radix hexadecimal} {/template_tb/readdata(5) -radix hexadecimal} {/template_tb/readdata(4) -radix hexadecimal} {/template_tb/readdata(3) -radix hexadecimal} {/template_tb/readdata(2) -radix hexadecimal} {/template_tb/readdata(1) -radix hexadecimal} {/template_tb/readdata(0) -radix hexadecimal}} -subitemconfig {/template_tb/readdata(31) {-height 15 -radix hexadecimal} /template_tb/readdata(30) {-height 15 -radix hexadecimal} /template_tb/readdata(29) {-height 15 -radix hexadecimal} /template_tb/readdata(28) {-height 15 -radix hexadecimal} /template_tb/readdata(27) {-height 15 -radix hexadecimal} /template_tb/readdata(26) {-height 15 -radix hexadecimal} /template_tb/readdata(25) {-height 15 -radix hexadecimal} /template_tb/readdata(24) {-height 15 -radix hexadecimal} /template_tb/readdata(23) {-height 15 -radix hexadecimal} /template_tb/readdata(22) {-height 15 -radix hexadecimal} /template_tb/readdata(21) {-height 15 -radix hexadecimal} /template_tb/readdata(20) {-height 15 -radix hexadecimal} /template_tb/readdata(19) {-height 15 -radix hexadecimal} /template_tb/readdata(18) {-height 15 -radix hexadecimal} /template_tb/readdata(17) {-height 15 -radix hexadecimal} /template_tb/readdata(16) {-height 15 -radix hexadecimal} /template_tb/readdata(15) {-height 15 -radix hexadecimal} /template_tb/readdata(14) {-height 15 -radix hexadecimal} /template_tb/readdata(13) {-height 15 -radix hexadecimal} /template_tb/readdata(12) {-height 15 -radix hexadecimal} /template_tb/readdata(11) {-height 15 -radix hexadecimal} /template_tb/readdata(10) {-height 15 -radix hexadecimal} /template_tb/readdata(9) {-height 15 -radix hexadecimal} /template_tb/readdata(8) {-height 15 -radix hexadecimal} /template_tb/readdata(7) {-height 15 -radix hexadecimal} /template_tb/readdata(6) {-height 15 -radix hexadecimal} /template_tb/readdata(5) {-height 15 -radix hexadecimal} /template_tb/readdata(4) {-height 15 -radix hexadecimal} /template_tb/readdata(3) {-height 15 -radix hexadecimal} /template_tb/readdata(2) {-height 15 -radix hexadecimal} /template_tb/readdata(1) {-height 15 -radix hexadecimal} /template_tb/readdata(0) {-height 15 -radix hexadecimal}} /template_tb/readdata
add wave -noupdate -radix hexadecimal /template_tb/stimulus/mask
add wave -noupdate /template_tb/stop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81894940 ps} 0}
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
WaveRestoreZoom {163650600 ps} {163902600 ps}
