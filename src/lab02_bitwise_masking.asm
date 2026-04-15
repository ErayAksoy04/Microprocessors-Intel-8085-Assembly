; ==============================================================================
; Project: Intel 8085 Bitwise Manipulation
; Description: Reads data from a specific memory address (derived from the
;              student ID), applies bitwise masking (AND/OR) to manipulate
;              specific bits, stores the result in a symmetric memory address,
;              and outputs the result to a hardware port.
; ==============================================================================

START:
        LDA 1997H   ; Load Accumulator (A) directly with the data at memory address 1997H
                    ; (Address 1997H is uniquely derived from the Student ID)

        ANI 39H     ; Logical AND with 39H (0011 1001B)
                    ; Applies a mask to preserve the bits at positions 5, 4, 3, and 0,
                    ; while clearing (resetting to 0) all the remaining bits.

        ORI 82H     ; Logical OR with 82H (1000 0010B)
                    ; Applies a mask to forcefully set (change to 1) the bits at
                    ; positions 7 and 1, without affecting the preserved bits.

        STA 7991H   ; Store the modified Accumulator data directly into memory address 7991H
                    ; (Address 7991H is the symmetric counterpart of 1997H)

        OUT 01H     ; Send the final manipulated data byte to Output Port 01H

        HLT         ; Halt the microprocessor execution