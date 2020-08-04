; 0:/sys/stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

M83                                                        ; Set extruder to relative mode
M104 S-273                                                 ; Turn off hotend
M140 S-273                                                 ; Turn off heatbed
M107                                                       ; Turn off fan
G1 F1000.0                                                 ; Set feed rate
G1 E-2                                                     ; Retract
G1 X110 Y200 Z205 F3000                                    ; Place nozzle center/top
M400                                                       ; Clear queue
G1 X0 Y215 F1000                                           ; Place nozzle to left side, build plate to front
M18 YXE                                                    ; Unlock X, Y, and E axis

; Play a triumphant tune to celebrate a successful print.
G4 S1
M300 P250 S750
G4 P251
M300 P200 S1250
G4 P201
M300 P250 S750
G4 P251
M300 P200 S1250
G4 P201
M300 P250 S2500
G4 P251
M300 P150 S2000
G4 P151
M300 P150 S2500
G4 P151
M300 P350 S3700
G4 P351
M400
