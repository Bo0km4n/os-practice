MAKE = make
OBJS = helloos.asm
IMG_FILE = helloos.img
ASM = nasm
QEMU = qemu-system-i386

img:
	$(ASM) $(OBJS) -o $(IMG_FILE)
run:
	$(MAKE) img
	$(QEMU) -fda $(IMG_FILE)
	
