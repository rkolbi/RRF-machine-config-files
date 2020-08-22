; 0:/sys/resume.g
; Called before a print from SD card is resumed

M98 P"current-sense-normal.g"                              ; Ensure the drivers current and sensitivity is set for normal routines.
G1 E3 F400                                                 ; Extract 3mm of filament.
G1 R1 X0 Y0 Z5                                             ; Go back to the last print position with Z 5mm above.
G1 R1 Z0                                                   ; Go to Z position of the last print move.
M121                                                       ; Recover the last state pushed onto the stack.
