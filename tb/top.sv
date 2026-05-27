`timescale 1ns/1ps

module top();

apb_if apb();

// CLOCK GENERATION

always #5 apb.PCLK = ~apb.PCLK;

// RESET

initial begin

    apb.PCLK = 0;
    apb.PRESETn = 0;

    #20;
    apb.PRESETn = 1;

end

// APB MASTER INSTANTIATION

apb_master master(apb);

// APB SLAVE INSTANTIATION

apb_slave slave(apb);

// SIMULATION CONTROL

initial begin

    #300;

    $display("--------------------------");
    $display("SIMULATION COMPLETED");
    $display("--------------------------");

    $finish;

end

endmodule