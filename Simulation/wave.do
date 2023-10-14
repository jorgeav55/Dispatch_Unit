onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Dispatch_tb/UUT1/clk
add wave -noupdate /Dispatch_tb/UUT1/reset
add wave -noupdate /Dispatch_tb/UUT1/Instruction
add wave -noupdate /Dispatch_tb/UUT1/PC_out
add wave -noupdate /Dispatch_tb/UUT1/Tags_Table/tagout_tf
add wave -noupdate /Dispatch_tb/i
add wave -noupdate /Dispatch_tb/CDB_tag_random
add wave -noupdate -color Yellow /Dispatch_tb/CDB_tag
add wave -noupdate -color Yellow /Dispatch_tb/CDB_valid
add wave -noupdate -color Yellow /Dispatch_tb/CDB_data
add wave -noupdate -color Yellow /Dispatch_tb/CDB_branch
add wave -noupdate -color Yellow /Dispatch_tb/CDB_branch_taken
add wave -noupdate -color Cyan /Dispatch_tb/issueque_full_integer
add wave -noupdate -color Cyan /Dispatch_tb/issueque_full_ld_st
add wave -noupdate -color Cyan /Dispatch_tb/issueque_full_mul
add wave -noupdate -color Cyan /Dispatch_tb/issueque_full_div
add wave -noupdate /Dispatch_tb/rd_en
add wave -noupdate /Dispatch_tb/UUT1/branch_stall
add wave -noupdate /Dispatch_tb/UUT1/branch
add wave -noupdate /Dispatch_tb/jb_en
add wave -noupdate /Dispatch_tb/jb_address
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_opcode
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rd_tag
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rs1_tag
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rs2_tag
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rs1_data
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rs2_data
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_en_integer
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_en_ld_st
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_en_mul
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_en_div
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rs1_valid
add wave -noupdate -color Magenta /Dispatch_tb/dispatch_rs2_valid
add wave -noupdate /Dispatch_tb/UUT1/RegWrite
add wave -noupdate /Dispatch_tb/UUT1/Ins_type
add wave -noupdate /Dispatch_tb/UUT1/Branch_Logic/state
add wave -noupdate /Dispatch_tb/j
add wave -noupdate /Dispatch_tb/rand_alt
add wave -noupdate -expand /Dispatch_tb/UUT1/Reg_File/Q
add wave -noupdate -radix unsigned -childformat {{{/Dispatch_tb/UUT1/RST/write_address0[4]} -radix unsigned} {{/Dispatch_tb/UUT1/RST/write_address0[3]} -radix unsigned} {{/Dispatch_tb/UUT1/RST/write_address0[2]} -radix unsigned} {{/Dispatch_tb/UUT1/RST/write_address0[1]} -radix unsigned} {{/Dispatch_tb/UUT1/RST/write_address0[0]} -radix unsigned}} -subitemconfig {{/Dispatch_tb/UUT1/RST/write_address0[4]} {-radix unsigned} {/Dispatch_tb/UUT1/RST/write_address0[3]} {-radix unsigned} {/Dispatch_tb/UUT1/RST/write_address0[2]} {-radix unsigned} {/Dispatch_tb/UUT1/RST/write_address0[1]} {-radix unsigned} {/Dispatch_tb/UUT1/RST/write_address0[0]} {-radix unsigned}} /Dispatch_tb/UUT1/RST/write_address0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5099 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 148
configure wave -valuecolwidth 57
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {111852 ps}
