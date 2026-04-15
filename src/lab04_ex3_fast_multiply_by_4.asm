; ==============================================================================
; Project: Fast Multiplication by 4 (Shift via Addition)
; Description: Multiplies an 8-bit number by 4 without a dedicated multiply
;              instruction by utilizing repeated addition (A = A + A), which
;              effectively acts as a logical left shift.
; ==============================================================================

#ORG 2000H

        LDA B000H       ; Load the data from memory address B000H into A
        ADD A           ; A = A + A (Effectively multiplies by 2 / Shift Left 1)
        ADD A           ; A = A + A (Effectively multiplies by 4 / Shift Left 2)
        STA C000H       ; Store the multiplied result at memory address C000H
        HLT             ; Halt the processor