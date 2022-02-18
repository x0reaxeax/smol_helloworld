all:
	mkdir out
	gcc -o out/craft craft.c
	cp test.c out/
	cd out && ./craft
	rm out/craft
	cd out && gcc -o bin -nostdlib -z execstack -e 0x80480d8 -x c *	

clean:
	rm -rf out/
