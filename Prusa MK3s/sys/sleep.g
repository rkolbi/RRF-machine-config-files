; 0:/sys/sleep.g
; Called when M1 (Sleep) is being processed.

M104 S-273                                                 ; Turn off the hotend.
M140 S-273                                                 ; Turn off the heatbed.
M107                                                       ; Turn off the part cooling fan.
M400                                                       ; Finish all moves, clear the buffer.
M18 XEZY                                                   ; Unlock all axis.
