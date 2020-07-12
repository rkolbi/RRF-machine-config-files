; sleep.g
; called when M1 (Sleep) is being processed

M104 S0                                            ; turn off temperature
M140 S0                                            ; turn off heatbed
M107                                               ; turn off fan
M18 XEZY                                           ; unlock all axis