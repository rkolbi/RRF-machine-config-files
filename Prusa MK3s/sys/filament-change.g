;
; called when a print from SD card runs out of filament

M25
G91                                              ; Relative Positioning
G1 Z20 F360                                      ; Raise Z
G90                                              ; Absolute Values
G1 X200 Y0 F6000                                 ; Parking Position
M300 S800 P8000                                  ; play beep sound

M98 P"0:/macros/Filament Handling"; unload
M400

M291 P"Press OK to recommence print." R"Filament Handling" S2


M98 P"0:/macros/Heat Nozzle"; Get nozzle hot and continue print