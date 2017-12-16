all:Image

.PHONY=all clean bochs-run qemu-run

bootsect.o: bootsect.s
	as --32 bootsect.s -o bootsect.o

bootsect: bootsect.o ld-bootsect.ld
	ld -T ld-bootsect.ld bootsect.o -o bootsect
	objcopy -O binary -j .text bootsect

setup.o: setup.s
	as --32 setup.s -o setup.o


setup: setup.o ld-bootsect.ld
	ld -T ld-bootsect.ld setup.o -o setup
	objcopy -O binary -j .text setup

Image: bootsect setup
	dd if=bootsect of=Image bs=512 count=1
	dd if=setup of=Image bs=512 count=4 seek=1
	@echo "Image build OK..."


bochs-run: Image
	bochs

qemu-run: Image
	qemu-system-i386 -boot a -fda Image

clean:
	rm -rf ./*.o bootsect setup Image
