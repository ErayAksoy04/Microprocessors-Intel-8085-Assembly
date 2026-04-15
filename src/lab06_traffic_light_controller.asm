; ==============================================================================
; Project: Traffic Light Controller (State Machine & Hardware Delay)
; Description: Simulates a synchronized traffic light system for vehicles and
;              pedestrians using specific hardware I/O ports. Utilizes a highly
;              precise 1-second hardware delay subroutine dynamically scaled by
;              parameter register C to manage state durations.
;
; Hardware Ports Configuration:
;   Port 01H : Vehicle RED
;   Port 02H : Vehicle YELLOW
;   Port 03H : Vehicle GREEN
;   Port 04H : Pedestrian GO (Green)
;   Port 05H : Pedestrian STOP (Red)
;
; Clock Frequency: 2.5 MHz (1 T-State = 0.4 us)
; Reference Delay: ~2,500,000 T-States = 1 Second
; ==============================================================================

#ORG 0000H

START:
; ==============================================================================
; --- STATE 1: Vehicles RED, Pedestrians GO (Duration: 20s) ---
; ==============================================================================
        ; 1. Clear previous lights (Vehicle Green, Pedestrian Stop)
        MVI A, 00H
        OUT 03H         ; Turn OFF Vehicle Green (Port 03H)
        OUT 05H         ; Turn OFF Pedestrian Stop (Port 05H)

        ; 2. Set current lights
        MVI A, 01H
        OUT 01H         ; Turn ON Vehicle Red (Port 01H)
        OUT 04H         ; Turn ON Pedestrian Go (Port 04H)

        ; 3. Wait for 20 seconds
        MVI C, 14H      ; Parameter: C = 20 (14H in Hex)
        CALL DELAY_1S   ; Call 1-second delay subroutine (Loops C times)

; ==============================================================================
; --- STATE 2: Vehicles YELLOW, Pedestrians STOP (Duration: 5s) ---
; ==============================================================================
        ; 1. Clear previous lights (Vehicle Red, Pedestrian Go)
        MVI A, 00H
        OUT 01H         ; Turn OFF Vehicle Red (Port 01H)
        OUT 04H         ; Turn OFF Pedestrian Go (Port 04H)

        ; 2. Set current lights
        MVI A, 01H
        OUT 02H         ; Turn ON Vehicle Yellow (Port 02H)
        OUT 05H         ; Turn ON Pedestrian Stop (Port 05H)

        ; 3. Wait for 5 seconds
        MVI C, 05H      ; Parameter: C = 5
        CALL DELAY_1S

; ==============================================================================
; --- STATE 3: Vehicles GREEN, Pedestrians STOP (Duration: 15s) ---
; ==============================================================================
        ; 1. Clear previous lights (Vehicle Yellow)
        MVI A, 00H
        OUT 02H         ; Turn OFF Vehicle Yellow (Port 02H)

        ; 2. Set current lights
        MVI A, 01H
        OUT 03H         ; Turn ON Vehicle Green (Port 03H)
        OUT 05H         ; Turn ON Pedestrian Stop (Redundant but safe)

        ; 3. Wait for 15 seconds
        MVI C, 0FH      ; Parameter: C = 15 (0FH in Hex)
        CALL DELAY_1S

        JMP START       ; Infinite loop back to State 1


; ==============================================================================
; --- SUBROUTINE: DELAY_1S ---
; Parameter: Register C (Number of seconds to wait)
; Details  : Uses nested loops (Inner: ~25,000 T-states, Outer: 100 iterations)
;            to achieve exactly 1 second (~2,500,000 T-states) per 'C' decrement.
; ==============================================================================
DELAY_1S:
        PUSH D          ; Backup DE pair
        PUSH H          ; Backup HL pair
        PUSH B          ; Backup BC pair

SEC_LOOP:
        LXI H, 0064H    ; Outer loop counter = 100 (0064H)
OUT_LOOP:
        LXI D, 0411H    ; Inner loop counter = 1041 (0411H)
IN_LOOP:
        DCX D           ; Decrement DE (6 T)
        MOV A, D        ; Move D to A (4 T)
        ORA E           ; Logical OR with E (4 T)
        JNZ IN_LOOP     ; Jump if DE not zero (10/7 T)
                        ; Inner loop total: ~24,984 T-States

        DCX H           ; Decrement HL (6 T)
        MOV A, H        ; Move H to A (4 T)
        ORA L           ; Logical OR with L (4 T)
        JNZ OUT_LOOP    ; Jump if HL not zero (10/7 T)
                        ; Outer loop total: 100 * ~25k = ~2,500,000 T-States (1s)

        DCR C           ; Decrement seconds parameter (4 T)
        JNZ SEC_LOOP    ; If not zero, wait another second (10/7 T)

        POP B           ; Restore BC pair
        POP H           ; Restore HL pair
        POP D           ; Restore DE pair
        RET             ; Return to Main Program