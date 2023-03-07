# COMPY-V: A simple FPGA/RISC-V hobby computer

something

## Why?

## Design

### Memory Map

0x00000000 +------------------------+--------------------------------+
           | ROM                    | IVT                            |
           |                        +--------------------------------+
0x000007FF |                        | Boot Program                   |
0x00000800 +------------------------+--------------------------------+
           | Low Memory             | Programmable IVT               |
           | (Fast)                 +--------------------------------+
           |                        | Boot Program Data              |
           |                        +--------------------------------+
           |                        | Fast Heap Memory               |
0x000????? +------------------------+--------------------------------+
           |                     RESERVED                            |
0x00100000 +------------------------+--------------------------------+
           | Internal Peripherals   | Peripheral 0                   |
           |                        | (Memory / Interrupt Control)   | 0x001000FF
    100100 |                        +--------------------------------+
           |                        | Peripheral 1                   |
           |                        | (Console UART)                 |
    100200 |                        +--------------------------------+
           |                        | Peripheral 2                   |
    100300 |                        +--------------------------------+
           |                        | Peripheral 3                   |
    100400 |                        +--------------------------------+
           |                        | Peripheral 4                   |
    100500 |                        +--------------------------------+
           |                        | Peripheral 5                   |
    100600 |                        +--------------------------------+
           |                        | Peripheral 6                   |
    100700 |                        +--------------------------------+
           |                        | Peripheral 7                   |
0x00100800 +------------------------+--------------------------------+
           | External Peripherals   | Peripheral 8                   |
    100900 |                        +--------------------------------+
           |                        | Peripheral 9                   |
    100A00 |                        +--------------------------------+
           |                        | Peripheral A                   |
    100B00 |                        +--------------------------------+
           |                        | Peripheral B                   |
    100C00 |                        +--------------------------------+
           |                        | Peripheral C                   |
    100D00 |                        +--------------------------------+
           |                        | Peripheral D                   |
    100E00 |                        +--------------------------------+
           |                        | Peripheral E                   |
    100F00 |                        +--------------------------------+
           |                        | Peripheral F                   |
0x00101000 +------------------------+--------------------------------+
           |                    (RESERVED)                           |
           |                       MMIO                              |
0x01000000 +------------------------+--------------------------------+
           | High Memory            | Stack Memory                   |
           | (Slow, External)       +--------------------------------+
           |                        | Slow Heap Memory (default)     |
0x02000000 +------------------------+--------------------------------+
           |                     RESERVED                            |
           |                  (External RAM)                         |
0xFFFFFFFF +------------------------+--------------------------------+

## Implementation

* Nexys 2
* Spartan 3E 500
* Block RAM for cache / boot ROM / lo-mem - 32-bit data bus
* Hi-mem in 16MB CellurlarRAM - 16-bit data bus
** Consider implementing 80MHz memory controller instead of 70ns SRAM mode
* Serial console is first peripheral
* Peripherals have (variable size OR fixed 256 byte size) and (up to 16
  peripherals?)
** Attached to memory bus, similar to lo-mem
* VGA output connected to PPU peripheral
* Block RAM in 16-bit banks so hardware multipliers can be used

### Block RAM allocation

The Nexys 2's XC3S500E has 20 RAM blocks, each containing 16,348 bits (plus 2048
parity bits when used in 8+ bit bus width). This works out to 512 32-bit words
per block. Blocks can be configured for any power-of-two data width up to 32
bits. However, they share some of their I/O bits with the hardware multipliers,
allowing for only 16-bit operation when the hardware multipliers are in use.

We're going to need at least two of the 18-bit hardware multipliers to build a
single 32-bit multiplier block for the RISC-V M extension. Additionally, if we
decide to support the C extension, we will need to support 16-bit aligned reads.

> Maybe I don't want to implement the C extension. It makes addressing more
> complicated.

* ROM: 2x blocks in 16-bit mode (1k-word)
* High Memory Cache: 
