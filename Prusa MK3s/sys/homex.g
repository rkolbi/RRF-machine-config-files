M915 X S2 F0 H400 R0                               ; Set X axis Sensitivity
M915 Y S2 F0 H400 R0                               ; Set y axis Sensitivity
M913 X45 Y45 Z100                                  ; set X Y Z motors to 50% of their normal current

G91                                                ; relative positioning

G1 Z3 F800 H2                                      ; lift Z relative to current position

G1 H0 X5 F1000                                     ; move slowly away 
G1 H1 X-255 F3000                                  ; move quickly to X endstop 

G1 H0 X5 F1000                                     ; move slowly away 
G1 H1 X-255 F3000                                  ; move quickly to X endstop, second check