; Muntadhar Haydar (@mrmhk97)
; Lab 05.09.17
; Test, print only the odd numbers of array entered by the user


data segment
    msgWrongInput db 10, 13, "Sorry! your input doesn't seem to be accepted.", 10, 13, "$"
    msgAskForArrLen db "Enter the length of the array: $"
    msgArrEleIn db 10, 13, "Enter the elements of your array: $"
    msgArrEleOut db 10, 13, "The array has the following odd elements: $"
    newln db 10, 13, "$"
    array db 100 dup(0)
    length db 0
    pkey db 10, 13, "press any key...$"
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
    
    lea dx, msgAskForArrLen
    mov ah, 9
    int 21h
    
    call rd_num
    
    cmp al, 1
    ja next
    lea dx, msgWrongInput
    mov ah, 9
    int 21h
    jmp endProg
    
    next:
    mov length, al
    
    lea si, array
    call arr_in  
    
    lea dx, msgArrEleOut
    mov ah, 9
    int 21h
    
    mov ch, 2
    mov cl, length
    lea si, array
    
    nextCheck:
    mov ah, 0
    mov al, [si]
    div ch
    cmp ah, 0
    je even
    mov al, [si]
    call dsp_num 
    
    mov dx, " "
    mov ah, 2
    int 21h
    
    even:
    inc si
    dec cl
    jnz nextCheck
    
    
    endProg:            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends 

arr_in:
    push ax
    push cx
    push dx
    
    mov cl, length 
    lea dx, msgArrEleIn
    mov ah, 9
    int 21h
    next_in:
    call rd_num
    mov [si], al
    mov ah, 2
    mov dl, " "
    int 21h
    inc si
    dec cl
    jnz next_in
    
    pop dx
    pop cx
    pop ax
    ret
    ret

rd_num:
    push bx
    push cx
    mov ch, 10
    mov ah, 1
    int 21h
    
    cmp al, 29h
    jl notNum
    cmp al, 40h
    ja notNum
    
    sub al, 30h
    mul ch
    mov bh, al
    mov ah, 1
    int 21h
    
    cmp al, 29h
    jl notNum
    cmp al, 40h
    ja notNum
    
    sub al, 30h
    add bh, al
    mov al, bh
    jmp end_rd_num
    
    notNum:
    lea dx, msgWrongInput
    mov ah, 9
    int 21h
    call rd_num
            
    end_rd_num:
    pop cx
    pop bx
    ret
    
dsp_num:
    push cx
    mov ch, 10
    mov ah, 0
    div ch
    add al, 30h
    add ah, 30h
    mov ch, al
    mov cl, ah
    mov ax, 0200h
    mov dl, ch
    cmp dl, "0"
    je skip
    int 21h
    skip:
    mov dl, cl
    int 21h
    pop cx
    ret

end start ; set entry point and stop the assembler.
