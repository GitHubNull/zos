all:Image

.PHONY=all clean bochs-run qemu-run

bootsect.o:
	as --32 bootsect.s -o bootsect.o

bootsect: bootsect.o ld-bootsect.ld
	ld -T ld-bootsect.ld bootsect.o -o bootsect
	objcopy -O binary -j .text bootsect

bochs-run: bootsect
	bochs

qemu-run: bootsect
	qemu-system-i386 -boot a -fda bootsect


clean:
	rm -rf ./*.o bootsect
