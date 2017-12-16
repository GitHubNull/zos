all:Image

.PHONY=all clean bochs-run qemu-run

bootsect.o: bootsect.s
	as --32 bootsect.s -o bootsect.o

bootsect: bootsect.o ld-bootsect.ld
	ld -T ld-bootsect.ld bootsect.o -o bootsect
	objcopy -O binary -j .text bootsect

demo.o: demo.s
	as --32 demo.s -o demo.o


demo: demo.o ld-bootsect.ld
	ld -T ld-bootsect.ld demo.o -o demo
	objcopy -O binary -j .text demo

Image: bootsect demo
	dd if=bootsect of=Image bs=512 count=1
	dd if=demo of=Image bs=512 count=4 seek=1
	@echo "Image build OK..."


bochs-run: Image
	bochs

qemu-run: Image
	qemu-system-i386 -boot a -fda Image

clean:
	rm -rf ./*.o bootsect
