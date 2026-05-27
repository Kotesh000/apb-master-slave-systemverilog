quietly WaveActivateNextPane {} 0

add wave -divider "APB INTERFACE SIGNALS"

add wave sim:/test/apb/PCLK
add wave sim:/test/apb/PRESETn

add wave sim:/test/apb/PSELx
add wave sim:/test/apb/PENABLE
add wave sim:/test/apb/PWRITE

add wave sim:/test/apb/PADDR
add wave sim:/test/apb/PWDATA

add wave sim:/test/apb/PRDATA
add wave sim:/test/apb/PREADY


add wave -divider "SLAVE FSM"

add wave sim:/test/dut/state
add wave sim:/test/dut/next_state
add wave sim:/test/dut/wait_count


wave zoom full