; 0:/sys/homex.g
; Home the X axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

G91                                                        ; Set relative positioning.
G1 Z3 F800 H2                                              ; Lift the Z axis 3mm.

G1 H0 X5 F1000                                             ; Move slowly away. 
G1 H1 X-255 F3000                                          ; Move quickly to the X endstop. 
G1 H0 X5 F1000                                             ; Move slowly away. 
G1 H1 X-255 F3000                                          ; Move quickly to the X endstop, the second check.

G1 Z-3 F800 H2                                             ; Place Z axis back to the starting position.
