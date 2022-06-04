all:
	mkdir out
	gcc -o out/craft craft.c
	cp test.c out/
	cd out && ./craft
	rm out/craft
	cd out && gcc -nostdlib -z execstack -e 0x804826d -x c *	

clean:
	rm -rf out/
