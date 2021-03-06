_start:
    xor eax, eax        ; syscall no
    xor ebx, ebx        ; fdno
    xor edx, edx        ; slen

    inc ebx             ; stdout

    add al,  4          ; sys_write = 4
    add edx, 11         ; strlen = 11

    mov ecx, 0x8048285  ; "helloworld!"
    int 0x80
    
    xor eax, eax
    inc eax
    int 0x80

    db 'h'
    db 'e'
    db 'l'
    db 'l'
    db 'o'
    db 'w'
    db 'o'
    db 'r'
    db 'l'
    db 'd'
    db '!'
