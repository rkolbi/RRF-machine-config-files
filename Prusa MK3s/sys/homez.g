; 0:/sys/homez.g
; home the z axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release
G4 P100                                                    ; BLTouch, delay for the release command

G91                                                        ; relative positioning
G1 H0 Z3 F6000                                             ; lift Z relative to the current position
G90                                                        ; absolute positioning

G1 X105 Y105 F6000                                         ; go to probe point

M558 P9 C"^zprobe.in" H5 F800 T8000                        ; BLTouch, connected to Z probe IN pin - fast
G30                                                        ; home Z by probing the bed
M558 P9 C"^zprobe.in" H5 F60 T6000 A10 R0.75 S0.003        ; BLTouch, connected to Z probe IN pin - slow
G30                                                        ; home Z by probing the bed
M558 P9 C"^zprobe.in" H5 F200 T8000                        ; BLTouch, connected to Z probe IN pin - normal

G1 H0 Z5 F400                                              ; lift Z to the 5mm position