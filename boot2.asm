; Second stage of the boot loader

BITS 16

ORG 9000h
	jmp 	Second_Stage

%include "functions_16_SF.asm"

;	Start of the second stage of the boot loader
	
Second_Stage:
	push 	word second_stage_msg	; Output our greeting message
    call 	Console_WriteLine_16
	
	push	word 2					; miscfunc(3, 2)
	push	word 3
	call 	miscfunc
									; At this point, AX contains the result of miscfunc
	
	hlt
	
second_stage_msg  db 'Second stage of boot loader running', 0
