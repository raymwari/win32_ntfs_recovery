section .bss
  rdata resb 512 ; max for non resident
  len resb 2

section .text
  extern CreateFileW, cnt
  extern ExitProcess, rs
  rec:
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
    mov edx, rdata
    d_attr:
      mov byte al, [esi]
      cmp al, 0x80
      jne n

      mov byte ah, [esi + 1]
      cmp ah, 0x00 ; resident
      jne nxtf
      ; TODO: call non resident handler if not equal
      mov edi, esi
      add edi, 0x18 ; start of data run
      movzx ebx, word [esi + 0x10] ; data run len
      cmp ebx, 512
      jg nxtf
      cmp ebx, 0
      jle nxtf  
      mov [len], ebx

      cp:
        mov byte ah, [edi]    
        mov byte [edx], ah
        inc edx
        inc edi
        dec ebx
        test ebx, ebx
        jnz cp

      n:
        inc esi
        dec ecx
        test ecx, ecx
        jnz d_attr
    
    mov edi, [ebp + 32] ; file name 
    push edi
    call rs

    mov esi, rdata
    mov ecx, 512
    cln:
      mov byte [esi], 0
      inc esi
      dec ecx
      test ecx, ecx
      jnz cln

    nxtf:
      pop edx
      pop ecx
      pop ebx
      pop eax
      pop esi
      pop edi
      pop ebp      

      ret 8

