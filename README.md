# AMBA APB Master-Slave Protocol Project

## Overview

This project implements and verifies an AMBA APB (Advanced Peripheral Bus) Master-Slave subsystem using SystemVerilog.

The project includes:
- APB Master RTL
- APB Slave RTL
- FSM-based protocol implementation
- Wait-state handling using PREADY
- Assertions (SVA)
- Functional Coverage
- APB Interface
- RTL integration and waveform debugging

---

## Features

### APB Master
- Generates APB write/read transactions
- FSM-based protocol sequencing
- Handles SETUP and ACCESS phases

### APB Slave
- Supports read and write operations
- Wait-state insertion using PREADY
- FSM-controlled transfer handling

### Verification
- Functional Coverage
- Assertion Coverage
- FSM Coverage
- Branch Coverage
- Waveform Verification

### SystemVerilog Concepts Used
- FSM Design
- Interfaces
- Assertions
- Covergroups
- Wait-State Handling
- RTL Verification

---

## FSM States

### Master FSM
- IDLE
- SETUP
- ACCESS

### Slave FSM
- IDLE
- SETUP
- ACCESS

---

## APB Transfer Flow

### SETUP Phase
- PSELx = 1
- PENABLE = 0

### ACCESS Phase
- PENABLE = 1

Transfer completes when:
- PREADY = 1

---

## Functional Coverage

Implemented coverage includes:
- Read/Write transactions
- Address ranges
- Wait-state behavior

Coverage Results:
- Functional Coverage = 100%
- Assertion Coverage = 100%
- FSM Coverage = 100%

---

## Project Structure

```text
apb-master-slave-systemverilog/

├── rtl/
│   ├── apb_if.sv
│   ├── apb_master.sv
│   └── apb_slave.sv
│
├── tb/
│   ├── test_if.sv
│   └── top.sv
│
├── sim/
│   ├── run.do
│   └── wave.do
│
├── docs/
│   ├── waveform.png
│   ├── coverage_report.png
│   └── notes.txt
│
├── README.md
└── .gitignore
```

---

## Simulation Commands

### Compile

```tcl
vlog +cover rtl/apb_if.sv
vlog +cover rtl/apb_master.sv
vlog +cover rtl/apb_slave.sv
vlog +cover tb/test_if.sv
```

### Simulate

```tcl
vsim -coverage test
```

### Run Full Automation

```tcl
do sim/run.do
```

---

## Tools Used

- SystemVerilog
- QuestaSim

---

## Learning Outcomes

- AMBA APB Protocol
- Master-Slave Communication
- Wait-State Handling
- Assertions (SVA)
- Functional Coverage
- Interfaces
- Coverage Closure
- Waveform Debugging

---

## Author

Kuncham Koteswar  
Electronics and Communication Engineering  
Focused on VLSI Design and Verification