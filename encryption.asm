INCLUDE Irvine32.inc

.data
encryptMenuMsg BYTE "==============================",0Dh,0Ah,
                  "       ENCRYPTION MENU        ",0Dh,0Ah,
                  "==============================",0Dh,0Ah,
                  "1. Caesar Cipher",0Dh,0Ah,
                  "2. XOR Cipher",0Dh,0Ah,
                  "3. Vigenere Cipher",0Dh,0Ah,
                  "4. Back to Main Menu",0Dh,0Ah,
                  "==============================",0Dh,0Ah,
                  "Enter your choice: ",0

invalidEncryptMsg BYTE "Invalid choice! Try again.",0Dh,0Ah,0
encryptingmsg BYTE "Encryption Procedure Running... ",0

.code

Encryption PROC PUBLIC
    call Clrscr
    
EncryptMenu:
    mov edx, OFFSET encryptMenuMsg
    call WriteString

    call ReadInt
    
    cmp eax, 1
    je CaesarEncrypt
    cmp eax, 2
    je XOREncrypt
    cmp eax, 3
    je VigenereEncrypt
    cmp eax, 4
    je BackToMain
    
    mov edx, OFFSET invalidEncryptMsg
    call WriteString
    jmp EncryptMenu

CaesarEncrypt:
    mov edx, OFFSET encryptingmsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Encryption

XOREncrypt:
    mov edx, OFFSET encryptingmsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Encryption

VigenereEncrypt:
    mov edx, OFFSET encryptingmsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Encryption

BackToMain:
    call Clrscr
    ret
Encryption ENDP

END