; 0:/sys/homez.g
; home the z axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release
G4 P100                                                    ; BLTouch, delay for release command

G91                                                        ; relative positioning
G1 H0 Z3 F6000                                             ; lift Z relative to current position
G90                                                        ; absolute positioning

G1 X15 Y15 F6000                                           ; go to first probe point
G30                                                        ; home Z by probing the bed

G90                                                        ; absolute positioning
G1 H0 Z5 F400                                              ; lift Z relative to current position