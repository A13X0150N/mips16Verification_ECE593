

	`define ALU_WIDTH 16
	`define ALU_CMD_WIDTH 3

	`define ASSERT_COND(condition, message) \
			assert (condition) \
			else   $error(message)

