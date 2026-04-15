; ==============================================================================
; Project: Array Filtering and Statistics
; Description: Iterates through an array until a termination character (0DH).
;              Filters out null/space characters (00H) and copies valid data to a
;              new location. Records initial length, final length, and spaces count.
; ==============================================================================

#ORG 2000H

; --- 1. Pointer and Counter Initialization ---
        LXI H, 2050H    ; HL = Source array base address
        LXI D, 3000H    ; DE = Destination array base address
        MVI B, 00H      ; B = Initial length counter (Set to 0)
        MVI C, 00H      ; C = Final length counter (Set to 0)

; --- 2. Read and Filter Loop ---
LOOP:   MOV A, M        ; Load current character into A
        CPI 0DH         ; Check if it is the terminator character (0DH)
        JZ FINISH       ; If terminator, jump to statistics calculation

        INR B           ; Increment initial length counter
        CPI 00H         ; Check if the character is a space/null (00H)
        JZ SKIP         ; If it is a space, skip copying

        STAX D          ; Copy valid character to destination address
        INX D           ; Increment destination pointer
        INR C           ; Increment final length counter

SKIP:   INX H           ; Increment source pointer
        JMP LOOP        ; Repeat for the next character

; --- 3. Statistics Calculation and Storage ---
FINISH: MOV A, B
        STA 4000H       ; Store Initial Length at 4000H

        MOV A, C
        STA 4001H       ; Store Final Length at 4001H

        MOV A, B
        SUB C           ; Calculate removed spaces: A = Initial - Final
        STA 4002H       ; Store Spaces Count at 4002H

        HLT             ; Halt the processor