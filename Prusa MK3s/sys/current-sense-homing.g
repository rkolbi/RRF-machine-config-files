; 0:/sys/current-sense-homing.g
; Current and Sensitivity for homing routines

M915 X S2 F0 H400 R0                                       ; Set X axis Sensitivity
M915 Y S2 F0 H400 R0                                       ; Set y axis Sensitivity
M913 X30 Y30 Z60                                           ; set X Y Z motors to X% of their normal current