LD = ld -T
AS = as --32
OBJCOPY = objcopy -O binary -j .text

all:a.img

.PHONY=all clean bochs-run qemu-run

boot.o: boot.s
	$(AS)  boot.s -o boot.o

boot.bin: boot.o linking-script.ld
	$(LD) linking-script.ld boot.o -o boot.bin
	$(OBJCOPY)  boot.bin

setup.o: setup.s
	$(AS)  setup.s -o setup.o


setup.bin: setup.o linking-script.ld
	$(LD) linking-script.ld setup.o -o setup.bin
	$(OBJCOPY)  setup.bin

sys.o: sys.s
	$(AS)  sys.s -o sys.o

sys.bin: sys.o linking-script.ld
	$(LD) linking-script.ld sys.o -o sys.bin
	$(OBJCOPY)  sys.bin
	


a.img: boot.bin setup.bin sys.bin
	dd if=boot.bin of=a.img bs=512 count=1
	dd if=setup.bin of=a.img bs=512 count=4 seek=1
	dd if=sys.bin of=a.img bs=512 count=1 seek=5
	@echo "a.img build OK..."


bochs-run: a.img
	bochs

qemu-run: a.img
	qemu-system-i386 -boot a -fda a.img

clean:
	rm -rf ./*.o *.bin *.img
