; 0:/sys/stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

M83                                                        ; Set extruder to relative mode
M106 S255                                                  ; Turn fan fully on
G1 E-2                                                     ; Retract 2mm
M104 S-273                                                 ; Turn off hotend
M140 S-273                                                 ; Turn off heatbed
G1 F1000.0                                                 ; Set feed rate
M98 P"current-sense-homing.g"                              ; Adjust current and sensitivity for homing routines
G91                                                        ; Set to Relative Positioning
G1 Z2 F400                                                 ; Move Z up 1mm
G4 S6                                                      ; Wait for 6 seconds for filament to solidify
G1 X1 Y1 F1000                                             ; Wiggle +1mm
G1 X-1 Y-1 F1000                                           ; Wiggle -1mm
G1 X0 Y0 F1000                                             ; Wiggle back
G90                                                        ; Set to Absolute Positioning
G1 X0 Y215 Z205 F1000                                      ; Place nozzle to left side, build plate to front, Z at top
M400                                                       ; Clear queue
M107                                                       ; Turn off fan
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
