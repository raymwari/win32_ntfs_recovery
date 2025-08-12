section .bss
  err_code resb 12
  written resb 12

section .text
  onerr:
    extern WSAGetLastError
    extern GetStdHandle, WriteConsoleA
    extern ExitProcess, GetLastError
    extern SetLastError

    call GetLastError
    mov ebx, 10
    lea esi, err_code
    add esi, 12
    mov edi, esi
    mov byte [esi], 0

    _convert:
      dec esi
      xor edx, edx
      div ebx
      add dl, '0'
      mov byte [esi], dl 
      test eax,eax
      jnz _convert
    
    cmp byte [esi], '8'
    jne nec

    push 0x6A6
    call SetLastError
    call onerr

    nec:
      push -12
      call GetStdHandle
      mov ebx, eax

      push 0
      lea ecx, written
      push ecx
      push 4
      push esi 
      push ebx
      call WriteConsoleA

      push 0
      call ExitProcess