module apb_master(apb_if apb);

typedef enum logic [1:0] {
    IDLE,
    SETUP,
    ACCESS
} state_t;

state_t state, next_state;

// STATE REGISTER

always_ff @(posedge apb.PCLK or negedge apb.PRESETn) begin

    if(!apb.PRESETn)
        state <= IDLE;

    else
        state <= next_state;

end

// NEXT STATE LOGIC

always_comb begin

    next_state = state;

    case(state)

        IDLE:
            next_state = SETUP;

        SETUP:
            next_state = ACCESS;

        ACCESS: begin

            if(apb.PREADY)
                next_state = IDLE;

            else
                next_state = ACCESS;

        end

    endcase

end

// OUTPUT LOGIC

always_ff @(posedge apb.PCLK or negedge apb.PRESETn) begin

    if(!apb.PRESETn) begin

        apb.PSELx   <= 0;
        apb.PENABLE <= 0;
        apb.PWRITE  <= 0;

        apb.PADDR   <= 0;
        apb.PWDATA  <= 0;

    end

    else begin

        case(state)

            IDLE: begin

                apb.PSELx   <= 0;
                apb.PENABLE <= 0;

            end


            SETUP: begin

                apb.PSELx   <= 1;
                apb.PENABLE <= 0;

                apb.PWRITE  <= 1;
                apb.PADDR   <= 8'h20;
                apb.PWDATA  <= 32'hDEADBEEF;

            end


            ACCESS: begin

                apb.PENABLE <= 1;

            end

        endcase

    end

end

endmodule