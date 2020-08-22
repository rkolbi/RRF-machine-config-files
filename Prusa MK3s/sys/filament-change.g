; 0:/sys/filament-change.g
; Called when a print from SD card runs out of filament

M25
G91                                                        ; Set relative positioning.
G1 Z20 F360                                                ; Raise the Z axis 20mm.
G90                                                        ; Set absolute positioning.
G1 X200 Y0 F6000                                           ; Go to the parking position.
M300 S800 P8000                                            ; Play a beep sound.

M98 P"0:/macros/Filament Handling"                         ; Unload and load filament using the macro.       
M400                                                       ; Finish all moves, clear the buffer.

M291 P"Press OK to recommence print." R"Filament Handling" S2

M98 P"0:/macros/Heat Nozzle"                               ; Get nozzle hot to continue the print.
M116                                                       ; Wait for all temperatures, shouldn't need this but just incase.
M121                                                       ; Recover the last state pushed onto the stack.