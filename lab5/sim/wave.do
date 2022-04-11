onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/test_clk
add wave -noupdate /top/intf_lab/clk
add wave -noupdate /top/intf_lab/load_en
add wave -noupdate /top/intf_lab/reset_n
add wave -noupdate /top/intf_lab/opcode
add wave -noupdate /top/intf_lab/operand_a
add wave -noupdate /top/intf_lab/operand_b
add wave -noupdate /top/intf_lab/write_pointer
add wave -noupdate /top/intf_lab/read_pointer
add wave -noupdate /top/intf_lab/instruction_word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {107104 ps}
