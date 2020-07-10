; resume.g
; called before a print from SD card is resumed

G1 R1 X0 Y0 Z5 F8000 		; go to 5mm above position of the last print move
G1 R1 X0 Y0          		; go back to the last print move
;G1 E2 F1000 				; Feed 70mm of filament at 800mm/min
M83                  		; relative extruder moves


