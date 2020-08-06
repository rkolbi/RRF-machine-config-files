; 0:/sys/cancel.g
; called when a print is canceled after a pause.

M83                                                        ; Makes the extruder interpret extrusion values as relative positions
M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
G1 F1000.0                                                 ; set feed rate
G1 E-2                                                     ; retract 2mm
M98 P"current-sense-homing.g"                              ; Set current and sensitivity for homing routines
M18 YXE                                                    ; unlock X, Y, E axis
