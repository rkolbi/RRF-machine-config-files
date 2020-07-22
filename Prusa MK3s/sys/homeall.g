;M280 P0 S160                                      ; BLTouch, alarm release
;G4 P100                                           ; BLTouch, delay for release command

M915 X S2 F0 H400 R0                               ; Set X axis Sensitivity
M915 Y S2 F0 H400 R0                               ; Set y axis Sensitivity
M913 X20 Y20 Z60                                   ; set X Y Z motors to X% of their normal current
 
G91                                                ; relative positioning

G1 Z3 F800 H2                                      ; lift Z relative to current position


; HOME X
G1 H0 X5 F1000                                     ; move slowly away 
G1 H1 X-255 F3000                                  ; move quickly to X endstop 

G1 H0 X5 F1000                                     ; move slowly away 
G1 H1 X-255 F3000                                  ; move quickly to X endstop, second check 


; HOME Y
G1 H0 Y5 F1000                                     ; move slowly away 
G1 H1 Y-215 F3000                                  ; move quickly to Y endstop 

G1 H0 Y5 F1000                                     ; move slowly away 
G1 H1 Y-215 F3000                                  ; move quickly to Y endstops, second check


; HOME Z
G1 H2 Z2 F2600                                     ; raise head 2mm to ensure it is above the Z probe trigger height
G90                                                ; back to absolute mode
G1 X15 Y15 F6000                                   ; go to first probe point
G30                                                ; home Z by probing the bed

; Uncomment the following lines to lift Z after probing
G91                                                ; relative positioning
G1 H0 Z5 F400                                      ; lift Z relative to current position
G90                                                ; absolute positioning
M913 Z100

M913 X100 Y100 Z100                                ; set X Y Z motors to 100% of their normal current
M915 X S3 F0 H200 R0                               ; Set X axis Sensitivity
M915 Y S3 F0 H200 R0                               ; Set y axis Sensitivity