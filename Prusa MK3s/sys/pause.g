; 0:/sys/pause.g
; Called when a print from SD card is paused

M120                                                       ; Push the state of the machine onto the memory stack.

if sensors.filamentMonitors[0].filamentPresent = false
   G1 E-3 F1000                                            ; If the filament has run out, retract 6mm of filament.

M83                                                        ; Set relative extruder moves.
G1 E-3 F3000                                               ; Retract 3mm of filament.
G91                                                        ; Set relative positioning.
G1 Z10 F360                                                ; Raise Z 10 mm.
G90                                                        ; Set absolute positioning.
G1 X10 Y0 F6000                                            ; Move to the parking position.
M300 S80 P2000                                             ; Play a beep sound.
