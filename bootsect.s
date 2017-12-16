.code16

.global _bootstart

.equ	BOOTSEG, 0X70C0

# 16bits-real mode
# seg:offset e.g 0x7c0:0x0000 -> seg<<4 + offset = 0x7c00

ljmp $BOOTSEG, $_bootstart

_bootstart:
	jmp _bootstart

.= 510

signature:
	.word 0xaa55
