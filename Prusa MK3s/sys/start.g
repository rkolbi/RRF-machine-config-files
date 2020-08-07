; 0:/sys/start.g
; Executed before each print - BEFORE ANY SLICER CODE IS RAN
; Alternative Start.g - This loads the heightmap as filament type prefixed to the file name (PETG-heightmap.csv)
; if the heightmap does not exist, create one, and then save with filamnet type prefixed to the file name - as above
 
T0                                                         ; Ensure tool is selected
;M280 P0 S160                                              ; BLTouch, alarm release
;G4 P100                                                   ; BLTouch, delay for release command
M572 D0 S0.0                                               ; clear pressure advance
M220 S100                                                  ; Set speed factor back to 100% in case it was changed
M221 S100                                                  ; Set extrusion factor back to 100% in case it was changed
M290 R0 S0                                                 ; Clear babystepping
M106 S0                                                    ; Turn part cooling blower off if it is on
M703                                                       ; Execute loaded filement's config.g
G28                                                        ; Home all

; if using BLTouch probe, use the following line:
G1 Z100                                                    ; Last chance to check nozzle cleanliness
; if using Pinda type probe, use the following line to place probe center of bed to heat the probe
;G1 Z5 X100 Y100                                           ; Place nozzle center of bed, 5mm up

M116                                                       ; wait for all temperatures
G4 S30                                                     ; wait additional 30 seconds for bed to stabilize
G32                                                        ; Level bed
G29 S1 [P{move.extruders[0].filament^"-heightmap.csv"}]    ; Load bed mesh for system filament type
if result > 1                                              ; If file doesn't exist, perform mesh and save
   G29                                                     ; Perform mesh now
   G29 S3 [P{move.extruders[0].filament^"-heightmap.csv"}] ; Save mesh with filament type prefixed
G90                                                        ; Absolute Positioning
M83                                                        ; Extruder relative mode
M98 P"0:/sys/current-sense-normal.g"                       ; Ensure that motor currents and sense are set for printing 
G1 X0 Y0 Z2                                                ; Final position before slicer's temp is reached and primeline is printed.
 
; The primeline macro is executed by the slicer gcode to enable direct printing
; of the primeline at the objects temp and to immediately print the object
; following primeline completion. 
 
; Slicer generated gcode takes it away from here
