; 0:/sys/homez.g
; Home the Z axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release.
G4 P100                                                    ; BLTouch, delay for the release command.

G91                                                        ; Set relative positioning.
G1 H0 Z3 F6000                                             ; Lift Z axis 3mm.
G90                                                        ; Set absolute positioning.

G1 X105 Y105 F6000                                         ; Go to the center of the bed for probe point.

M558 F1000 A1                                              ; Set probing speed to fast for the first pass.  
G30                                                        ; Perform Z probing.
G1 H0 Z5 F400                                              ; Lift Z axis to the 5mm position.

M558 F50 A5 S-1                                            ; Set probing speed to slow for second pass, take 5 probes and yield the average.
G30                                                        ; Perform Z probing.
G1 H0 Z5 F400                                              ; Lift Z axis to the 5mm position.

M558 F200 A1                                               ; Set normal z-probe speed.  