; 0:/sys/homex.g
; home the x axis

if state.status = "processing"                             ; Printer is currently printing!
   M99                                                     ; Exit this macro

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

G91                                                        ; relative positioning

G1 Z3 F800 H2                                              ; lift Z relative to current position

G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop 

G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop, second check

G1 Z-3 F800 H2                                             ; place Z back to starting position
