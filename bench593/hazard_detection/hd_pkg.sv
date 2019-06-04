
	`define REG_WIDTH 3

	`define ASSERT_COND(condition, message) \
			assert (condition) \
			else   $error(message)
