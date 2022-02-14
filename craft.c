#include <stdio.h>

int main(void) {
    unsigned char bytecode[] = {  
                    0x31, 0xc0,
                    0x31, 0xdb,
                    0x31, 0xd2,
        
                    0x40,
                    0x83, 0xf8, 0x04,
                    0x7c, 0xfa,
                              
                    0x42,
                    0x83, 0xfa, 0x0b,
                    0x7c, 0xfa,
                              
                    0xb9, 0xf1, 0x80, 0x04, 0x08,
                    0xcd, 0x80,
                              
                    0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21
    };

    printf("Bytecode size: %zu\n", sizeof(bytecode));
    rename("test.c", bytecode);
    return 0;
}
