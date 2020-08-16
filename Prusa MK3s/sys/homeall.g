; 0:/sys/homeall.g
; home x, y, and z-axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release
G4 P100                                                    ; BLTouch, delay for release command

G91                                                        ; relative positioning
G1 Z3 F800 H2                                              ; lift Z relative to current position

; HOME X
G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop 
G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop, a second check 

; HOME Y
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop 
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstops, a second check

; HOME Z
G1 H2 Z2 F2600                                             ; raise head 2mm to ensure it is above the Z probe trigger height
G90                                                        ; back to absolute mode
G1 X105 Y105 F6000                                         ; go to probe point

M558 F1000 A1                                              ; fast z-probe, first pass  
G30                                                        ; home Z by probing the bed
G1 H0 Z5 F400                                              ; lift Z to the 5mm position

M558 F50 A5 S-1                                            ; slow z-probe, take 5 probes and yield average
G30                                                        ; home Z by probing the bed
G1 H0 Z5 F400                                              ; lift Z to the 5mm position

M558 F200 A1                                               ; normal z-probe, set to normal speed  