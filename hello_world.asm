_start:
    xor eax, eax        ; syscall no
    xor ebx, ebx        ; fdno
    xor edx, edx        ; slen
    
    inc ebx             ; stdout
.loopeax:
    inc eax
    cmp eax, 4          ; sys_write = 4
    jl .loopeax

.loopedx:
    inc edx
    cmp edx, 11         ; strlen = 11
    jl .loopedx
    
    mov ecx, 0x80480f1  ; "helloworld!"
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
