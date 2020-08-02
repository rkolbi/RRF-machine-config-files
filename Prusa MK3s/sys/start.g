; Executed before each print - BEFORE ANY SLICER CODE IS RAN

;M280 P0 S160                       ; BLTouch, alarm release
;G4 P100                            ; BLTouch, delay for release command

G28                                 ; Home all
G1 Z100                             ; Last chance to check nozzle cleanliness
M220 S100                           ; Set speed factor back to 100% in case it was changed
M221 S100                           ; Set extrusion factor back to 100% in case it was changed
M290 R0 S0                          ; Clear babystepping
M106 S0                             ; Turn part cooling blower off if it is on
M703                                ; Execute loaded filement's config.g
G1 X0 Y0 Z2                         ; Final position before slicer's temp is reached and primeline is printed.
                                    ; primeline macro is executed by the slicer gcode to enable direct printing
                                    ; of the primeline at the objects temp and to immediately print the object
                                    ; following primeline completion. 

; Slicer generated gcode takes it away from here