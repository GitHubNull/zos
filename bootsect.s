.code16

.global _bootstart

# 16bits-real mode
# seg:offset e.g 0x07c0:0x0000 -> seg<<4 + offset = 0x7c00
.equ	BOOTSEG, 0X07C0

.text

ljmp $BOOTSEG, $_bootstart

_bootstart:
# Get cursor position
	mov	$0x03,		%ah
	int	$0x10

	mov	$BOOTSEG,	%ax
	mov	%ax,		%es
	mov	$_string,	%bp
	mov	$0x1301,	%ax
	mov	$0x0007,	%bx
    mov $strLen,    %cx
	int	$0x10
loop:	
	jmp loop

_string:
	.ascii "Hello zos"
    .byte 13,10

strLen = . - _string

.= 510

signature:
	.word 0xaa55
