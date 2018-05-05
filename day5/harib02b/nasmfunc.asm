; nasmfunc.asm
bits 32
global io_hlt
global write_mem8
global io_cli
global io_sti
global io_stihlt
global io_in8
global io_in16
global io_in32
global io_out8
global io_out16
global io_out32
global io_load_eflags
global io_store_eflags

section .text

io_hlt:
	HLT
	RET

write_mem8:
	MOV ECX, [ESP+4]
	MOV AL, [ESP+8]
	MOV [ECX], AL
	RET

io_cli: ; void io_cli(void);
	CLI
	RET

io_sti: ; void io_sti(void);
	STI
	RET

io_stihlt: ; void io_stihlt(void);
	STI
	HLT
	RET

io_in8: ; int io_in8(int port);
	MOV EDX,[ESP+4]	;port
	MOV EAX,0
	IN AL,DX
	RET

io_in16: ; int io_in16(int port);
	MOV EDX,[ESP+4]
	MOV EAX,0
	IN AX,DX
	RET

io_in32: ; int io_in32(int port);
	MOV EDX,[ESP+4]
	IN EAX,DX
	RET

io_out8:	; void io_out8(int port, int data);
	MOV EDX,[ESP+4]
	MOV AL,[ESP+8]
	OUT DX,AL
	RET

io_out16:	; void io_out16(int port, int data);
	MOV EDX,[ESP+4]
	MOV AL,[ESP+8]
	OUT DX,AX
	RET

io_out32:	; void io_out32(int port, int data);
	MOV EDX,[ESP+4]
	MOV AL,[ESP+8]
	OUT DX,EAX
	RET

io_load_eflags: ; int io_load_eflags(void);
	PUSHFD ; PUSH EFLAGSという意味
	POP EAX
	RET

io_store_eflags: ; io_store_eflags(int eflags);
	MOV EAX,[ESP+4]
	PUSH EAX
	POPFD
	RET
