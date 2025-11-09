INCLUDE Irvine32.inc

Encryption PROTO
Decryption PROTO
Hashing PROTO

.data
mainMenuMsg BYTE "==============================",0Dh,0Ah,
               "  FAST CRYPTOGRAPHY ENGINE  ",0Dh,0Ah,
               "==============================",0Dh,0Ah,
               "1. Encrypt a Message",0Dh,0Ah,
               "2. Decrypt a Message",0Dh,0Ah,
               "3. Hash a String",0Dh,0Ah,
               "4. Exit",0Dh,0Ah,
               "==============================",0Dh,0Ah,
               "Enter your choice: ",0
invalidMsg  BYTE "Invalid choice! Try again.",0Dh,0Ah,0
goodbyeMsg  BYTE "Thank You for using FAST Cryptography Engine, GOODBYE!",0Dh,0Ah,0

choice DWORD ?

.code
main PROC

mainLoop:
    mov edx, OFFSET mainMenuMsg
    call WriteString

    call ReadInt
    mov choice, eax

    cmp eax, 1
    je doEncrypt
    cmp eax, 2
    je doDecrypt
    cmp eax, 3
    je doHashing
    cmp eax, 4
    je exitProgram

    mov edx, OFFSET invalidMsg
    call Clrscr
    call WriteString
    jmp mainLoop

doEncrypt:
    call Encryption
    jmp mainLoop

doDecrypt:
    call Decryption
    jmp mainLoop

doHashing:
    call Hashing
    jmp mainLoop

exitProgram:
    call Clrscr
    mov edx, OFFSET goodbyeMsg
    call WriteString
    exit
main ENDP
END main