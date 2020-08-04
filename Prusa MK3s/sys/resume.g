; 0:/sys/resume.g
; called before a print from SD card is resumed

G1 E3 F3000                                                ; extract 3mm of filament
G1 R1 X0 Y0 Z5                                             ; go back to the last print position with Z 5mm above
G1 R1 Z0                                                   ; go to Z position of the last print move
M121                                                       ; Recover the last state pushed onto the stack
