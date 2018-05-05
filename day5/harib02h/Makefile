# Makefile

GCC = i386-elf-gcc
LD = i386-elf-ld
OBJ_DIR = ./obj
OBJS = bootpack.o font.o lib.o
OBJ = *.o
CSRC = *.c

obj_dir: 
	mkdir $(OBJ_DIR)

nasmhead.bin: nasmhead.asm
	nasm -o nasmhead.bin nasmhead.asm

nasmfunc.o: nasmfunc.asm
	nasm -f elf32 -o $(OBJ_DIR)/nasmfunc.o nasmfunc.asm

.c.o: 
	$(GCC) -c -fno-pic -m32 -o $(OBJ_DIR)/$@ $<

bootpack.bin: obj_dir nasmfunc.o $(OBJS)
	$(LD) -e HariMain -o bootpack.bin -T os.ls $(OBJ_DIR)/$(OBJ)

os.sys: nasmhead.bin bootpack.bin
	cat nasmhead.bin bootpack.bin > os.sys

ipl.bin: ipl.asm
	nasm -o ipl.bin ipl.asm

build: ipl.bin os.sys
	mformat -f 1440 -C -B ipl.bin -i os.img ::
	mcopy -i os.img os.sys ::
	rm -rf $(OBJ_DIR)

run: build
	qemu-system-i386 -fda os.img

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.sys
	rm -f *.img

debug: 
	qemu-system-i386 -m 32 -localtime -vga std -fda os.img -gdb tcp::10000 -S &
