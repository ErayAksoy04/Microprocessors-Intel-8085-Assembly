; ==============================================================================
; Project: Overlapping Memory Block Transfer
; Description: Safely copies a 10-byte block of data where the source (D150-D159)
;              and destination (D155-D15E) memory regions overlap. To prevent
;              data corruption, the transfer is executed backwards (end to start).
; ==============================================================================

#ORG 2000H
#BEGIN 2000H

START:  LXI H, D159H    ; Load HL pair with the end address of the source block
        LXI D, D15EH    ; Load DE pair with the end address of the destination block
        MVI C, 0AH      ; Initialize loop counter C with 10 (0AH bytes to transfer)

LOOP:   MOV A, M        ; Read the byte from the current source address (HL)
        STAX D          ; Write the byte to the current destination address (DE)
        DCX H           ; Decrement source pointer
        DCX D           ; Decrement destination pointer
        DCR C           ; Decrement loop counter
        JNZ LOOP        ; If counter is not zero, jump back to LOOP

        HLT             ; Halt the processor