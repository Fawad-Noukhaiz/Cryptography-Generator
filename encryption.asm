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

encryptionWord BYTE 50 DUP(?)
PUBLIC encryptionWord
sizeWord DWORD ?
caesarKey BYTE ?
vigenereKey BYTE 5 DUP(?)
xorKey BYTE 5 DUP(?)

takeWord BYTE "Enter the word to encrypt: ",0
caesarInput BYTE "Enter key to Cipher: ",0
xorInput BYTE "Enter the value of key: ",0
vigenereInput BYTE "Enter the word to Cipher: ",0
outputMessage BYTE "The Encrypted value is: ",0

.code
Encryption PROC PUBLIC
    call Clrscr

EncryptionMenu:
    call crlf
    mov edx, OFFSET encryptMenuMsg
    call WriteString
    call ReadInt
    cmp eax, 1
    je CaesarCipher
    cmp eax, 2
    je XorCipher
    cmp eax, 3
    je VigenereCipher
    cmp eax, 4
    je ReturnMainMenu
    mov edx, OFFSET invalidEncryptMsg
    call WriteString
    jmp EncryptionMenu

CaesarCipher:
    mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET encryptionWord
    mov ecx, SIZEOF encryptionWord-1
    call ReadString
    mov sizeWord, eax

    mov edx, OFFSET encryptingmsg
    call WriteString
    call crlf
    mov edx, OFFSET caesarInput
    call WriteString
    call crlf
    call readint
    mov caesarKey, al
    mov esi, offset encryptionWord

CaesarProcessChar:
    mov al, [esi]
    cmp al, 'A'
    jl CaesarNextChar
    cmp al, 'Z'
    jg CaesarCheckLower
    sub al, 'A'
    add al, caesarKey
    cmp al, 26
    jl NoWrapUpper
    sub al, 26
NoWrapUpper:
    add al, 'A'

CaesarCheckLower:
    cmp al, 'a'
    jl CaesarNextChar
    cmp al, 'z'
    jg CaesarNextChar
    sub al, 'a'
    add al, caesarKey
    cmp al, 26
    jl NoWrapLower
    sub al, 26
NoWrapLower:
    add al, 'a'

CaesarNextChar:
    mov [esi], al
    inc esi
    cmp byte ptr [esi], 0
    jne CaesarProcessChar

    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset encryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    jmp EncryptionMenu

XorCipher:
    mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET encryptionWord
    mov ecx, SIZEOF encryptionWord-1
    call ReadString
    mov sizeWord, eax

    mov edx, OFFSET encryptingmsg
    call WriteString
    call crlf

    mov ecx, 5
    mov edi, offset xorKey
XorReadKeyLoop:
    mov edx, offset xorInput
    call WriteString
    call readint
    mov [edi], al
    call crlf
    inc edi
    loop XorReadKeyLoop

    mov esi, offset encryptionWord
    mov edi, offset xorKey
XorProcessChar:
    mov al, [esi]
    cmp al, 0
    je XorFinish
    xor al, [edi]
    mov [esi], al
    inc esi
    inc edi
    cmp edi, offset xorKey + 5
    jb NoWrapXOR
    mov edi, offset xorKey
NoWrapXOR:
    jmp XorProcessChar
XorFinish:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset encryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    jmp EncryptionMenu

VigenereCipher:
    mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET encryptionWord
    mov ecx, SIZEOF encryptionWord-1
    call ReadString
    mov sizeWord, eax

    mov edx, OFFSET encryptingmsg
    call WriteString
    call crlf
    mov edx, OFFSET vigenereInput
    call WriteString
    mov edx, OFFSET vigenereKey
    mov ecx, SIZEOF vigenereKey -1
    call ReadString

    mov esi, offset encryptionWord
    mov edi, offset vigenereKey

VigenereProcessChar:
    mov al, [esi]
    cmp al, 'A'
    jl VigenereNextChar
    cmp al, 'Z'
    jg VigenereCheckLower
    sub al, 'A'
    mov bl, [edi]
    cmp bl, 'a'
    jl VigenereKeyUpper
    sub bl, 'a'
    jmp VigenereContinueUpper

VigenereKeyUpper:
    sub bl, 'A'

VigenereContinueUpper:
    add al, bl
    cmp al, 26
    jl NoWrapUpperV
    sub al, 26
NoWrapUpperV:
    add al, 'A'
    mov [esi], al
    inc edi
    cmp byte ptr [edi], 0
    jne VigenereNextChar
    mov edi, offset vigenereKey
    jmp VigenereNextChar

VigenereCheckLower:
    cmp al, 'a'
    jl VigenereNextChar
    cmp al, 'z'
    jg VigenereNextChar
    sub al, 'a'
    mov bl, [edi]
    cmp bl, 'a'
    jl VigenereKeyUpperForLower
    sub bl, 'a'
    jmp VigenereContinueUpperForLower

VigenereKeyUpperForLower:
    sub bl, 'A'

VigenereContinueUpperForLower:
    add al, bl
    cmp al, 26
    jl NoWrapLowerV
    sub al, 26
NoWrapLowerV:
    add al, 'a'
    mov [esi], al
    inc edi
    cmp byte ptr [edi], 0
    jne VigenereNextChar
    mov edi, offset vigenereKey

VigenereNextChar:
    inc esi
    cmp byte ptr [esi],0
    jne VigenereProcessChar

VigenereFinish:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset encryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    jmp EncryptionMenu

ReturnMainMenu:
    call Clrscr
    ret

Encryption ENDP
END
