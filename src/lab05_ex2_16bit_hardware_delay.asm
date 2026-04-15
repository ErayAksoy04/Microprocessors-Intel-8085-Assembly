; ==============================================================================
; Project: 16-Bit Hardware Delay Routine
; Description: A massive delay loop utilizing the 16-bit BC register pair.
;              Uses dummy instructions (XTHL, NOP) to intentionally consume
;              T-States, generating a ~52.34 ms delay at 8.4 MHz.
; Clock Freq : 8.4 MHz
; ==============================================================================

#ORG 2000H

START:  LXI B, 2C0AH    ; Load BC pair with loop counter (2C0AH = 11274 dec)

DELAY:  DCX B           ; Decrement BC (6 T)
        DCX B           ; Decrement BC again (6 T) -> Total -2 per iteration

        XTHL            ; Dummy Stack operation to burn time (16 T)
        XTHL            ; Dummy Stack operation (16 T)

        NOP             ; No Operation (4 T)
        NOP             ; No Operation (4 T)
        NOP             ; No Operation (4 T)
        NOP             ; No Operation (4 T)

        ; 16-bit Zero Check (Since DCX doesn't affect Zero Flag)
        MOV A, C        ; Move lower byte (C) to Accumulator
        ORA B           ; Logical OR with higher byte (B). Result is 0 only if BC is 0000H
        JNZ DELAY       ; Jump back if BC is not zero

        HLT             ; Halt processor