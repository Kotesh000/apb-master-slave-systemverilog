vlib work

vlog +cover rtl/apb_if.sv
vlog +cover rtl/apb_master.sv
vlog +cover rtl/apb_slave.sv
vlog +cover tb/test_if.sv

vsim -coverage -voptargs="+acc" test

do sim/wave.do

run -all

coverage save sim/apb_cov.ucdb

coverage report -details