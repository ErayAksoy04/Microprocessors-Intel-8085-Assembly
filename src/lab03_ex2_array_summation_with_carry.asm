; ==============================================================================
; Project: Dynamic Array Summation (16-bit Result)
; Description: Iterates through an array of 8-bit integers starting at EE50H until
;              an 'FF' terminator is found. Calculates the total sum, handling
;              arithmetic carry to produce a 16-bit result. Outputs the high byte
;              to Port 02 and the low byte to Port 01.
; ==============================================================================

#ORG 2000H

START:  LXI H, EE50H    ; Load HL pair with the starting address of the array
        MVI B, 00H      ; Initialize B to 0 (Used to store the High Byte / Carry)
        MVI C, 00H      ; Initialize C to 0 (Used to store the Low Byte of the sum)

LOOP:   MOV A, M        ; Load current array element into Accumulator
        CPI FFH         ; Compare with FFH (End of array marker)
        JZ OUTPUT       ; If element is FFH, exit loop and jump to OUTPUT

        ADD C           ; Add the current Low Byte (C) to Accumulator (A)
        MOV C, A        ; Store the new intermediate sum back into C
        JNC NEXT        ; If there is no carry, skip the increment
        INR B           ; If carry exists, increment the High Byte (B)

NEXT:   INX H           ; Point to the next element in the array
        JMP LOOP        ; Repeat the process

OUTPUT: MOV A, B        ; Move High Byte to Accumulator
        OUT 02H         ; Send High Byte to Port 02H
        MOV A, C        ; Move Low Byte to Accumulator
        OUT 01H         ; Send Low Byte to Port 01H
        HLT             ; Halt the processor

; --- Data Segment ---
#ORG EE50H
#DB C8H, 6CH, 75H, 59H, A9H, F4H, 78H, 7FH, FFH