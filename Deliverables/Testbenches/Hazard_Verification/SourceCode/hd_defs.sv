
	`define REG_WIDTH 3
	`define NUM_TEST_TXN 1000

	`define ASSERT_COND(condition, message) \
			assert (condition) \
			else   $error(message)