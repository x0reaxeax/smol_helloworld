# Very smol C hello world, 0 characters!

### Challenge rules:
- [x] No binary modifications  
- [x] No external libraries or code
- [x] OS is Linux (3.7 i686)
- [x] GCC compiler (gcc version 4.7.2)
- [x] This (preprocessor macros) is not allowed: `$ gcc smoll.c -D"_=int main() {puts(\"hello world\");}"`

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
(might be able to overcome this with a pair of double-quotes..)  
  
**Workaround:**
Just avoid `mov`s and `lea`s with 0s! 

```asm
_start:
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    
    inc ebx

    add al,  0x4        ; sys_write = 4
    add edx, 0xb        ; strlen = 11 (actually 10, but (int) 10 (0xa) is ASCII newline, which we can't use)
    
    mov ecx, 0x8048285  ; __FILE__ magic address (0x804826d) + offset to "helloworld!"
    int 0x80
    
    xor eax, eax
    inc eax            ; sys_exit = 1
    int 0x80
```

This with appended "helloworld!" translates to:

```c
unsigned char bytecode[] = {  
        0x31, 0xc0,
        0x31, 0xdb,
        0x31, 0xd2,

        0x43,
        0x04, 0x04,
        0x83, 0xc2, 0x0b,

        0xb9, 0x85, 0x82, 0x04, 0x08,
        0xcd, 0x80,
        
        0x31, 0xc0,
        0x40,
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

Last thing.. just create an empty source file named `test.c`  
So yea, 0 characters C "Hello World".

Great, now for the final step - compilation!
```sh
gcc -nostdlib -z execstack -e 0x804826d -x c {GARBAGE_NAME}
```

.. or just run `make`!  

```
$ ./a.out
helloworld!
```

yaaaaaaaaaaaayyyy
