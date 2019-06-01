

`define alu_width 16
`define alu_cmd_width 3

`define assert_cond(condition, message) \
		assert (condition)  \
		else   $error(message); \
