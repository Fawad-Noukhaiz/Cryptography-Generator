INCLUDE Irvine32.inc

.data
hashMenuMsg BYTE "==============================",0Dh,0Ah,
                 "        HASHING MENU          ",0Dh,0Ah,
                 "==============================",0Dh,0Ah,
                 "1. MD5 Hash",0Dh,0Ah,
                 "2. Back to Main Menu",0Dh,0Ah,
                 "==============================",0Dh,0Ah,
                 "Enter your choice: ",0

inputPrompt BYTE "Enter string to hash: ",0
outputPrompt BYTE 0Dh,0Ah,"MD5 Hash: ",0
hashingmsg BYTE 0Dh,0Ah,"Computing MD5 Hash...",0Dh,0Ah,0
invalidHashMsg BYTE 0Dh,0Ah,"[ERROR] Invalid choice! Please enter 1 or 2.",0Dh,0Ah,0Dh,0Ah,0
separator BYTE "------------------------------",0Dh,0Ah,0

md5_a DWORD ?
md5_b DWORD ?
md5_c DWORD ?
md5_d DWORD ?

inputString BYTE 64 DUP(?)
inputLen DWORD ?

paddedMsg BYTE 64 DUP(0)

M DWORD 16 DUP(?)

var_a DWORD ?
var_b DWORD ?
var_c DWORD ?
var_d DWORD ?
temp DWORD ?
f_result DWORD ?
g_index DWORD ?

s BYTE 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22
  BYTE 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20
  BYTE 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23
  BYTE 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21

K DWORD 0d76aa478h, 0e8c7b756h, 0242070dbh, 0c1bdceeeh
  DWORD 0f57c0fafh, 04787c62ah, 0a8304613h, 0fd469501h
  DWORD 0698098d8h, 08b44f7afh, 0ffff5bb1h, 0895cd7beh
  DWORD 06b901122h, 0fd987193h, 0a679438eh, 049b40821h
  DWORD 0f61e2562h, 0c040b340h, 0265e5a51h, 0e9b6c7aah
  DWORD 0d62f105dh, 002441453h, 0d8a1e681h, 0e7d3fbc8h
  DWORD 021e1cde6h, 0c33707d6h, 0f4d50d87h, 0455a14edh
  DWORD 0a9e3e905h, 0fcefa3f8h, 0676f02d9h, 08d2a4c8ah
  DWORD 0fffa3942h, 08771f681h, 06d9d6122h, 0fde5380ch
  DWORD 0a4beea44h, 04bdecfa9h, 0f6bb4b60h, 0bebfbc70h
  DWORD 0289b7ec6h, 0eaa127fah, 0d4ef3085h, 004881d05h
  DWORD 0d9d4d039h, 0e6db99e5h, 01fa27cf8h, 0c4ac5665h
  DWORD 0f4292244h, 0432aff97h, 0ab9423a7h, 0fc93a039h
  DWORD 0655b59c3h, 08f0ccc92h, 0ffeff47dh, 085845dd1h
  DWORD 06fa87e4fh, 0fe2ce6e0h, 0a3014314h, 04e0811a1h
  DWORD 0f7537e82h, 0bd3af235h, 02ad7d2bbh, 0eb86d391h

.code

LeftRotate PROC
    push ebx
    mov ebx, eax
    rol eax, cl
    pop ebx
    ret
LeftRotate ENDP

MD5_F PROC
    push ebx
    mov eax, md5_b
    and eax, md5_c
    mov ebx, md5_b
    not ebx
    and ebx, md5_d
    or eax, ebx
    pop ebx
    ret
MD5_F ENDP

MD5_G PROC
    push ebx
    mov eax, md5_b
    and eax, md5_d
    mov ebx, md5_d
    not ebx
    and ebx, md5_c
    or eax, ebx
    pop ebx
    ret
MD5_G ENDP

MD5_H PROC
    mov eax, md5_b
    xor eax, md5_c
    xor eax, md5_d
    ret
MD5_H ENDP

MD5_I PROC
    push ebx
    mov ebx, md5_d
    not ebx
    or ebx, md5_b
    mov eax, md5_c
    xor eax, ebx
    pop ebx
    ret
MD5_I ENDP

PadMessage PROC
    push esi
    push edi
    push ecx
    
    mov esi, OFFSET inputString
    mov edi, OFFSET paddedMsg
    mov ecx, inputLen
    rep movsb
    
    mov byte ptr [edi], 80h
    inc edi
    
    mov eax, inputLen
    inc eax
    mov ecx, 56
    sub ecx, eax
    
    cmp ecx, 0
    jle skip_padding
    mov al, 0
    rep stosb
    
skip_padding:
    mov eax, inputLen
    mov ebx, 8
    mul ebx
    mov dword ptr [edi], eax
    mov dword ptr [edi+4], 0
    
    pop ecx
    pop edi
    pop esi
    ret
PadMessage ENDP

ProcessBlock PROC
    push esi
    push edi
    push ecx
    push ebx
    
    mov esi, OFFSET paddedMsg
    mov edi, OFFSET M
    mov ecx, 16
copy_words:
    mov eax, dword ptr [esi]
    mov [edi], eax
    add esi, 4
    add edi, 4
    loop copy_words
    
    mov eax, md5_a
    mov var_a, eax
    mov eax, md5_b
    mov var_b, eax
    mov eax, md5_c
    mov var_c, eax
    mov eax, md5_d
    mov var_d, eax
    
    mov ecx, 0
    
main_loop:
    cmp ecx, 16
    jl round1
    cmp ecx, 32
    jl round2
    cmp ecx, 48
    jl round3
    jmp round4
    
round1:
    mov eax, var_b
    mov md5_b, eax
    mov eax, var_c
    mov md5_c, eax
    mov eax, var_d
    mov md5_d, eax
    call MD5_F
    mov f_result, eax
    mov eax, ecx
    mov g_index, eax
    jmp continue_round
    
round2:
    mov eax, var_b
    mov md5_b, eax
    mov eax, var_c
    mov md5_c, eax
    mov eax, var_d
    mov md5_d, eax
    call MD5_G
    mov f_result, eax
    mov eax, ecx
    mov ebx, 5
    mul ebx
    inc eax
    and eax, 0Fh
    mov g_index, eax
    jmp continue_round
    
round3:
    mov eax, var_b
    mov md5_b, eax
    mov eax, var_c
    mov md5_c, eax
    mov eax, var_d
    mov md5_d, eax
    call MD5_H
    mov f_result, eax
    mov eax, ecx
    mov ebx, 3
    mul ebx
    add eax, 5
    and eax, 0Fh
    mov g_index, eax
    jmp continue_round
    
round4:
    mov eax, var_b
    mov md5_b, eax
    mov eax, var_c
    mov md5_c, eax
    mov eax, var_d
    mov md5_d, eax
    call MD5_I
    mov f_result, eax
    mov eax, ecx
    mov ebx, 7
    mul ebx
    and eax, 0Fh
    mov g_index, eax
    
continue_round:
    mov eax, var_d
    mov temp, eax
    
    mov eax, var_c
    mov var_d, eax
    
    mov eax, var_b
    mov var_c, eax
    
    mov eax, var_a
    add eax, f_result
    push ecx
    mov ebx, ecx
    shl ebx, 2
    add eax, K[ebx]
    mov ebx, g_index
    shl ebx, 2
    add eax, M[ebx]
    pop ecx
    
    push ecx
    movzx ebx, byte ptr s[ecx]
    mov cl, bl
    call LeftRotate
    pop ecx
    
    add eax, var_b
    mov var_b, eax
    
    mov eax, temp
    mov var_a, eax
    
    inc ecx
    cmp ecx, 64
    jl main_loop
    
    mov eax, var_a
    add md5_a, eax
    mov eax, var_b
    add md5_b, eax
    mov eax, var_c
    add md5_c, eax
    mov eax, var_d
    add md5_d, eax
    
    pop ebx
    pop ecx
    pop edi
    pop esi
    ret
ProcessBlock ENDP

ComputeMD5 PROC
    mov md5_a, 67452301h
    mov md5_b, 0efcdab89h
    mov md5_c, 98badcfeh
    mov md5_d, 10325476h
    
    call PadMessage
    
    call ProcessBlock
    
    ret
ComputeMD5 ENDP

PrintHash PROC
    push eax
    push ebx
    push ecx
    
    mov edx, OFFSET outputPrompt
    call WriteString
    
    mov eax, md5_a
    call WriteHex
    
    mov eax, md5_b
    call WriteHex
    
    mov eax, md5_c
    call WriteHex
    
    mov eax, md5_d
    call WriteHex
    
    call Crlf
    
    pop ecx
    pop ebx
    pop eax
    ret
PrintHash ENDP

Hashing PROC PUBLIC
    call Clrscr
    
HashMenu:
    mov edx, OFFSET hashMenuMsg
    call WriteString
    call ReadInt
    
    cmp eax, 1
    je DoMD5
    cmp eax, 2
    je BackToMain
    
    mov edx, OFFSET invalidHashMsg
    call WriteString
    call WaitMsg
    jmp HashMenu
    
DoMD5:
    call Clrscr
    mov edx, OFFSET separator
    call WriteString
    mov edx, OFFSET inputPrompt
    call WriteString
    mov edx, OFFSET inputString
    mov ecx, 55
    call ReadString
    mov inputLen, eax
    
    mov edx, OFFSET hashingmsg
    call WriteString
    
    call ComputeMD5
    call PrintHash
    call Crlf
    mov edx, OFFSET separator
    call WriteString
    call WaitMsg
    call Clrscr
    jmp HashMenu
    
BackToMain:
    call Clrscr
    ret
Hashing ENDP

END
