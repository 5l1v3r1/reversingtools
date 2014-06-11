#!/bin/sh
nasm -f elf32 -o shl.o shl.asm && ld -s -m elf_i386 -o shl shl.o
for i in $(objdump -d shl | tail -n +8 | cut -f2);do echo -n '\\x'$i;done
