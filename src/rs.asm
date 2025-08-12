section .data
  FILE_ATTRIBUTE_NORMAL equ 0x80
  CREATE_NEW equ 1
  FILE_SHARE_READ equ 0x00000001
  FILE_SHARE_WRITE equ 0x00000002
  GENERIC_WRITE equ 0x40000000

section .text 
  rs:
    extern rdata, len
    extern CreateFileW, CloseHandle
    extern WriteFile

    push ebp
    push esi
    push eax
    push ebx

    mov ebp, esp
    push 0
    push FILE_ATTRIBUTE_NORMAL
    push CREATE_NEW
    push 0
    push FILE_SHARE_READ | FILE_SHARE_WRITE
    push GENERIC_WRITE
    mov ebx, [ebp + 20] 
    push ebx
    call CreateFileW 
    mov esi, eax

    push 0
    push 0
    mov eax, [len] 
    push eax
    push rdata
    push esi
    call WriteFile 

    push esi
    call CloseHandle

    pop ebx
    pop eax
    pop esi
    pop ebp  
    ret 4