
`include "alu_intf.sv"
`timescale 1ps/1ps

module top;

    alu_intf intf();
    hazard_detection_unit hd(
                                .decoding_op_src1(intf.reg1),
                                .decoding_op_src2(intf.reg2),
                                .ex_op_dest(intf.ex),
                                .mem_op_dest(intf.mem),
                                .wb_op_dest(intf.wb),
                                .pipeline_stall_(intf.stall));
    test hd_test(intf);

endmodule : top