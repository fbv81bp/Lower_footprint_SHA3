# Lower footprint SHA3
Decreased the footprint of "pe.vhd" of the SHA3 low footprint core originally published Keccak Team from 983 LUTs to 404LUTs for Xilinx's Artix devices under Vivado 2020.1.

The coprocessor's "pe.vhd" contained all the 64 shifter versions of the RHO function, multiplexed in a single giant structure. I replaced this by 5 cascaded shifters that shift exponentially growing amounts on the data conditionally based on the bits of the values to be shifted. If you need to shift like 35 bits on a data, you shift 32+2+1 bits independently...

This resulted in significant reduction of the core's footprint.
