
`include "alu_intf.sv"
`timescale 1ps/1ps

module top;

    alu_intf intf();
    alu alu(.a(intf.a), .b(intf.b), .cmd(intf.cmd), .r(intf.result));
    test alu_test(intf);

endmodule : top