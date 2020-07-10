;
; called when a print from SD card runs out of filament

M25
G91 					; Relative Positioning
G1 Z20 F360				; Raise Z
G90 					; Absolute Values
G1 X200 Y0 F6000 		; Parking Position
M300 S800 P8000 		; play beep sound



M98 Pejectfilament.g
M400
;M98 Ploadfilament.g
;M400
;M98 PLoadtoNozzle.g
;M400
;M98 Psensoron.g
;M400



