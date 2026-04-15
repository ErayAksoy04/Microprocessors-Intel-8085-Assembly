; ==============================================================================
; Project: Exact Microsecond Delay Calculation
; Description: A highly precise delay loop engineered to execute in exactly
;              2486 T-States, resulting in a perfect 1.2 microsecond delay
;              on a 2.072 GHz processor. Includes cycle-padding (NOP).
; Clock Freq : 2.072 GHz
; ==============================================================================

#ORG 2000H

START:  MVI B, B1H      ; Load loop counter (B1H = 177 dec) (7 T)
        NOP             ; Padding instruction to hit EXACT T-State target (4 T)

LOOP:   DCR B           ; Decrement counter (4 T)
        JNZ LOOP        ; Jump if not zero (10/7 T)

        HLT             ; Halt processor