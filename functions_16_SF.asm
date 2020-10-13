; Various sub-routines that will be useful to the boot loader code	

; Output Carriage-Return/Line-Feed (CRLF) sequence to screen using BIOS

Console_Write_CRLF:
	push	ax
	mov 	ah, 0Eh						; Output CR
    mov 	al, 0Dh
    int 	10h
    mov 	al, 0Ah						; Output LF
    int 	10h
	pop		ax
    ret

; Write to the console using BIOS.
; 
; The address of the string to display is passed on the stack

Console_Write_16:
	push 	bp
	mov		bp, sp
	push	si							; Save registers affected by this function
	push	ax
	mov		si, [bp + 4];				; Get the address of the string to print
	mov 	ah, 0Eh						; BIOS call to output value in AL to screen

Console_Write_16_Repeat:
	mov		al, [si]					; Load byte at SI into AL and increment SI
	inc 	si
    test 	al, al						; If the byte is 0, we are done
	je 		Console_Write_16_Done
	int 	10h							; Output character to screen
	jmp 	Console_Write_16_Repeat

	Console_Write_16_Done:
	pop		ax							; Retrieve the values for the registers affected by this function
	pop		si
	mov		sp, bp
	pop		bp
    ret		2

; Write string to the console using BIOS followed by CRLF
; 
; The address of the string to display is passed on the stack

Console_WriteLine_16:
	push 	bp
	mov		bp, sp
	push	word [bp + 4]
	call 	Console_Write_16
	call 	Console_Write_CRLF
	mov		sp, bp
	pop		bp
	ret		2

	
;  	short miscfunc(short a, short b)
;	{
;		int x;
;		int y;
;
;		x = a + b;
;		y = x + 10;
;		return x;
;	}

;	Constant definitions for the offsets to the parameters and variables

%assign a	6
%assign b 	4

%assign x	4
%assign y	2

miscfunc:
	push 	bp	
	mov		bp, sp
	sub		sp, 4				; Reserve space for local variables
	mov		ax, [bp + a]		; x = a + b
	add		ax, [bp + b]
	mov		[bp - x], ax
	mov		ax, [bp - x]		; y = x + 10			Note this line is not really needed, since ax already contains x
	add		ax, 10
	mov		[bp - y], ax
	mov		ax, [bp - x]		; return y 				The return value is returned in ax
	mov 	sp, bp
	pop		bp
	ret		4					; Return, removing the 2 parameters from the stack
	
	







