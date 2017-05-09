; Muntadhar Haydar (@mrmhk97)
; 05.09.17
; Test, print "EXAM" word in the middle of the screen, and flashing ...
; Edited: "EXAM" was replaced by my name :P

data segment
    pkey db 10, 13, "press any key...$" 
	msg db "Muntadhar"
	msgLength db 9
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    mov al, 03h
	mov ah, 0
	int 10h 
	
	PrintEndlessly:
	
	mov bl, 00001100b   ; Color attr.
	call printMsg       ; Print
	call delay          ; Wait a little bit
	
	mov bl, 00001001b   ; Same as above with differente color.
	call printMsg       ;            
	call  delay         ;
	
	jmp PrintEndlessly  ; While (1)
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends


; Documentations of INT10 will make this clear.
printMsg:
    mov al, 1
	mov bh, 0
	mov ch, 0
	mov cl, msgLength
	mov dl, 35
	mov dh, 12
	lea bp, msg
	mov ah, 13h
	int 10h
	ret

; Empty loop ...
delay:
    push cx
    mov cx, 20
    delayLoop:
    nop
    dec cx
    jnz delayLoop
    pop cx
    ret

end start ; set entry point and stop the assembler.
