section .text
  extern nr1
  nr:
    push ebp
    push edi
    push esi
    push eax
    push ebx
    push ecx
    push edx

    mov ebp, esp
    mov esi, [ebp + 36] 
    mov ecx, 0x400
    nrd:
      mov byte al, [esi]
      cmp byte al, 0x80
      jnz nrdc
      mov edi, esi
      add edi, 0x40
      movzx ebx, byte [edi]
      shr ebx, 4
      cmp ebx, 0x08
      jg nrdc ; invalid header
      push edi
      mov eax, [ebp + 32]
      push eax
      call nr1

      nrdc:
        inc esi
        dec ecx
        test ecx, ecx
        jnz nrd

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop esi
    pop edi
    pop ebp
    ret 8    