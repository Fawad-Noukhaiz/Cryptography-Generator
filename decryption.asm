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
decryptingmsg BYTE "Decrypting Procedure Running... ",0Dh,0Ah,0

decryptionWord BYTE 50 DUP(?)
sizeWord DWORD ?
caesarKey BYTE ?
vigenereKey BYTE 50 DUP(?)
xorKey BYTE 5 DUP(?)
keyCounter DWORD ?

takeWord BYTE "Enter the encrypted word to decrypt: ",0
caesarInput BYTE "Enter Caesar key used for encryption: ",0
xorInput BYTE "Enter XOR key value (number 0-255): ",0
vigenereInput BYTE "Enter the Vigenere key used for encryption: ",0
outputMessage BYTE "The Decrypted value is: ",0

.code

Decryption PROC PUBLIC
    call Clrscr
    
DecryptMenu:
    call crlf

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
        mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET decryptionWord
    mov ecx, SIZEOF decryptionWord - 1
    call ReadString
    mov sizeWord, eax

    mov edx, OFFSET decryptingmsg
    call WriteString
    call Crlf
    
    mov edx, OFFSET caesarInput
    call WriteString
    call ReadInt
    mov caesarKey, al
    call Crlf
    
    mov esi, offset decryptionWord

CaesarDecryptLoop:
    mov al, [esi]
    cmp al, 0
    je CaesarDone
    
    cmp al, 'A'
    jl CaesarSkip
    cmp al, 'Z'
    jg CaesarCheckLower
    
    sub al, 'A'
    sub al, caesarKey
    cmp al, 0
    jge CaesarUppercaseNoWrap
    add al, 26
CaesarUppercaseNoWrap:
    add al, 'A'
    jmp CaesarSkip

CaesarCheckLower:
    cmp al, 'a'
    jl CaesarSkip
    cmp al, 'z'
    jg CaesarSkip
    
    sub al, 'a'
    sub al, caesarKey
    cmp al, 0
    jge CaesarLowercaseNoWrap
    add al, 26
CaesarLowercaseNoWrap:
    add al, 'a'

CaesarSkip:
    mov [esi], al
    inc esi
    jmp CaesarDecryptLoop

CaesarDone:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset decryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    call Clrscr
    jmp DecryptMenu

XORDecrypt:
    mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET decryptionWord
    mov ecx, SIZEOF decryptionWord - 1
    call ReadString
    mov sizeWord, eax

    mov edx, OFFSET decryptingmsg
    call WriteString
    call Crlf
    
    mov keyCounter, 0
    mov edi, offset xorKey
    
XORKeyInput:
    mov edx, offset xorInput
    call WriteString
    call ReadInt
    mov [edi], al
    inc edi
    inc keyCounter
    cmp keyCounter, 5
    jl XORKeyInput

    call Crlf
    
    mov esi, offset decryptionWord
    mov edi, offset xorKey
    
XORDecryptLoop:
    mov al, [esi]
    cmp al, 0
    je XORDone
    xor al, [edi]
    mov [esi], al
    inc esi
    inc edi
    
    mov eax, edi
    sub eax, offset xorKey
    cmp eax, 5
    jl XORDecryptLoop
    mov edi, offset xorKey
    jmp XORDecryptLoop

XORDone:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset decryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    call Clrscr
    jmp DecryptMenu

VigenereDecrypt:
     mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET decryptionWord
    mov ecx, SIZEOF decryptionWord - 1
    call ReadString
    mov sizeWord, eax

    mov edx, OFFSET decryptingmsg
    call WriteString
    call Crlf
    
    mov edx, OFFSET vigenereInput
    call WriteString
    mov edx, OFFSET vigenereKey
    mov ecx, SIZEOF vigenereKey - 1
    call ReadString

    mov esi, offset decryptionWord
    mov edi, offset vigenereKey

VigenereDecryptLoop:
    mov al, [esi]
    cmp al, 0
    je VigenereDone

    cmp al, 'A'
    jl VigenereSkip
    cmp al, 'Z'
    jg VigenereCheckLower
    
    sub al, 'A'
    mov bl, [edi]
    cmp bl, 'a'
    jl VigenereKeyIsUpper
    sub bl, 'a'
    jmp VigenereContinueDecrypt
VigenereKeyIsUpper:
    sub bl, 'A'
VigenereContinueDecrypt:
    sub al, bl
    cmp al, 0
    jge VigenereUppercaseNoWrap
    add al, 26
VigenereUppercaseNoWrap:
    add al, 'A'
    mov [esi], al
    inc edi
    cmp byte ptr [edi], 0
    jne VigenereSkip
    mov edi, offset vigenereKey
    jmp VigenereSkip

VigenereCheckLower:
    cmp al, 'a'
    jl VigenereSkip
    cmp al, 'z'
    jg VigenereSkip
    
    sub al, 'a'
    mov bl, [edi]
    cmp bl, 'a'
    jl VigenereLowerKeyIsUpper
    sub bl, 'a'
    jmp VigenereLowerContinueDecrypt
VigenereLowerKeyIsUpper:
    sub bl, 'A'
VigenereLowerContinueDecrypt:
    sub al, bl
    cmp al, 0
    jge VigenereLowercaseNoWrap
    add al, 26
VigenereLowercaseNoWrap:
    add al, 'a'
    mov [esi], al
    inc edi
    cmp byte ptr [edi], 0
    jne VigenereSkip
    mov edi, offset vigenereKey

VigenereSkip:
    inc esi
    jmp VigenereDecryptLoop

VigenereDone:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset decryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    call Clrscr
    jmp DecryptMenu

BackToMain:
    call Clrscr
    ret
Decryption ENDP

END
