extern printf   ; includes printf
extern scanf    ; includes scanf 
extern cos
extern sin
global triangle 

segment .data

;return_string: db "This program will return 0 to the driver.", 10, 0

;string_format: db "%s", 0
float_input: db "Please input 3 floats: ", 0
three_float_format: db "%lf %lf %lf", 0
;prompt_name: db "Please enter your name: ", 0 
pi: dq 0x400921FB54442D18
example_output: db "Inputted sides %lf and %lf with angle %lf", 10, 0

area_perim_str: db "Perimeter: %lf linear units    Area: %lf square units",10, 0
bad_input: db "Invalid input. Please try again.", 10, 0
;exit: db "This program will now return to the driver", 10, 0


segment .bss
perimeter: resq 1 ;resq = reverse n qwords 
area: resq 1

segment .text
triangle:
;==============BoilerPlate================
    push rbp ; Push memory address of base of previous stack frame onto stack top

    mov rbp, rsp ; Copy value of stack pointer into base pointer, rbp = rsp = both point to stack top
    ; Rbp now holds the address of the new stack frame, i.e "top" of stack
    push rdi ; Backup rdi
    push rsi ; Backup rsi
    push rdx ; Backup rdx
    push rcx ; Backup rcx
    push r8 ; Backup r8
    push r9 ; Backup r9
    push r10 ; Backup r10
    push r11 ; Backup r11
    push r12 ; Backup r12
    push r13 ; Backup r13
    push r14 ; Backup r14
    push r15 ; Backup r15
    push rbx ; Backup rbx
    pushf ; Backup rflags
	
	push qword 0
;===========End of BoilerPlate=============

;============Begin input for three floats===========
	push qword 0
	;display prompt message 
	mov rax, 0 
	mov rdi, float_input
	call printf
	pop rax 
	
ask_floats:
	;Input the 3 floats 
	push qword 0
	push qword 0
	push qword 0

	mov rax, 0
	mov rdi, three_float_format
	mov rsi, rsp
	mov rdx, rsp
	add rdx, qword 8
	mov rcx, rsp
	add rcx, qword 16
	call scanf
	movsd xmm15, [rsp]
	movsd xmm14, [rsp + 8]
	movsd xmm13, [rsp + 16]

	pop rax
	pop rax
	pop rax
    pop rax
;==================End input of floats===================
    
 ;=========Print User =========
    
    ;mov rax, 1 ;using xmm registers 
    mov rdi, example_output
    mov rax, 3
    movsd xmm0, xmm15
    movsd xmm1, xmm14
    movsd xmm2, xmm13
    call printf

;=========Check If Negative=========
    mov r15, rax
    cmp r15, 0
    jl invalid
    jmp calculation

    invalid:
    push qword 0
    mov rax, 0
    mov rdi, bad_input
    call printf
    pop rax
    jmp end
    
    
;=========End Check If Negative=========
calculation: 
    ;put pi into xmm12
    mov rax, 0x400921FB54442D18 
    movq xmm12, rax ; xmm12 = pi
    ;convert to radians 
    mov rax, 180
    cvtsi2sd xmm11, rax ; xmm11 = 180
    divsd xmm12, xmm11 ; xmm12 = pi/180
    mulsd xmm13, xmm12 ; xmm13 = angle in radians
;=========End Print User Values=========

;=========Perimeter Calculation=========
    ;side c = sqrt(a^2 + b^2 - 2ab*cos(x))
    ;xmm15 = a
    ;xmm14 = b
    ;xmm13 = angle (rad)
    mov rax, 2
    cvtsi2sd xmm12, rax 
    mulsd xmm12, xmm15 ;xmm12 = 2*a
    mulsd xmm12, xmm14 ; xmm12 = 2*a*b

    ;getting a^2
    movsd xmm11, xmm15 
    mulsd xmm11, xmm11 ; xmm11 = a^2

    ;getting b^2
    movsd xmm10, xmm14
    mulsd xmm10, xmm10 ;xmm10 = b^2

    ;getting cos(x)
    movsd xmm0, xmm13
    call cos ; xmm0 = cos(x)

    mov rax, -1
    cvtsi2sd xmm9, rax
    mulsd xmm9, xmm12 ;xmm9 = -2*a*b
    mulsd xmm9, xmm0 ;xmm9 = -2ab*cos(x)
    addsd xmm9, xmm10 ;xmm9 = a^2 -2ab*cos(x)
    addsd xmm9, xmm11 ;xmm9 = a^2 + b^2 - 2ab*cos(x)
    sqrtsd xmm9, xmm9 ;xmm9 = side c 

    ;add all the sides together 
    addsd xmm9, xmm15
    addsd xmm9, xmm14 ;xmm9 = perimeter 
    ;moving for later 
    movsd [perimeter], xmm9 
;==========End of Perimeter Calculation=======

;===========Area Calculation========
    ;area = [a*b*sin(x)]/2
    ;xmm15 = a
    ;xmm14 = b
    ;xmm13 = angle(rad)
    movsd xmm0, xmm13
    call sin ;xmm0 = sin(x)

    ;plug values into the formula
    movsd xmm12, xmm0
    mulsd xmm12, xmm15
    mulsd xmm12, xmm14
    mov rax, 2
    cvtsi2sd xmm11, rax
    divsd xmm12, xmm11 ;xmm12 = area 
    movsd [area], xmm12

    ;print area and perimeter 
    movsd xmm0, [perimeter]
    movsd xmm1, [area]
    mov rdi, area_perim_str
    mov rax, 2
    call printf

    movsd xmm0, [area]

   

end:
	; return 0
    ;mov rax, 0

    popf ; Restore rflags
    pop rbx ; Restore rbx
    pop r15 ; Restore r15
    pop r14 ; Restore r14
    pop r13 ; Restore r13
    pop r12 ; Restore r12
    pop r11 ; Restore r11
    pop r10 ; Restore r10
    pop r9 ; Restore r9
    pop r8 ; Restore r8
    pop rcx ; Restore rcx
    pop rdx ; Restore rdx
    pop rsi ; Restore rsi
    pop rdi ; Restore rdi

    pop rbp ; Restore rbp

    ret ;  return
	