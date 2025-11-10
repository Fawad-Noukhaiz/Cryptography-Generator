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
   

EncryptMenu:
call crlf
 mov edx, OFFSET takeWord
    call WriteString
    mov edx, OFFSET encryptionWord
    mov ecx, SIZEOF encryptionWord-1  ;how many letetrs are allowed
    call ReadString
    mov sizeWord, eax

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
    call crlf
    mov edx, OFFSET caesarInput
    call WriteString
    call crlf
    call readint
    mov caesarKey, al
    mov esi, offset encryptionWord

ReadCharacter:
    mov al, [esi]
    cmp al, 'A'
    jl skipCharacter
    cmp al, 'Z'
    jg checkLower
    sub al, 'A'
    add al, caesarKey
    cmp al, 26
    jl uc_noRepeat
    sub al, 26
uc_noRepeat:
    add al, 'A'
    jmp skipCharacter

checkLower:
    cmp al, 'a'
    jl skipCharacter
    cmp al, 'z'
    jg skipCharacter
    sub al, 'a'
    add al, caesarKey
    cmp al, 26
    jl lc_noRepeat
    sub al, 26
lc_noRepeat:
    add al, 'a'

skipCharacter:
    mov [esi], al
    inc esi
    cmp byte ptr [esi], 0
    jne ReadCharacter

    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset encryptionWord
    call WriteString
    call Crlf
    call WaitMsg    ;to wait to see encrypted string then go to menu
    jmp EncryptMenu ;to go again to menu to try different cipher

XOREncrypt:
    mov edx, OFFSET encryptingmsg
    call WriteString
    call Crlf
    mov ecx, 5
    mov edi, offset xorKey
l1:
    mov edx, offset xorInput
    call WriteString
    call readint
    mov [edi], al
    call crlf
    inc edi
    loop l1

    mov esi, offset encryptionWord
    mov edi, offset xorKey
xorr:
    mov al, [esi]
    cmp al, 0
    je doneXOR
    xor al, [edi]
    mov [esi], al
    inc esi
    inc edi
    cmp edi, offset xorKey + 5
    jb noRepeatXOR
    mov edi, offset xorKey
noRepeatXOR:
    jmp xorr
doneXOR:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset encryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    jmp EncryptMenu
VigenereEncrypt:
    mov edx, OFFSET encryptingmsg
    call WriteString
    call Crlf
    mov edx, OFFSET vigenereInput
    call WriteString
    mov edx, OFFSET vigenereKey
    mov ecx, SIZEOF vigenereKey -1
    call ReadString

    mov esi, offset encryptionWord
    mov edi, offset vigenereKey
vigenereLoop:
    mov al, [esi]
    cmp al, 0
    je vigeDone

    cmp al, 'A'
    jl skipV
    cmp al, 'Z'
    jg checkLowerV
    sub al, 'A'
    mov bl, [edi]
    cmp bl, 'a'
    jl keyIsUpper
    sub bl, 'a'
    jmp continueEncrypt
    keyIsUpper:
    sub bl, 'A'
continueEncrypt:
add al, bl
    cmp al, 26
    jl ucVNoRepeat
    sub al, 26
ucVNoRepeat:
    add al, 'A'
    mov [esi], al
    inc edi
    cmp byte ptr [edi], 0    
    jne skipV
    mov edi, offset vigenereKey
    jmp skipV

checkLowerV:
    cmp al, 'a'
    jl skipV
    cmp al, 'z'
    jg skipV
    sub al, 'a'
    mov bl, [edi]
    sub bl, 'a'
    add al, bl
    cmp al, 26
    jl lcVNoRepeat
    sub al, 26
lcVNoRepeat:
    add al, 'a'
    mov [esi], al
    inc edi
    
    cmp byte ptr [edi], 0    
    jne skipV
    mov edi, offset vigenereKey

skipV:
    inc esi
    jmp vigenereLoop

vigeDone:
    mov edx, OFFSET outputMessage
    call WriteString
    call Crlf
    mov edx, offset encryptionWord
    call WriteString
    call Crlf
    call WaitMsg
    jmp EncryptMenu

BackToMain:
    call Clrscr
    ret
Encryption ENDP

END
