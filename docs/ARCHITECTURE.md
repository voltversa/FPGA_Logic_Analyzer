# Implemented architecture

This document describes the **current RTL**, not a hypothetical future design.

## Data path

~~~text
                            +----------------------+
100 MHz clk --------------->| clk_en: 1 MHz enable |-----------------+
                            +----------------------+                 |
                                                                     v
fpga_pins[7:0] ----------------------------------------------> Digital_sampling
                                                                     |
                                                             sampled[7:0]
                                                                     |
                                             +-----------------------+
                                             v
                                      BRAM (1,024 x 8)
                                      synchronous read/write
                                             ^
                                    wr_en / wr_addr
                                             |
start --> capture_controller (IDLE, CAP, DONE) <--- sample_valid
                     |
                   cap_done
~~~

All modules run on the **same 100 MHz system clock**; the sampling rate is implemented using a clock-enable rather than a separate internal clock.

## Registered sample alignment

The clock-enable module asserts **en** for a clock cycle every 100 system clocks. On the next relevant rising edge, **Digital_sampling** uses en to register the current input byte. At that edge **top** also registers **sample_valid <= en**. The controller and RAM then consume that valid indication at the following rising edge, when the new sampled byte is stable. This is the one-clock valid-data alignment pipeline in **top.vhd**.

## Capture behavior

- **IDLE:** waits for **start**; clears the address counter while start is low.
- **CAP:** on a valid sample, enables RAM write at the current 10-bit address and advances the counter.
- **DONE:** no more capture writes; **cap_done** stays asserted until synchronous reset.

The current controller uses address 1023 as its terminal sample. It does not yet support a runtime capture length, ARM/trigger distinction, circular buffering, abort or automatic re-arm.

## RAM behavior

**BRAM.vhd** implements a VHDL array with synchronous clocked write and read enables. A read value is updated on a rising edge when **rd_en** is high. Simultaneous write and read to different addresses are permitted. Same-address read/write behavior should be checked against the synthesized primitive's configured collision mode before relying on it.

## Verification scope

**tb/top_tb.vhd** drives four successive patterns (**0xAA, 0x55, 0xF0, 0x0F**) and checks stored contents at addresses **0, 5, 11, 24, 40**, along with completion status. Individual unit testbenches exist, but no claim of exhaustive verification is made.

## Not implemented

Trigger detection, pre-trigger memory, host commands, UART, VCD export, dedicated input conditioning, physical pin constraints and measured FPGA timing are future work. The target in the Vivado project is **xc7a35tcpg236-1**, but no on-board validation is documented.
