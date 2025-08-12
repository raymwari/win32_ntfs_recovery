section .data
  FILE_ATTRIBUTE_NORMAL equ 0x80
  CREATE_NEW equ 1
  FILE_SHARE_READ equ 0x00000001
  FILE_SHARE_WRITE equ 0x00000002
  GENERIC_WRITE equ 0x40000000

section .text
  extern CreateFileW, CloseHandle
  extern WriteFile
  nrf:
    push ebp
    push esi
    push edi
    push eax
    push ebx
    push ecx
    push edx

    mov ebp, esp
    push 0
    push FILE_ATTRIBUTE_NORMAL
    push CREATE_NEW
    push 0
    push FILE_SHARE_READ | FILE_SHARE_WRITE
    push GENERIC_WRITE
    mov ebx, [ebp + 32] 
    push ebx
    call CreateFileW 
    mov esi, eax    

    push 0
    push 0
    mov eax, [ebp + 36] 
    push eax
    mov ebx,  [ebp + 40]
    push ebx
    push esi
    call WriteFile     

    push esi
    call CloseHandle

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop esi
    pop ebp
    ret 12