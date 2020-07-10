; stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)
;

M83
M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan
G1 F1000.0 ; set feed rate
G1 E-2 ; retract
M18 YXE

