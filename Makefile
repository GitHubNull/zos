all:Image

.PHONY=all clean run

bootsect.o:
	as --32 bootsect.s -o bootsect.o

bootsect: bootsect.o ld-bootsect.ld
	ld -T ld-bootsect.ld bootsect.o -o bootsect
	objcopy -O binary -j .text bootsect

run: bootsect
	bochs

clean:
	rm -rf ./*.o bootsect
