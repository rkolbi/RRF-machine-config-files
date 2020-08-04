; 0:/sys/homey.g
; home the y axis

M98 P"current-sense-homing.g"                              ; Current and Sensitivity for homing routines

G91                                                        ; relative positioning

G1 Z3 F800 H2                                              ; lift Z relative to current position
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop 
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop, second check

G1 Z-3 F800 H2                                             ; place Z back to starting position

M98 P"current-sense-normal.g"                              ; Current and Sensitivity for normal routine