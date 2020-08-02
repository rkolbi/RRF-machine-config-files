; 0:/sys/cancel.g
; called when a print is canceled after a pause.

M83
M104 S0                                                    ; turn off temperature
M140 S0                                                    ; turn off heatbed
M107                                                       ; turn off fan
G1 F1000.0                                                 ; set feed rate
G1 E-2                                                     ; retract
M18 YXE                                                    ; unlock X, Y, E axis