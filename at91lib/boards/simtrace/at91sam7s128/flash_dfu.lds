/* ----------------------------------------------------------------------------
 *         ATMEL Microcontroller Software Support
 * ----------------------------------------------------------------------------
 * Copyright (c) 2008, Atmel Corporation
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the disclaimer below.
 *
 * Atmel's name may not be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * DISCLAIMER: THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
 * DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ----------------------------------------------------------------------------
 */

/*------------------------------------------------------------------------------
 *    Linker script for running in DFU Flash partion the AT91SAM7S256.
 *----------------------------------------------------------------------------*/

OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(entry)

MEMORY
{
    /* adjusted for DFU partition */
    sram (W!RX) : ORIGIN = 0x200028, LENGTH = (0x10000 - 0x28)
    flash (RX) : ORIGIN  = 0x104000, LENGTH = (0x20000 - 0x4000 - 0x400)
}

SECTIONS
{
    . = 0x000000000;
    .fixed 0x00104000: AT ( 0x00000000 )
    {
        . = ALIGN(4);
        _sfixed = .;
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        _efixed = .;
    } >flash

    .relocate 0x00200028: AT ( SIZEOF(.fixed) )
    {
        . = ALIGN(4);
        _srelocate = .;
        *(.vectors)
        *(.ramfunc)
        *(.data)
        . = ALIGN(4);
        _erelocate = .;
    } >sram

    .bss (NOLOAD) : {
        _szero = .;
        *(.bss)
        . = ALIGN(4);
        _ezero = .;
    } >sram
    
    _sstack = 0x210000;
}
end = .;

