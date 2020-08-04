; 0:/sys/sleep.g
; called when M1 (Sleep) is being processed

M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
M18 XEZY                                                   ; unlock all axis
