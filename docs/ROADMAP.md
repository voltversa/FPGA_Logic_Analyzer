# Roadmap

## Phase 0 — Project skeleton

- [x] Define repository architecture
- [x] Define module boundaries
- [x] Create empty RTL, testbench, host, script, and constraint placeholders
- [ ] Select the first FPGA board

## Phase 1 — Sampling frontend

- [ ] Add shared configuration types and generics
- [ ] Implement registered probe input
- [ ] Implement sample clock-enable divider
- [ ] Add self-checking frontend tests

Exit criterion: deterministic samples at divide-by-1 and divided rates in simulation.

## Phase 2 — Trigger engine

- [ ] Implement rising-edge and falling-edge triggers
- [ ] Implement high-level and low-level triggers
- [ ] Add per-channel mask and match value
- [ ] Test all trigger modes and disabled channels

Exit criterion: exactly one trigger pulse for every valid programmed condition.

## Phase 3 — Capture memory

- [ ] Infer a parameterizable dual-port BRAM
- [ ] Implement circular write addressing
- [ ] Track trigger index and chronological read address
- [ ] Test wraparound at multiple depths

Exit criterion: pre-trigger history and post-trigger samples read back in time order.

## Phase 4 — Capture controller

- [ ] Implement idle, armed, post-trigger, complete, and readout states
- [ ] Add configurable pre-trigger ratio
- [ ] Add abort and re-arm handling
- [ ] Run an integrated capture test

Exit criterion: repeatable triggered captures with no overwritten completed data.

## Phase 5 — Host link

- [ ] Implement UART RX/TX
- [ ] Implement the framed command decoder
- [ ] Implement Python configuration and capture utility
- [ ] Export captured data as VCD

Exit criterion: a simulated host command produces a valid capture file viewable in GTKWave.

## Phase 6 — Hardware demonstration

- [ ] Add board-specific clock and pin constraints
- [ ] Verify I/O voltage and input protection
- [ ] Capture a known PWM, UART, and SPI transaction
- [ ] Measure maximum stable sample rate
- [ ] Add photos, waveforms, utilization, and timing results

Exit criterion: reproducible hardware demo with measured—not estimated—limits.

## Stretch goals

- [ ] Run-length encoding
- [ ] Pattern and multi-stage triggers
- [ ] External trigger input/output
- [ ] PulseView/sigrok-compatible export
- [ ] USB FIFO or Ethernet transport

