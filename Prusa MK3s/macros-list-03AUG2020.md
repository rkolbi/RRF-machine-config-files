**Filament Handling**

```
; 0:/macros/Filament Handling
; Macro used for all filament handling evolutions

if state.status != "processing"

   ; Printer is not currently printing!

   if sensors.filamentMonitors[0].filamentPresent = true
   
      M291 P"Press OK to begin filament UNLOADING, else press CANCEL to exit." R"Filament Handling" S3
      M291 P"Please wait while the nozzle is being heated." T5 ; Display message
      M98 P"0:/macros/Heat Nozzle"; heat nozzle to predetermined temp
      M291 P"Ready for filament unloading. Gently pull filament and press OK." R"Filament Handling" S2
      M291 P"Retracting filament..." T5 ; Display another message
      G1 E-150 F5000 ; Retract filament
      M400 ; Wait for the moves to finish
      T0 M702
      M84 E0 ; Turn off extruder
      G10 S0 ; Turn off the heater
      M98 P"0:/macros/Filament Handling"; run again

   else

      M291 P"Press OK to begin filament LOADING, else press CANCEL to exit." R"Filament Handling" S3
      M291 P"Please wait while the nozzle is being heated." T5 ; Display message
      M98 P"0:/macros/Heat Nozzle"; heat nozzle to predetermined temp
      M291 P"Ready for filament loading. Insert filament and press OK." R"Filament Handling" S2
      M291 P"Feeding filament..." T5 ; Display new message
      G1 E150 F450 ; Feed 150mm of filament at 600mm/min
      G1 E20 F100 ; Feed 20mm of filament at 100mm/min
      G4 P1000 ; Wait one second
      G1 E-1 F1800 ; Retract 10mm of filament at 1800mm/min
      M400 ; Wait for moves to complete
      M98 P"0:/sys/filaset"
      M400 ; Wait for moves to complete
      M84 E0 ; Turn off extruder
      G10 S0 ; Turn off the heater

else

   M291 P"Press OK to begin filament CHANGE, else press CANCEL to exit." R"Filament Handling" S3
   M98 P"0:/sys/filament-change.g" ; call filament-change.g
   M24
```
**Heat Nozzle**

```
; 0:/macros/Heat Nozzle
; Macro used to heat hozzle to temperture set by "Set Filament Type" macro

M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T5
T0 
M104 S230                           
M109 S230                           
```
**Set Filament Type**

```
; 0:/macros/Set Filament Type
; Macro used to set system's loaded filament type

if sensors.filamentMonitors[0].filamentPresent = false  

  M291 P"Press OK to change filament type, else press CANCEL to exit." R"Filament Handling" S3

  ; Set PLA temp
  M28 "0:/macros/Heat Nozzle"
  M291 R"Filament Handling" P"Heating nozzle for PLA, please wait." S0 T5
  T0 ; Activate Hotend
  M104 S200                           ; set nozzle temp to 200c
  M109 S200                           ; wait for extruder temp
  M29
  
  M28 "0:/sys/filaset"
  ; This gcode is used by Filament Handling Macro
  T0 M702
  T0 M701 S"PLA"
  M29  

  M291 S3 R"Filament Handling" P"Filament type currently set to PLA. Press cancel to save this selection or OK to proceed to next filament type."
  
  ; Set PETg temp
  M28 "0:/macros/Heat Nozzle"
  M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T5
  T0 ; Activate Hotend
  M104 S230                           ; set nozzle temp to 230c
  M109 S230                           ; wait for extruder temp
  M29
  
  M28 "0:/sys/filaset"
  ; This gcode is used by Filament Handling Macro
  T0 M702
  T0 M701 S"PETG"
  M29  

  M291 S3 R"Filament Handling" P"Filament type currently set to PETg. Press cancel to save this selection or OK to proceed to next filament type."

  ; Set ABS temp
  M28 "0:/macros/Heat Nozzle"
  M291 R"Filament Handling" P"Heating nozzle for ABS, please wait." S0 T5
  T0 ; Activate Hotend
  M104 S250                           ; set nozzle temp to 250c
  M109 S250                           ; wait for extruder temp
  M29
  
  M28 "0:/sys/filaset"
  ; This gcode is used by Filament Handling Macro
  T0 M702
  T0 M701 S"ABS"
  M29  

  M291 S3 R"Filament Handling" P"Filament type currently set to ABS. Press cancel to save this selection or OK to proceed to next filament type."

  ; Set PC temp
  M28 "0:/macros/Heat Nozzle"
  M291 R"Filament Handling" P"Heating nozzle for PC, please wait." S0 T5
  T0 ; Activate Hotend
  M104 S270                           ; set nozzle temp to 270c
  M109 S270                           ; wait for extruder temp
  M29
  
  M28 "0:/sys/filaset"
  ; This gcode is used by Filament Handling Macro
  T0 M702
  T0 M701 S"ABS"
  M29  

  M291 S3 R"Filament Handling" P"Filament type currently set to PC. Press cancel to save this selection or OK to proceed to next filament type."

else

 M291 S3 R"Filament Handling" P"Filament is currently loaded. Please unload filament before changing filament type."
```