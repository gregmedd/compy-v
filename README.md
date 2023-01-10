# COMPY-V: A simple FPGA/RISC-V hobby computer

something

## Why?

## Design

Memory map
0x0        0x7FF                                                              0xFFFFFFFF
+---------------------------------------------------------------------------~--+
|    ROM    | Lo-Mem                                                           |
+---------------------------------------------------------------------------~--+
| IVT | ROM | Lo-Mem /                                                         |
+---------------------------------------------------------------------------~--+

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
