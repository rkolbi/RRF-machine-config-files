; 0:/sys/filament-change.g
; called when a print from SD card runs out of filament

M25
G91                                                        ; Relative Positioning
G1 Z20 F360                                                ; Raise Z
G90                                                        ; Absolute Values
G1 X200 Y0 F6000                                           ; Parking Position
M300 S800 P8000                                            ; play beep sound

M98 P"0:/macros/Filament Handling"                         ; unload and load filament using macro       
M400                                                       ; clear moves

M291 P"Press OK to recommence print." R"Filament Handling" S2

M98 P"0:/macros/Heat Nozzle"                               ; Get nozzle hot and continue print
M116                                                       ; wait for all temperatures - shouldn't need this but just incase
M121                                                       ; Recover the last state pushed onto the stack