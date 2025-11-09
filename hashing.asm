INCLUDE Irvine32.inc

.data
hashingmsg BYTE "Hashing Procedure Running... ",0

.code

Hashing PROC PUBLIC
	mov edx, OFFSET hashingmsg
	call WriteString
    call Crlf
	ret
Hashing ENDP

END