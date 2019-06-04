
`include "hd_pkg.sv"

interface hd_intf;

	logic [`REG_WIDTH -1 : 0] reg1;
	logic [`REG_WIDTH -1 : 0] reg2;

	logic [`REG_WIDTH -1 : 0] ex;
	logic [`REG_WIDTH -1 : 0] mem;
	logic [`REG_WIDTH -1 : 0] wb;

    logic stall;

	modport test (output reg1, reg2, ex, mem, wb, input stall);

endinterface //hd_intf


typedef virtual hd_intf.test hd_intf_f;