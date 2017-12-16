.code16

.global _bootstart

# 16bits-real mode
# seg:offset e.g 0x07c0:0x0000 -> seg<<4 + offset = 0x7c00
.equ    setupLen,   0x04
.equ	BOOTSEG,    0X07C0
.equ    sysseg,     0x1000
.equ    initset,    0x9000
.equ    setupseg,   0x9000

.text

ljmp        $BOOTSEG, $_bootstart

_bootstart:
# clear 
#    mov     %dl, (boot_drive)
#
#    mov     %cs,        %ax
#    mov     %ax,        %ds
#    mov     %ax,        %ss
#    mov     $signature, %sp
#
#    mov     $0xb800,    %bx
#    mov     %bx,        %es
#
#    call    claer_screen
# Get cursor position
	mov	    $0x03,		%ah
	int	    $0x10

	mov	    $BOOTSEG,	%ax
	mov	    %ax,		%es
	mov	    $_string,	%bp
	mov	    $0x1301,	%ax #显示中断设置
	mov	    $0x000b,	%bx #显示属性设置
    mov     $strLen,    %cx
	int	    $0x10

_load_setup:
    xor     %dx,        %dx
    mov     $0x0002,    %cx
    mov     $setupseg,   %ax
    mov     %ax,        %es
    mov     $0x0200,    %bx
    mov     $0x02,      %ah
    mov     $4,         %al
    int     $0x13
    jnc     setup_load_ok
    jmp     _load_setup

setup_load_ok:
    # Jump to the setup program
    mov     $setupseg,   %ax
    mov     %ax,        %ds

    ljmp $9020, $0

claer_screen:
    push    %ax;
    push    %bx;
    push    %cx;
    push    %dx;

    xor     %ax,        %ax
    mov     $2000,       %cx
    xor     %di,        %di

_cls_loop:
    mov     %ax,        %es:(%di)
    add     $2,         %di
    dec     %cx
    test    %cx,        %cx
    jnz     _cls_loop

    pop     %dx
    pop     %cx
    pop     %bx
    pop     %ax
_cls_end:
    ret

_string:
	.ascii "Hello zos"
#    .byte 13,10

strLen = . - _string

boot_drive:
    .byte  0

.= 510

signature:
	.word 0xaa55
