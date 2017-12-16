.code16

.global _bootstart

# 16bits-real mode
# seg:offset e.g 0x07c0:0x0000 -> seg<<4 + offset = 0x7c00
.equ	BOOTSEG, 0X07C0
.equ    initset, 0x9000
.equ    demoseg, 0x1000


.text

ljmp $BOOTSEG, $_bootstart

_bootstart:
# Get cursor position
	mov	$0x03,		%ah
	int	$0x10

	mov	$BOOTSEG,	%ax
	mov	%ax,		%es
	mov	$_string,	%bp
	mov	$0x1301,	%ax #显示中断设置
	mov	$0x000b,	%bx #显示属性设置
    mov $strLen,    %cx
	int	$0x10

_load_demo:
    xor %dx,        %dx
    mov $0x0002,    %cx
    mov $demoseg,   %ax
    mov %ax,        %es
    mov $0x0200,    %bx
    mov $0x02,      %ah
    mov $4,         %al
    int $0x13
    jnc demo_load_ok
    jmp _load_demo

demo_load_ok:
    # Jump to the demo program
    mov $demoseg,   %ax
    mov %ax,        %ds

    ljmp $0x1020, $0


_string:
	.ascii "Hello zos"
    .byte 13,10

strLen = . - _string

.= 510

signature:
	.word 0xaa55
