M915 X S2 F0 H400 R0                               ; Set X axis Sensitivity
M915 Y S2 F0 H400 R0                               ; Set y axis Sensitivity
M913 X20 Y20 Z60                                   ; set X Y Z motors to X% of their normal current

G91                                                ; relative positioning

G1 Z3 F800 H2                                      ; lift Z relative to current position
G1 H0 Y5 F1000                                     ; move slowly away 
G1 H1 Y-215 F3000                                  ; move quickly to Y endstop 

G1 H0 Y5 F1000                                     ; move slowly away 
G1 H1 Y-215 F3000                                  ; move quickly to Y endstop, second check

G1 Z-3 F800 H2                                     ; place Z back to starting position