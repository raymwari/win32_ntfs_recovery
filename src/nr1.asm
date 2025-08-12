section .bss
  dmh resd 1
  file_name resb 512 ; undefined 
  sc resb 8 ; start cluster
  nc resb 8 ; no of clusters

section .text
  extern drh, SetFilePointer
  extern onerr, ReadFile
  extern spc, bps
  extern VirtualAlloc, VirtualFree
  extern nrf
  nr1:
    push ebp
    push esi
    push eax
    push ebx
    push ecx
    push edx

    mov ebp, esp
    
    ; calculating noc len:
    mov esi, [ebp + 32]
    movzx eax, byte [esi]
    and eax, 0x0F
    mov ebx, eax

    mov esi, [ebp + 32] 
    movzx eax, byte [esi]
    shr eax, 4
    mov ecx, eax
    mov edi, sc
    inc esi ; skip header (always 1 byte)
    add esi, ebx ; skip noc len
    sch:
      mov byte al, [esi]
      mov byte [edi], al
      inc esi
      inc edi
      dec ecx
      test ecx, ecx
      jnz sch
    
    mov esi, sc
    ; extracted few modules ago:
    mov edx, [esi] ; logical cluster number
    xor eax, eax
    mov eax, [spc] ; sectors per cluster
    xor ebx, ebx
    mov ebx, [bps] ; bytes per sector
    imul ebx, eax
    imul edx, ebx ; data offset
    test edx, edx 

    mov esi, [ebp + 32]
    movzx eax, byte [esi]
    and eax, 0x0F
    test eax, eax
    mov ecx, eax
    mov edi, nc
    inc esi ; skip header
    ncl:
      mov byte al, [esi]
      mov byte [edi], al
      inc esi
      inc edi
      dec ecx
      test ecx, ecx
      jnz ncl
    
    mov esi, nc
    mov edi, [esi] ; number of clusters

    push 0 ; FILE_BEGIN
    lea eax, dmh
    push eax
    push edx
    mov ebx, [drh]
    push ebx
    call SetFilePointer
    jnz onerr  

    mov eax, [spc] 
    xor ebx, ebx
    mov ebx, [bps] 
    imul ebx, eax
    imul edi, ebx ; size in bytes  

    push 0x4
    push 0x00001000 ; MEM_COMMIT
    push edi
    push 0
    call VirtualAlloc
    test eax, eax
    jz onerr
    mov esi, eax

    push 0
    push 0
    push edi
    push esi
    mov ebx, [drh]
    push ebx
    call ReadFile
    test eax, eax
    jz onerr

    push esi
    push edi
    mov eax, [ebp + 28]
    push eax
    call nrf

    ; clean up:
    push 0x00004000 ; MEM_DECOMMIT
    push edi
    push esi
    call VirtualFree
    test eax, eax
    jz onerr
    
    mov edi, sc
    mov ecx, 8
    csc:
      mov byte [edi], 0
      inc edi
      dec ecx
      test ecx, ecx
      jnz csc
    
    mov edi, nc
    mov ecx, 8
    ncc:
      mov byte [edi], 0
      inc edi
      dec ecx
      test ecx, ecx
      jnz ncc

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop esi
    pop ebp
    ret 8