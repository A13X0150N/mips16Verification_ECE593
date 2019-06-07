
`include "alu_intf.sv"

module top;

    alu_intf intf();
    alu alu(.a(intf.a), .b(intf.b), .cmd(intf.cmd), .r(intf.result));
    test t(intf);

endmodule : top