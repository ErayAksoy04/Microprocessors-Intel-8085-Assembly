; ==============================================================================
; Project: Nested Delay Loop & Port Output
; Description: An infinite loop that decrements register B and outputs its value
;              to Port 00H. Uses an inner delay loop with register C (A4H) to
;              create a hardware delay of ~1.094 ms between each output.
; Clock Freq : T-State = 0.47 us
; ==============================================================================

#ORG 2000H

START:  MVI B, 00H      ; Initialize B to 00H

NEXT:   DCR B           ; Decrement B (00H -> FFH on first pass)
        MVI C, A4H      ; Load inner loop counter (A4H = 164 decimal)

DELAY:  DCR C           ; Decrement inner counter (4 T)
        JNZ DELAY       ; Jump back if not zero (10 T if loop, 7 T if exit)

        MOV A, B        ; Move the decremented value of B to Accumulator
        OUT 00H         ; Send Accumulator value to Output Port 00H

        JMP NEXT        ; Infinite loop back to NEXT