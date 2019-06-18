
`include "hd_defs.sv"


interface hd_intf;

	logic [`REG_WIDTH -1 : 0] reg1;
	logic [`REG_WIDTH -1 : 0] reg2;

	logic [`REG_WIDTH -1 : 0] ex;
	logic [`REG_WIDTH -1 : 0] mem;
	logic [`REG_WIDTH -1 : 0] wb;

    logic stall;
endinterface //hd_intf


typedef virtual hd_intf.test hd_intf_f;