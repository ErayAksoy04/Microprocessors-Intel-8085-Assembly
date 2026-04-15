; ==============================================================================
; Project: Dynamic Matrix Addition
; Description: Reads matrix dimensions (Rows and Columns) from memory, calculates
;              the total number of elements (N), and adds two N-element matrices.
;              Stores the resulting matrix at a specified destination address.
; ==============================================================================

#ORG 2000H

; --- 1. Fetch Dimensions & Calculate Total Elements (N) ---
        LXI H, 0101H    ; HL points to Column count address
        MOV E, M        ; Load Column count into E
        MVI D, 00H      ; DE = Column Count (16-bit format)
        DCX H           ; HL points to Row count address (0100H)
        MOV C, M        ; Load Row count into C (Loop Counter)

        MOV A, C
        ORA A
        JZ FINISH       ; If Row count is 0, exit
        MOV A, E
        ORA A
        JZ FINISH       ; If Column count is 0, exit

        LXI H, 0000H    ; Clear HL to accumulate the product (N)
MUL_LOOP: DAD D         ; HL = HL + DE (Add Columns)
        DCR C           ; Decrement Row counter
        JNZ MUL_LOOP    ; Repeat until Row counter is 0

        MOV B, H        ; Move total element count (N) high byte to B
        MOV C, L        ; Move total element count (N) low byte to C (BC = Loop Counter)

; --- 2. Pointer Setup ---
        LXI D, 2000H    ; DE = Base address of 1st Matrix
        DAD D           ; HL = 2000H + N (Base address of 2nd Matrix)
        XCHG            ; Swap HL and DE.
                        ; Now: HL = 1st Matrix, DE = 2nd Matrix

; --- 3. Matrix Addition & Storage ---
ADD_LOOP: LDAX D        ; Load element from 2nd Matrix into A
        ADD M           ; Add element from 1st Matrix (pointed by HL) to A

        PUSH H          ; Save 1st Matrix pointer to Stack
        PUSH D          ; Save 2nd Matrix pointer to Stack

        LXI D, 1000H    ; Offset for destination (3000H - 2000H = 1000H)
        DAD D           ; HL now points to the target address in 3000H region
        MOV M, A        ; Store the sum in the destination matrix

        POP D           ; Restore 2nd Matrix pointer
        POP H           ; Restore 1st Matrix pointer

        INX H           ; Move to next element in 1st Matrix
        INX D           ; Move to next element in 2nd Matrix
        DCX B           ; Decrement total element counter (N)

        MOV A, B
        ORA C
        JNZ ADD_LOOP    ; Continue if BC is not zero

FINISH: HLT             ; Halt the processor