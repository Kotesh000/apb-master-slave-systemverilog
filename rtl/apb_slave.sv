module apb_slave(apb_if apb);

logic [31:0] mem [0:255];

logic [1:0] wait_count;

typedef enum logic [1:0]{
    IDLE,
    SETUP,
    ACCESS
}state_t;

state_t state, next_state;

always_ff @(posedge apb.PCLK or negedge apb.PRESETn) begin
    if(!apb.PRESETn)
        state <= IDLE;
    else
        state <= next_state; 
end

always_comb begin
    
    next_state = state;

    case(state)

    IDLE: begin
        if(apb.PSELx)
            next_state = SETUP; 
    end

    SETUP: begin
        next_state = ACCESS;
    end

    ACCESS: begin
        if (apb.PREADY)begin
            if(apb.PSELx)
                next_state = SETUP;
            else
                next_state = IDLE; 
            end
        end
    endcase
end

always_ff @(posedge apb.PCLK or negedge apb.PRESETn) begin
    if(!apb.PRESETn) begin
        wait_count <= 0;
        apb.PREADY <= 0;
        apb.PRDATA<=32'b0;
end

else begin

    // WAIT-STATE LOGIC
    if(state == ACCESS) begin

        if(wait_count < 2) begin
            wait_count <= wait_count + 1;
            apb.PREADY <= 0;
        end

        else begin
            apb.PREADY <= 1;
            wait_count <= 0;

            // WRITE TRANSFER
            if(apb.PWRITE)
                mem[apb.PADDR] <= apb.PWDATA;

            // READ TRANSFER
            else
                apb.PRDATA <= mem[apb.PADDR];
        end

    end

    else begin
        wait_count <= 0;
        apb.PREADY <= 0;
    end

end

end

// ASSERTIONS

property penable_access;

    @(posedge apb.PCLK)
    apb.PENABLE |-> apb.PSELx;

endproperty

property penable_psel;

    @(posedge apb.PCLK)
    apb.PENABLE |-> apb.PSELx;

endproperty

assert property(penable_psel)
else
    $error("PENABLE ASSERTED WITHOUT PSELx");

endmodule
