; ==============================================================================
; Project: Two-Pointer Palindrome Checker (Subroutine)
; Description: Uses a subroutine and the two-pointer algorithmic technique
;              (Start and End pointers) to check if a string terminated by 0DH
;              is a palindrome. Returns 1 if true, 0 if false.
; ==============================================================================

#ORG 2000H

; ==============================================================================
; --- MAIN PROGRAM ---
; ==============================================================================
        LXI H, 2000H    ; Parameter: Load starting address of the string into HL
        CALL PALIN      ; Call the Palindrome Checker Subroutine
        STA 3000H       ; Store the returned result (1 or 0) in memory
        HLT             ; Halt the processor

; ==============================================================================
; --- SUBROUTINE: PALIN ---
; ==============================================================================
PALIN:  PUSH H          ; Backup the starting address to the Stack
        MVI B, 00H      ; Initialize length counter

; --- Step 1: Find Terminator (0DH) and Calculate Length ---
LEN_CHK:MOV A, M        ; Read character
        CPI 0DH         ; Is it the terminator?
        JZ END_FND      ; If yes, exit length calculation
        INR B           ; Increment length counter
        INX H           ; Move to next character
        JMP LEN_CHK

END_FND:POP H           ; Restore the starting address from Stack
        MOV A, B        ; Load length into A
        CPI 02H         ; Is length < 2?
        JC YES          ; If length is 0 or 1, it is trivially a palindrome

; --- Step 2: Set DE Pointer to the LAST Character ---
        PUSH H
        POP D           ; DE = HL (Base address)
        MOV A, B        ; A = Length
        DCR A           ; A = Length - 1
        ADD E           ; E = E + (Length - 1)
        MOV E, A
        MOV A, D
        ACI 00H         ; Handle 16-bit carry
        MOV D, A        ; DE now points to the last character

; --- Step 3: Calculate Loop Iterations (Length / 2) ---
        MOV A, B
        RRC             ; Divide length by 2
        ANI 7FH         ; Clear MSB for safety
        MOV C, A        ; C = Loop iteration counter

; --- Step 4: Two-Pointer Comparison Loop ---
COMP:   LDAX D          ; Get character from the End pointer
        CMP M           ; Compare with character from the Start pointer
        JNZ NO          ; If not equal, it is NOT a palindrome
        INX H           ; Move Start pointer forward
        DCX D           ; Move End pointer backward
        DCR C           ; Decrement loop counter
        JNZ COMP        ; Repeat until pointers meet

; --- Step 5: Return Results ---
YES:    MVI A, 01H      ; True: Load 1 into Accumulator
        RET             ; Return to Main Program

NO:     MVI A, 00H      ; False: Load 0 into Accumulator
        RET             ; Return to Main Program