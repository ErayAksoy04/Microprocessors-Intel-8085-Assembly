; ==============================================================================
; Project: Conditional Combinatorics & Bitwise Division
; Description: Reads integer 'n'. If n <= 8, calculates (2^n - n - 1) using
;              16-bit shifting and two's complement subtraction. If n > 8,
;              calculates floor(n/8) using bitwise right rotations (RRC).
; ==============================================================================

#ORG 2000H

START:      LDA 2050H       ; Load the student count (n) into Accumulator
            MOV B, A        ; Backup 'n' in register B
            CPI 09H         ; Compare A with 9 (Check if n < 9)
            JC PART1        ; If Carry is set (n <= 8), jump to PART1

; --- Condition: n > 8 (Calculate n / 8) ---
PART2:      RRC             ; Rotate Right 1st time (Divide by 2)
            RRC             ; Rotate Right 2nd time (Divide by 4)
            RRC             ; Rotate Right 3rd time (Divide by 8)
            ANI 1FH         ; Mask the upper 3 bits to ensure clean division result
            JMP SAVE_RESULT ; Jump to end

; --- Condition: n <= 8 (Calculate 2^n - n - 1) ---
PART1:      LXI H, 0001H    ; Initialize HL pair with 1 (Represents 2^0)
            MOV C, B        ; Load loop counter C with 'n'
            MOV A, C        ; Move 'n' to Accumulator for zero check
            CPI 00H         ; Check if n = 0
            JZ SUBTRACT     ; If n = 0, 2^0 = 1, jump directly to subtraction

POWER_LOOP: DAD H           ; HL = HL + HL (Effectively multiplies HL by 2)
            DCR C           ; Decrement counter
            JNZ POWER_LOOP  ; Loop until 2^n is fully calculated in HL

SUBTRACT:   MOV C, B        ; Restore 'n' into C
            MVI B, 00H      ; Clear B to make BC a 16-bit representation of 'n'

            ; Calculate Two's Complement of BC to perform subtraction (HL - BC)
            MOV A, C
            CMA             ; 1's complement of C
            MOV C, A
            MOV A, B
            CMA             ; 1's complement of B
            MOV B, A
            INX B           ; Add 1 to get 2's complement. Now BC = -n

            DAD B           ; HL = HL + (-n) -> HL = 2^n - n
            DCX H           ; HL = HL - 1 -> Final result: 2^n - n - 1

            MOV A, L        ; Result fits in 8 bits, move Lower byte (L) to A

SAVE_RESULT:STA 2051H       ; Store the final result in memory address 2051H
            HLT             ; Halt the processor