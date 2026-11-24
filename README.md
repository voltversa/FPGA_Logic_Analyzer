# FPGA Logic Analyzer

An educational **8-channel digital logic analyzer** developed in **VHDL** with **AMD Vivado 2026.1**. The current design captures a fixed-length sequence of input samples into RAM and supports synchronous readback. It has been exercised with behavioral simulations in Vivado XSim.

> **Project status:** RTL integration and dynamic-pattern capture have been simulated. This is **not yet** a trigger-based, UART-connected or hardware-verified logic analyzer. The README describes the source code that actually exists.

## Current configuration

| Property | Value |
| --- | --- |
| System clock | 100 MHz |
| Sampling rate | 1 MHz (clock-enable pulse every 100 clock cycles) |
| Digital channels | 8 |
| Capture depth | 1,024 samples |
| Sample width | 8 bits |
| Address width | 10 bits, addresses 0–1023 |
| Nominal capture window | 1.024 ms |
| Data storage | 1,024 × 8-bit inferred-RAM-style VHDL array |
| Target part in Vivado project | XC7A35T-1CPG236 (Artix-7; Basys 3 target) |
| Tools used | Vivado 2026.1 / XSim |

The values above are build-time constants in **rtl/analyzer_pkg.vhd**, not run-time settings. Actual FPGA block-RAM inference, timing closure and board operation have **not** been confirmed.

## What is implemented

1. **Clock enable — rtl/clk_en.vhd:** derives a one-system-clock-wide enable pulse at 1 MHz from the 100 MHz input clock.
2. **Digital sampler — rtl/digital_sampling.vhd:** captures the eight input bits on a rising system-clock edge when sampling is enabled; supports synchronous reset.
3. **Capture controller — rtl/capture_controller.vhd:** a three-state FSM (**IDLE → CAP → DONE**) that advances the write address on valid samples, finishes after address 1023 and asserts **cap_done**.
4. **Storage — rtl/BRAM.vhd:** a parameterized memory array with synchronous, independently enabled write and read ports.
5. **Integration — rtl/top.vhd:** connects the clock enable, sampler, capture controller and storage. A registered **sample_valid** delays the sampling enable to line up the sampled data with the RAM write.
6. **Shared constants — rtl/analyzer_pkg.vhd:** defines clock, sample frequency, data width, memory depth and address width.

The current **start** input initiates capture directly. There is **no** trigger detector, circular pre-trigger buffer, UART interface, host application or physical probe frontend yet.

## How it works



Capture starts when the controller sees **start**. The controller stores a sequence of **1,024 qualified samples** and then holds **cap_done** high in the DONE state until reset. RAM readback uses **rd_en** and **rd_addr** and has a synchronous read latency.

## Repository layout

~~~text
FPGA_Logic_Analyzer/
├── FPGA_Logic_Analyzer.xpr        # Vivado 2026.1 project
├── rtl/                           # Actual synthesizable VHDL sources
│   ├── analyzer_pkg.vhd
│   ├── clk_en.vhd
│   ├── digital_sampling.vhd
│   ├── BRAM.vhd
│   ├── capture_controller.vhd
│   └── top.vhd
├── tb/                            # Original VHDL testbenches
│   ├── clk_en_tb.vhd
│   ├── digital_sampler_tb.vhd
│   ├── BRAM_tb.vhd
│   ├── cap_controller_tb.vhd
│   └── top_tb.vhd
├── docs/
│   ├── ARCHITECTURE.md
│   └── ROADMAP.md
└── .gitignore
~~~


## Simulation and verification

The primary integration test is **tb/top_tb.vhd**. It generates a 100 MHz clock, applies reset and start, injects changing 8-bit input patterns at 10 us intervals, waits for **cap_done** (with a 2 ms timeout), and reads selected RAM locations.

| Readback address | Expected data |
| ---: | :--- |
| 0 | 0xAA |
| 5 | 0xAA |
| 11 | 0x55 |
| 24 | 0xF0 |
| 40 | 0x0F |

The test also asserts that capture completes and **cap_done** remains high during readback. Individual testbenches are included for the clock enable, digital sampler, BRAM and capture controller. These older unit tests have been preserved as written; this repository cleanup does not claim they were newly rerun or improved.

## Hardware status and limitations

- The **.xpr** targets an Artix-7 device associated with the **Basys 3**, but there is **no XDC pin/clock constraint file** or proven board deployment in this repository.
- The RAM has been **functionally simulated**; implementation as physical block RAM and timing performance must be confirmed with synthesis and implementation reports.
- External digital inputs currently enter the sampler directly. Real probe wiring must account for the board's 3.3 V I/O limits, input protection and asynchronous sampling/metastability.
- The current capture is **single-shot and immediate-start**, not circular and not trigger-driven. Capture depth in the controller is presently tied to 1,024 samples.
- No UART protocol decoding, host waveform viewer, or hardware capture result is included.

## Next development steps

1. Implement and unit-test an edge-trigger detector.
2. Add an **ARMED** state and integrate triggering without losing the trigger sample; later add optional pre-trigger capture.
3. Improve verification, including boundary cases and an automated regression.
4. Check BRAM inference and timing through Vivado synthesis/implementation.
5. Add Basys 3 constraints and safe 3.3 V probe connections for hardware testing.
6. Add a communication interface and PC waveform visualization after the capture core is reliable.

See **docs/ARCHITECTURE.md** for the signal flow and **docs/ROADMAP.md** for progress.

## Development workflow

This repository tracks only useful source/project files; generated Vivado runs, simulator waveforms and other temporary outputs are excluded by **.gitignore**.
