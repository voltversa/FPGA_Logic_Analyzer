# FPGA Logic Analyzer

A simulation-first, board-neutral logic analyzer implemented in VHDL-2008.

> Status: repository skeleton and design plan only. No RTL or hardware performance claims have been implemented yet.

## Planned first release

- Parameterizable input width, starting with 8 channels
- Adjustable sample-rate divider
- Rising-edge, falling-edge, high-level, and low-level triggers
- BRAM-backed circular capture buffer
- Configurable pre-trigger and post-trigger capture
- UART command and data link
- Python host utility with VCD export for waveform viewing
- Self-checking GHDL testbenches before board bring-up

## Repository layout

```text
rtl/          Synthesizable VHDL
tb/           Self-checking VHDL testbenches
host/         Python control and waveform-export tools
constraints/  Board-specific constraints, added only after a board is selected
docs/         Architecture, protocol, and implementation roadmap
scripts/      Local simulation helpers
```

## Design documents

- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Command protocol](docs/COMMAND_PROTOCOL.md)

## Proposed defaults

| Parameter | Initial value |
|---|---:|
| Channels | 8 |
| Capture depth | 4,096 samples |
| HDL standard | VHDL-2008 |
| Host link | UART, 115,200 baud initially |
| Simulation | GHDL |

The achievable sample rate and physical pinout will be documented only after the target FPGA board is selected and measured.

