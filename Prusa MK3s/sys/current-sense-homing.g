; 0:/sys/current-sense-homing.g
; Set the current and sensitivity for homing, non-printing, routines

M915 X S2 F0 H400 R0                                       ; Set the X axis sensitivity.
M915 Y S2 F0 H400 R0                                       ; Set the Y axis sensitivity.
M913 X30 Y30 Z60                                           ; Set the X, Y, and Z drivers current percentage for non-print moves, per config.g.