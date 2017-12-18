.code16

.text

.equ setupseg,	0x9020
.equ initseg,	0x9000
show_text:
    mov $setupseg,  %ax
    mov %ax,        %es
    mov $0x03,      %ah
    xor %bh,        %bh
    int $0x10

    mov $0x000a,    %bx
    mov $0x1301,    %ax
    mov $msg_len,   %cx
    mov $msg,       %bp
    int $0x10

#loop:
#    jmp loop


_setup_start:
	mov $initseg,	%ax
	mov %ax,	%ds
	mov $0x03,	%ah
	xor %bh,	%bh
	int $10
	mov %dx,	%ds:2

# VGA Display mode
	mov $0x12,	%ah
	mov $0x10,	%bl
	int $0x10

	mov %ax,	%ds:8
	mov %bx,	%ds:10
	mov %cx,	%ds:12

# Harddisk parameter table
	xor %ax,	%ax
	mov %ax,	%ds
	lds %ds:4*0x41, %si
	mov $initseg,	%ax
	mov $0x0090,	%di
	mov $0x10,	%cx
	rep movsb

	xor %ax,	%ax
	mov %ax,	%ds
	lds %ds:4*0x46,	%si
	mov $initseg,	%ax
	mov $0x0090,	%di
	mov $0x10,	%cx
	rep movsb

# CHeck second harddisk parameter
	mov $0x1500,	%ax
	mov $0x81,	%dl
	int $0x13
	jc  no_disk1
	cmp $3,		%ah
	je  is_disk1

no_disk1:
	mov $initseg,	%ax
	mov %ax,	%es
	mov $0x0090,	%di
	mov $0x10,	%cx
	xor %ax,	%ax
	rep movsb

is_disk1:
	# prepare to ener protect mode
	cli 


	# move system image to 0x0000:0x0000
	xor %ax,	%ax
do_move:
	mov %ax,	%es
	add $0x1000,	%ax
	cmp $0x9000,	%ax
	jz  end_move
	mov %ax,	%ds
	xor %di,	%di
	xor %si,	%si
	mov $0x8000,	%cx
	rep movsw
	jmp do_move

# load GDT & IDT
end_move:
	mov $setupseg,	%ax
	mov %ax,	%ds
	lgdt	gdt_48
	lidt	idt_48	

enable_a20:
	in  $0x92,	%al
	or  $0x02,	%al
	out %al,	$0x92

# CR0	Protect ENable = 1
	mov	%cr0,	%eax
	bts	$0,	%eax
	mov	%eax,	%cr0
	
# Jump to protect mode long jump
	.equ	sel_cs0,	0x0008
	mov	$0x10,	%ax
	mov	%ax,	%ds
	mov	%ax,	%es
	mov	%ax,	%fs
	mov	%ax,	%gs
	
	ljmp	$sel_cs0,	$0

# GDT Descriptpr
gdt_48:
	.word	0x800
	.word	512 + gdt,	0x9
	

# Global Descriptpr Table
gdt:
	.word	0,	0,	0,	0
	
	# COde segment
	.word	0X07ff	# Base
	.word	0x0000	# Limit
	.word	0x9a00	# 1 00 1 1010 0000 0000
	.word	0x00c0	# 0000 0000 1 1 0 0 0000

	# Data segment	
	.word	0X07ff	# Base
	.word	0x0000	# Limit
	.word	0x9200	# 1 00 1 0010 0000 0000
	.word	0x00c0	# 0000 0000 1 1 0 0 0000

idt_48:
	.word	0
	.word	0, 0
	
idt:
	

	
# 8259A programing

# IDT load
	

msg:
    .byte 13, 10
    .ascii "Load floppy data into RAM sucessful..."
    .byte 13,10

msg_len = . - msg


