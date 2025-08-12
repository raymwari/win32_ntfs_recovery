section .bss  
  drv resb 6
  ofs resb 136
  dr resb 6
  drh resb 4 
  spc resb 4 
  bps resb 4

section .data 
  FILE_ATTRIBUTE_NORMAL equ 0x80
  OPEN_EXISTING equ 3
  FILE_SHARE_READ equ 0x00000001
  FILE_SHARE_WRITE equ 0x00000002
  GENERIC_READ equ 0x80000000
  boots_sz equ 512
  INV_FS equ 0x6A5
  conf db "config.cfg", 0
  ; debugging string:
  debug db "darkside", 0

section .bss
  boots_bf resb boots_sz ; NFTS boot sector
  vd resb 1

section .text
  global main
  main:
  extern CreateFileA, onerr
  extern ExitProcess, ReadFile
  extern SetLastError, mft
  extern OpenFile, CloseHandle

  push 0x00002000 ; OF_PROMPT
  lea eax, ofs
  push eax
  push conf
  call OpenFile
  test eax, eax
  jz onerr
  mov edi, eax

  push 0
  push 0
  push 6
  lea ebx, drv
  push ebx
  push edi
  call ReadFile
  test eax, eax
  jz onerr  

  push edi
  call CloseHandle

  mov esi, drv
  test esi, esi
  mov edi, dr
  mov ecx, 6
  arg1:
    mov byte al, [esi]
    mov byte [edi], al
    inc esi
    inc edi
    dec ecx
    test ecx, ecx
    jnz arg1

  push 0
  push FILE_ATTRIBUTE_NORMAL
  push OPEN_EXISTING
  push 0
  push FILE_SHARE_READ | FILE_SHARE_WRITE
  push GENERIC_READ
  mov esi, dr
  push esi
  call CreateFileA
  test eax, eax
  jz onerr
  mov [drh], eax
  mov edi, [drh]

  push 0
  push 0
  push boots_sz
  lea eax, boots_bf
  push eax
  push edi
  call ReadFile
  test eax, eax
  jz onerr

  mov esi, boots_bf
  mov ecx, boots_sz
  sig:
    mov byte al, [esi]
    cmp byte al, 'N'
    jne nxt
    mov byte al, [esi + 1]
    cmp byte al, 'T'
    jne nxt
    mov byte al, [esi + 2]
    cmp byte al, 'F'
    jne nxt    
    mov byte al, [esi + 3]
    cmp byte al, 'S'
    jne nxt    
    mov byte [vd], 'T'
    nxt:
      inc esi
      dec ecx
      test ecx, ecx
      jnz sig
       
  mov byte al, [vd]
  cmp al, 'T'
  je valid
  push INV_FS
  call SetLastError
  jmp onerr
  valid:
    mov esi, boots_bf
    xor eax, eax
    movzx eax, word [esi + 0x0B] ; bytes per sector 
    mov [bps], eax
    xor ebx, ebx
    movzx ebx, byte [esi + 0x0D] ; sectors per cluster
    mov [spc], ebx
    xor ecx, ecx
    mov ecx, dword [esi + 0x30] ; logical cluster number offset
    mul ebx
    mul ecx
    
    mov ebx, eax
    push ebx
    push edi
    call mft
  
  push 0
  call ExitProcess