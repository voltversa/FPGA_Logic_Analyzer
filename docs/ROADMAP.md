# Development roadmap

Progress is based on the actual VHDL and testbenches in this repository as of **24 November 2026**.

## Completed in RTL

- [x] Shared configuration package (100 MHz, 1 MHz, 8-bit inputs, 1,024-sample memory)
- [x] Clock-enable generator
- [x] 8-channel registered digital sampler
- [x] Synchronous read/write RAM RTL
- [x] Capture-controller FSM: IDLE → CAP → DONE
- [x] Integrated top-level design
- [x] Unit-testbench source files for clock enable, sampler, RAM and controller
- [x] Behavioral integration testbench with dynamic input patterns and selected RAM-read assertions

These checkboxes indicate code exists and the integration behavior has been demonstrated in XSim; they do **not** imply completed formal verification, synthesis, or hardware deployment.

## Next: triggering

- [ ] Build an edge detector using previous/current valid samples
- [ ] Test rising-edge and falling-edge conditions
- [ ] Add an ARMED state to coordinate start and trigger
- [ ] Define whether the trigger sample is stored; verify timing explicitly
- [ ] Explore circular buffer and pre-trigger samples

## Verification and FPGA readiness

- [ ] Re-run/refine all unit testbenches and automate regression
- [ ] Exercise full memory depth, boundary transitions and changing patterns
- [ ] Synthesize and confirm inferred physical RAM resources
- [ ] Inspect timing and utilization reports
- [ ] Add board-specific clock and I/O constraints
- [ ] Validate 3.3 V digital inputs and physical connections on Basys 3
- [ ] Demonstrate a real captured digital signal

## Future communication and host tools

- [ ] UART TX/RX or another suitable link
- [ ] Host-side capture transfer
- [ ] PC waveform viewer / standard waveform export

These features are **not currently implemented**. No placeholder modules are kept just to imply they exist.
