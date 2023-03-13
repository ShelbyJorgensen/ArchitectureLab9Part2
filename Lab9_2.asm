            segment         .data
a           dq              0
b           dq              0
          
sc_fmt:     db               "%ld", 0                           ; Used to take in user digits
p1_fmt:     db               "Enter a: ", 0                     ; User prompt 1
p2_fmt:     db               "Enter b: ", 0                     ; User prompt 2
p3_fmt:     db                "gcd(%ld, %ld) = %ld", 0x0a, 0    ; Display results of the function

            segment         .text
            global          main                                ; Establish main
            global          gcd                                 ; Establish gcd
            extern          printf                              ; Import printf function
            extern          scanf                               ; Import scanf function
            
main:
            push            rbp                                 ; Create the stack
            mov             rbp, rsp                            ; Backup the stack into rsp
            frame           0, 0, 4                             ; Frame macro: function in this function take at most 4 parameters
            sub             rsp, frame_size                     ; Create space in the stack
            
            lea             rcx, [p1_fmt]                       ; Parameter 1 is the print format
            call            printf                              ; Call printf, print out the first user prompt
           
            lea             rcx, [sc_fmt]                       ; Parameter 1 is the scanner format
            lea             rdx, [a]                            ; Parameter 2 is a, that will hold the user input
            call            scanf                               ; Call scanf, take in first user input
            
            lea             rcx, [p2_fmt]                       ; Parameter 1 is the print format
            call            printf                              ; Call printf, print out the second user prompt
            
            lea             rcx, [sc_fmt]                       ; Parameter 1 is the scanner format
            lea             rdx, [b]                            ; Parameter 2 is b, that will hold the user input
            call            scanf                               ; Call scanf, take in second user input
            
            mov             rcx, [a]                            ; Parameter 1 is a
            mov             rdx, [b]                            ; Parameter 2 is b          
            call            gcd                                 ; Call the gcd function with parameters a and b
            
            lea             rcx, [p3_fmt]                       ; Parameter 1 is the print format
            mov             rdx, [a]                            ; Parameter 2 is a
            mov             r8, [b]                             ; Parameter 3 is b
            mov             r9, rbx                             ; Parameter 4 is the gcd
            call            printf                              ; Print out the gcd results
            
            xor             eax, eax                            ; Set return value for main function
            leave                                               ; End of program
            ret
            
gcd:
la          equ             local1                              ; Local variable 1 has the name la
lb          equ             local2                              ; Local variable 2 has the name lb

            push            rbp                                 ; Create the stack
            mov             rbp, rsp                            ; Backup the stack into rsp
            frame           2, 2, 2                             ; Frame macro: Take in 2 parameters, 2 local variables, function in this function take at most 2 parameters
            sub             rsp, frame_size                     ; Create space in the stack
            
            mov             [rbp+la], rcx                       ; Local a has the value of parameter 1
            mov             [rbp+lb], rdx                       ; local b has the value of parameter 2
            
            cmp             rdx, 0                              ; Base case, when b = 0
            jg              greater                             ; if b <= 0 
            mov             rax, rbx                            ; Return the value of rbx
            leave                                               ; End of this function
            ret
            
greater:
            xor             rdx, rdx                            ; Clear rdx for division
            mov             rax, [rbp+la]                       ; Store a in rax for division  
            mov             rbx, [rbp+lb]                       ; Store the value of b before the divide
            idiv            qword [rbp+lb]                      ; a % b
            mov             [rbp+la], rbx                       ; a = b
            mov             [rbp+lb], rdx                       ; b = a % b
            call            gcd                                 ; Recursive call
            leave                                               ; End of this method
            ret
