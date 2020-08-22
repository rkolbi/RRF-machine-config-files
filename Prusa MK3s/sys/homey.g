; 0:/sys/homey.g
; Home the Y axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

G91                                                        ; Set relative positioning.
G1 Z3 F800 H2                                              ; Lift the Z axis 3mm.  

G1 H0 Y5 F1000                                             ; Move slowly away. 
G1 H1 Y-215 F3000                                          ; Move quickly to the Y endstop. 
G1 H0 Y5 F1000                                             ; Move slowly away. 
G1 H1 Y-215 F3000                                          ; Move quickly to the Y endstop, second check.

G1 Z-3 F800 H2                                             ; Place Z back to the starting position.
