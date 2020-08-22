; 0:/filaments/ABS/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                    ; Play some tones  
M140 S75                                                   ; Set the bed temperature to 75c  
M104 S150                                                  ; Set the extruder warm-up temperature to 150c  
                                                           ; Note: actual extruder temperature will be set from the slicer  

; Insert additional filament specific settings here
