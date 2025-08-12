section .data
  dmft equ 0x4D8 ; default size for each record

section .bss
  dmft_bf resb dmft
  fl resb 1

section .text
  extern rec, dir
  extern nr
  rc_hd:
    push ebp
    push esi
    push eax
    push ebx
    push ecx
    push edx

    mov ebp, esp
    mov esi, [ebp + 28]
    mov edx, dmft
    fn:
      mov byte al, [esi]
      cmp al, 0x30
      jne n
        ; STANDARD:
        movzx edx, byte [esi + 0x08] ; flags
        cmp edx, 0x01 ; non resident
        jne rsc
        push esi
        push edi
        call nr    

        rsc:
          test edx, edx 
          jnz nxt ; resident
          ;;;;
          mov edi, esi
          add edi, 0x5A ; short file name (MS-DOS-readable)
          mov ecx, 0x18
          ex:
            mov byte ah, [edi]
            cmp byte ah, '~'
            jne n1
            jmp n

            n1:
              inc edi
              dec ecx
              test ecx, ecx
              jnz ex
        sub edi, 0x18 ; original file name
        mov ebx, [ebp + 28]
        push ebx
        push edi
        call rec

      n:
        inc esi
        dec edx
        test edx, edx
        jnz fn
        
    nxt:
      pop edx
      pop ecx
      pop ebx
      pop eax
      pop esi
      pop ebp
      ret 4