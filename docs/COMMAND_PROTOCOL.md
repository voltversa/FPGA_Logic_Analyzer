# Proposed Command Protocol

This protocol is a design target and is not implemented yet.

## Frame

| Field | Size | Description |
|---|---:|---|
| Start | 1 byte | `0xA5` |
| Command | 1 byte | Operation identifier |
| Length | 2 bytes | Little-endian payload length |
| Payload | Variable | Command parameters or returned data |
| CRC | 1 byte | CRC-8 over command, length, and payload |

## Planned commands

| Command | Direction | Purpose |
|---|---|---|
| `GET_INFO` | Host → FPGA | Read version and configured limits |
| `SET_CONFIG` | Host → FPGA | Set divider, trigger, mask, and pre-trigger ratio |
| `ARM` | Host → FPGA | Begin a new capture |
| `ABORT` | Host → FPGA | Cancel an active capture |
| `GET_STATUS` | Host → FPGA | Read idle, armed, triggered, or complete state |
| `READ_CAPTURE` | Host → FPGA | Stream metadata and captured samples |

The exact numeric command values will be frozen when the decoder and host tests are added.

