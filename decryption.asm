INCLUDE Irvine32.inc

.data
decryptMenuMsg BYTE "==============================",0Dh,0Ah,
                  "       DECRYPTION MENU        ",0Dh,0Ah,
                  "==============================",0Dh,0Ah,
                  "1. Caesar Cipher",0Dh,0Ah,
                  "2. XOR Cipher",0Dh,0Ah,
                  "3. Vigenere Cipher",0Dh,0Ah,
                  "4. Back to Main Menu",0Dh,0Ah,
                  "==============================",0Dh,0Ah,
                  "Enter your choice: ",0

invalidDecryptMsg BYTE "Invalid choice! Try again.",0Dh,0Ah,0
decryptingmsg BYTE "Decrypting Procedure Running... ",0

.code

Decryption PROC PUBLIC
    call Clrscr
    
DecryptMenu:
    mov edx, OFFSET decryptMenuMsg
    call WriteString

    call ReadInt
    
    cmp eax, 1
    je CaesarDecrypt
    cmp eax, 2
    je XORDecrypt
    cmp eax, 3
    je VigenereDecrypt
    cmp eax, 4
    je BackToMain
    
    mov edx, OFFSET invalidDecryptMsg
    call WriteString
    jmp DecryptMenu

CaesarDecrypt:
    mov edx, OFFSET decryptingmsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Decryption

XORDecrypt:
    mov edx, OFFSET decryptingmsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Decryption

VigenereDecrypt:
    mov edx, OFFSET decryptingmsg
    call WriteString
    call Crlf
    call WaitMsg
    jmp Decryption

BackToMain:
    call Clrscr
    ret
Decryption ENDP

END