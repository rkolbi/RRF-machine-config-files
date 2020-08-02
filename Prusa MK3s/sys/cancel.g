; 0:/sys/cancel.g
; called when a print is canceled after a pause.

M83
M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
G1 F1000.0                                                 ; set feed rate
G1 E-2                                                     ; retract
M18 YXE                                                    ; unlock X, Y, E axis
