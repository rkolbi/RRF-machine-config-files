; Executed before each print
;M280 P0 S160                       ; BLTouch, alarm release
;G4 P100                            ; BLTouch, delay for release command
M220 S100                           ; Set speed factor back to 100% in case it was changed
M221 S100                           ; Set extrusion factor back to 100% in case it was changed
M290 R0 S0                          ; Clear babystepping
M106 S0                             ; Turn part cooling blower off if it is on