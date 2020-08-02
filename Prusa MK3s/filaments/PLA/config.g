M300 S1000 P200 G4 P500 M300 S3000 P300

M572 D0 S0.0                             ; set pressure advance

M140 S65                                 ; set bed temp
M104 S150                                ; set extruder temp
M190 S65                                 ; wait for bed temp
M109 S150                                ; wait for extruder temp
G32                                      ; Level bed
G29                                      ; Bed mesh
G90                                      ; Absolute Positioning
M83                                      ; Extruder relative mode