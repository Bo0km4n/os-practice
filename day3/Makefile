# Makefile

GCC = i386-elf-gcc
LD = i386-elf-ld

nasmhead.bin: nasmhead.asm
	nasm -o nasmhead.bin nasmhead.asm

nasmfunc.o: nasmfunc.asm
	nasm -f elf32 -o nasmfunc.o nasmfunc.asm

bootpack.o: bootpack.c
	$(GCC) -c -m32 -o bootpack.o bootpack.c

bootpack.bin: bootpack.o nasmfunc.o
	$(LD) -e HariMain -o bootpack.bin -t os.ls bootpack.o nasmfunc.o

os.sys: nasmhead.bin bootpack.bin
	cat nasmhead.bin bootpack.bin > os.sys

ipl.bin: ipl.asm
	nasm -o ipl.bin ipl.asm

os.img: ipl.bin os.sys
	mformat -f 1440 -C -B ipl.bin -i os.img ::
	mcopy -i os.img os.sys ::

run: os.img
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.sys
	rm -f *.img

debug: 
	qemu-system-i386 -m 32 -localtime -vga std -fda os.img -gdb tcp::10000 -S &
