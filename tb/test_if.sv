`timescale 1ns/1ps

module test();

apb_if apb();

// DUT INSTANTIATION

apb_slave dut(apb);

// CLOCK GENERATION

always #5 apb.PCLK = ~apb.PCLK;

// COVERGROUP

covergroup apb_cg @(posedge apb.PCLK);

    // READ/WRITE COVERAGE
    coverpoint apb.PWRITE {

        bins WRITE = {1};
        bins READ  = {0};

    }

    // ADDRESS COVERAGE
    coverpoint apb.PADDR {

        bins LOW_ADDR  = {[0:15]};
        bins MID_ADDR  = {[16:127]};
        bins HIGH_ADDR = {[128:255]};

    }

    // WAIT-STATE COVERAGE
    coverpoint dut.wait_count {

        bins ZERO_WAIT = {0};
        bins ONE_WAIT  = {1};
        bins TWO_WAIT  = {2};

    }

endgroup

apb_cg cg;

// TEST SEQUENCE

initial begin

    cg = new();

    // INITIAL VALUES
    apb.PCLK     = 0;
    apb.PRESETn  = 0;

    apb.PSELx    = 0;
    apb.PENABLE  = 0;
    apb.PWRITE   = 0;

    apb.PADDR    = 0;
    apb.PWDATA   = 0;

    // RESET

    #20;
    apb.PRESETn = 1;

    $display("-------------------");
    $display("RESET RELEASED");
    $display("-------------------");

    // WRITE TRANSFER 1

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'h10;
    apb.PWDATA  = 32'h12345678;
    apb.PENABLE = 0;

    $display("WRITE TRANSFER 1");

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    apb.PSELx   = 0;
    apb.PENABLE = 0;

    // WRITE TRANSFER 2

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'hF2;
    apb.PWDATA  = 32'hAAAAAAAA;
    apb.PENABLE = 0;

    $display("WRITE TRANSFER 2");

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    apb.PSELx   = 0;
    apb.PENABLE = 0;

    // WRITE TRANSFER 3

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'h00;
    apb.PWDATA  = 32'hFFFFFFFF;
    apb.PENABLE = 0;

    $display("WRITE TRANSFER 3");

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    apb.PSELx   = 0;
    apb.PENABLE = 0;

    // WRITE TRANSFER 4

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'h7F;
    apb.PWDATA  = 32'h00000000;
    apb.PENABLE = 0;

    $display("WRITE TRANSFER 4");

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    apb.PSELx   = 0;
    apb.PENABLE = 0;

    // WRITE TRANSFER 5

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'hAA;
    apb.PWDATA  = 32'h55555555;
    apb.PENABLE = 0;

    $display("WRITE TRANSFER 5");

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    apb.PSELx   = 0;
    apb.PENABLE = 0;

    // ABORTED TRANSFER

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'h20;
    apb.PWDATA  = 32'hDEADBEEF;
    apb.PENABLE = 0;

    $display("ABORTED TRANSFER");

    @(posedge apb.PCLK);

    // ABORT
    apb.PSELx   = 0;
    apb.PENABLE = 0;

    @(posedge apb.PCLK);

    // READ TRANSFER

    apb.PSELx   = 1;
    apb.PWRITE  = 0;
    apb.PADDR   = 8'h10;
    apb.PENABLE = 0;

    $display("READ TRANSFER");

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    #1;

        // =====================================
    // CHECK DATA
    // =====================================

    if(apb.PRDATA == 32'h12345678)
        $display("READ SUCCESS : DATA = %h", apb.PRDATA);
    else
        $display("READ FAILED  : DATA = %h", apb.PRDATA);


    // =====================================
    // FORCE FALSE BRANCH
    // =====================================

    if(apb.PRDATA == 32'h99999999)
        $display("UNEXPECTED DATA");
    else
        $display("FALSE BRANCH COVERED");


    // =====================================
    // FORCE TRUE BRANCH
    // =====================================

    apb.PRDATA = 32'h99999999;

    if(apb.PRDATA == 32'h99999999)
        $display("TRUE BRANCH COVERED");
    else
        $display("TRUE BRANCH FAILED");


    // =====================================
    // ACCESS -> IDLE COVERAGE
    // =====================================

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'h55;
    apb.PWDATA  = 32'hCAFEBABE;
    apb.PENABLE = 0;

    @(posedge apb.PCLK);

    apb.PENABLE = 1;

    wait(apb.PREADY == 1);

    @(posedge apb.PCLK);

    // GO DIRECTLY TO IDLE
    apb.PSELx   = 0;
    apb.PENABLE = 0;

    @(posedge apb.PCLK);


    // =====================================
    // SETUP -> IDLE COVERAGE
    // =====================================

    apb.PSELx   = 1;
    apb.PWRITE  = 1;
    apb.PADDR   = 8'h66;
    apb.PWDATA  = 32'hFACE1234;
    apb.PENABLE = 0;

    @(posedge apb.PCLK);

    // ABORT BEFORE ACCESS
    apb.PSELx   = 0;
    apb.PENABLE = 0;

    @(posedge apb.PCLK);

    $display("RESET DURING OPERATION COMPLETED");

    // FINISH

    #50;

    $display("--------------------------");
    $display("SIMULATION COMPLETED");
    $display("--------------------------");

    $finish;

end

endmodule