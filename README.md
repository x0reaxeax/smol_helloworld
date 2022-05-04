# Very smol C hello world, 11 characters!

### Challenge rules:
- [x] No binary modifications  
- [x] No external libraries or code
- [x] OS is Linux (3.7 i686)
- [x] GCC compiler (gcc version 4.7.2)
- [x] This is not allowed: `$ gcc smoll.c -D"_=int main() {puts(\"hello world\");}"`

### Approach:
(Ab)Use GCC's `__FILE__` preprocessor macro, which holds source filename string.  
**Example:**
```c
/* file - 'test.c' */
  ...
  printf("%s\n", __FILE__);
  ...
```
Outputs:
```
test.c
```
We could either settle for 27 characters with:
```c
int main(){puts(__FILE__);}
```

...or we could load our source filename with opcodes!  
**There are 2 things that complicate this:**
1. Newline character (0x0a) cuts the filename
2. We can't use nullbyte basically for the exact same reason

**Workaround:**
Just avoid `mov`s and `lea`s! 

```asm
_start:
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    
    inc ebx

    add eax, 4          ; sys_write = 4
    add edx, 11         ; strlen = 11 (actually 10, but (int) 10 (0xa) is ASCII newline, which we can't use)
    
    mov ecx, 0x80480ec  ; __FILE__ magic address (0x80480d8) + offset to "helloworld!"
    int 0x80
```

This with appended "helloworld!" translates to:

```c
unsigned char bytecode[] = {  
        0x31, 0xc0,
        0x31, 0xdb,
        0x31, 0xd2,

        0x43,
        0x83, 0xc0, 0x04,
        0x83, 0xc2, 0x0b,

        0xb9, 0xec, 0x80, 0x04, 0x08,
        0xcd, 0x80,

        0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21
};
```

Now we have to rename our c source file with these bytes:
```c
/* craft.c */

#include <stdio.h>

int main(void) {
  unsigned char bytecode[] { ... };
  rename("test.c", bytecode);
  return 0;
}
```

One more thing..
We need to expose `__FILE__` to the compiler. GCC supports the implicit int rule, so we can also omit data type declaration! And the shortest way I could come up with to do this is:
```c
_=__FILE__;
```

That's **11** characters! If someone knows of a shorter way, please please please hit me up!

Great, now for the final step - compilation!
```sh
gcc -nostdlib -z execstack -e 0x80480d8 -x c "{GARBAGE_NAME}"
```

.. or just run `make`!  

```
$ ./a.out
helloworld!Segmentation fault
```

yaaaaaaaaaaaayyyy
