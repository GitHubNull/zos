.code16

.text

.equ demoseg, 0x1020
.equ len, 0x0

show_text:
    mov $demoseg,   %ax
    mov %ax,        %es
    mov $0x03,      %ah
    xor %bh,        %bh
    int $0x10

    mov $0x000a,    %bx
    mov $0x1301,    %ax
    mov $msg_len,   %cx
    mov $msg,       %bp
    int $0x10

loop:
    jmp loop

msg:
    .byte 13, 10
    .ascii "Load floppy data into RAM sucessful..."
    .byte 13,10

msg_len = . - msg


