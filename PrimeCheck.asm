; Muntadhar Haydar (@mrmhk97)
; 05.03.17

data segment
    pkey db 10, 13, "press any key...$"
    msgWrongInput db "Sorry! but your input doesn't seem to be correct :/", 10, 13, "$"
    msgEnterNumber db "Enter a number to check it whether prime or not, (1 to 99, 0 to exit): $"
    msgItsPrime db 10, 13, "The number you have entered is prime. Huzzah", 10, 13, "$"
    msgItsNotPrime db 10, 13, "The number you have entered is NOT a prime number", 10, 13, "$"
    arrPrimaryPrimes db 1, 2, 3, 5, 7
    number db 0
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

    newNum:
    lea dx, msgEnterNumber
    mov ah, 9
    int 21h
    
    call rd_num
    cmp al, 0
    je exit
    mov number, al
    call check_prime
    jmp newNum
    
    exit:        
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

; A simple procedure to check if a 2-digits number stored in al 
; is a prime number or not.
; ah = al is prime.
check_prime:
    push bx
    push cx
    push dx
    
    mov ah, 0
    lea si, arrPrimaryPrimes
    mov cl, 5
    primeryPrimes:
    mov ch, [si]
    cmp al, ch
    je prime
    mov bx, ax
    cmp ch, 1
    je skipDiv
    div ch
    cmp ah, 0
    je result
    skipDiv:
    mov ax, bx
    inc si
    dec cl
    jnz primeryPrimes 
    
    prime:
    mov ah, 1
    
    result:
    cmp ah, 0
    je msgNotPrime
    lea dx, msgItsPrime
    jmp printOut
    msgNotPrime:
    lea dx, msgItsNotPrime
    
    printOut:
    push ax
    mov ah, 9
    int 21h
    pop ax
    pop dx
    pop cx
    pop bx
    ret

rd_snum:
    push cx
    mov ah, 1
    int 21h
    mov cl, al
    
    cmp cl, "+"
    jne notPlus
    jmp getInput
    
    notPlus:
    cmp cl, "-"
    jne wrongIn
    
    getInput:
    call rd_num    ; Call for an input
    cmp cl, "-"
    je minus
    jmp return
    
    wrongIn:
    lea dx, msgWrongInput
    mov ah, 9
    int 21h
    call rd_snum
    
    
    minus:
    not al         ; Two complement.
    add al, 1
    return:
    pop cx
    ret
    
dsp_snum:
    cmp al, 80h
    jb dsp
    push bx
    push dx
    mov bl, al
    mov dl, "-"
    mov ah, 2
    int 21h
    mov al, bl
    not al
    add al, 1
    pop dx
    pop bx
    dsp:
    call dsp_num
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
    call rd_snum
            
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
