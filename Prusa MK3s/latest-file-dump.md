## DUET System (sd-card contents) files follow: ##
###### *Always use the github folders as they will contain the latest revisions of these files. ######

### file dump - v08/24/20
### Directory / File list follow:
****  
**/filaments**  
**/filaments/ABS**  
config.g  
load.g  
unload.g  
**/filaments/PC**  
config.g  
load.g  
unload.g  
**/filaments/PETG**  
config.g  
heightmap.csv  
load.g  
unload.g  
**/filaments/PLA**  
config.g  
load.g  
unload.g  
**/macros**  
Filament Handling  
Heat Nozzle  
Set Filament Type  
**/macros/Maintenance**  
Hotmesh  
Save-Z-Baby  
**/sys**  
bed.g  
cancel.g  
config.g  
current-sense-homing.g  
current-sense-normal.g  
deployprobe.g  
filament-change.g  
filaments.csv  
filaset  
homeall.g  
homex.g  
homey.g  
homez.g  
pause.g  
primeline.g  
resume.g  
retractprobe.g  
sleep.g  
start.g  
stop.g  


### File contents follow:
****


#### 
#### /filaments
#### /filaments/ABS
##### /filaments/ABS/config.g
```g-code
; 0:/filaments/ABS/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                    ; Play some tones  
M140 S75                                                   ; Set the bed temperature to 75c  
M104 S150                                                  ; Set the extruder warm-up temperature to 150c  
                                                           ; Note: actual extruder temperature will be set from the slicer  

; Insert additional filament specific settings here

```
##### /filaments/ABS/load.g
```g-code
; LEAVE EMPTY
```
##### /filaments/ABS/unload.g
```g-code
; LEAVE EMPTY
```
#### /filaments/PC
##### /filaments/PC/config.g
```g-code
; 0:/filaments/PC/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                    ; Play some tones  
M140 S75                                                   ; Set the bed temperature to 75c  
M104 S150                                                  ; Set the extruder warm-up temperature to 150c  
                                                           ; Note: actual extruder temperature will be set from the slicer  

; Insert additional filament specific settings here

```
##### /filaments/PC/load.g
```g-code
; LEAVE EMPTY
```
##### /filaments/PC/unload.g
```g-code
; LEAVE EMPTY
```
#### /filaments/PETG
##### /filaments/PETG/config.g
```g-code
; 0:/filaments/PETG/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                    ; Play some tones  
M140 S75                                                   ; Set the bed temperature to 75c  
M104 S150                                                  ; Set the extruder warm-up temperature to 150c  
                                                           ; Note: actual extruder temperature will be set from the slicer  
 
; Insert additional filament specific settings here

```
##### /filaments/PETG/heightmap.csv
```g-code
RepRapFirmware height map file v2 generated at 2020-08-17 03:17, min error -0.050, max error 0.123, mean 0.042, deviation 0.033
xmin,xmax,ymin,ymax,radius,xspacing,yspacing,xnum,ynum
25.00,225.00,10.00,195.00,-1.00,25.00,23.12,9,9
  0.043,  0.044,  0.023,  0.015, -0.035, -0.009, -0.004, -0.013, -0.050
  0.041,  0.084,  0.057,  0.038, -0.014, -0.001,  0.038,  0.022, -0.033
  0.029,  0.068,  0.074,  0.053, -0.003,  0.015,  0.035,  0.050,  0.011
  0.048,  0.052,  0.053,  0.043,  0.008,  0.023,  0.050,  0.061,  0.015
  0.038,  0.036,  0.018,  0.031,  0.012,  0.039,  0.043,  0.070,  0.035
  0.038,  0.039,  0.049,  0.034,  0.015,  0.039,  0.063,  0.076,  0.040
  0.013,  0.047,  0.072,  0.071,  0.036,  0.056,  0.098,  0.102,  0.056
  0.009,  0.042,  0.060,  0.074,  0.038,  0.079,  0.112,  0.123,  0.078
  0.006,  0.045,  0.042,  0.054,  0.049,  0.087,  0.095,  0.102,  0.064

```
##### /filaments/PETG/load.g
```g-code
; LEAVE EMPTY
```
##### /filaments/PETG/unload.g
```g-code
; LEAVE EMPTY
```
#### /filaments/PLA
##### /filaments/PLA/config.g
```g-code
; 0:/filaments/PLA/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                    ; Play some tones  
M140 S60                                                   ; Set the bed temperature to 60c  
M104 S150                                                  ; Set the extruder warm-up temperature to 150c  
                                                           ; Note: actual extruder temperature will be set from the slicer  
 
; Insert additional filament specific settings here

```
##### /filaments/PLA/load.g
```g-code
; LEAVE EMPTY
```
##### /filaments/PLA/unload.g
```g-code
; LEAVE EMPTY
```
#### /macros
##### /macros/Filament Handling
```g-code
; 0:/macros/Filament Handling
; Macro used for all filament handling evolutions

if state.status != "processing"                            ; Printer is not currently printing!

   if sensors.filamentMonitors[0].filamentPresent = true   ; Filament is detected, currently loaded
   
      M291 P"Press OK to begin filament UNLOADING, else press CANCEL to exit." R"Filament Handling" S3
      M98 P"0:/macros/Heat Nozzle"                         ; Heat nozzle to predetermined temp
      M291 P"Ready for filament unloading. Gently pull filament and press OK." R"Filament Handling" S2
      M291 P"Retracting filament..." T5                    ; Display another message
      G1 E-150 F5000                                       ; Retract filament
      M400                                                 ; Wait for the moves to finish
      T0 M702                                              ; Select tool 0, set filament is unloaded
      M104 S-273                                           ; Turn off hotend
      M140 S-273                                           ; Turn off heatbed
      M98 P"0:/macros/Filament Handling"; run again        ; Now that filament is unloaded, lets ask to load filament

   else

      M291 P"Press OK to begin filament LOADING, else press CANCEL to exit." R"Filament Handling" S3
      M98 P"0:/macros/Heat Nozzle"                         ; Heat nozzle to predetermined temp
      M291 P"Ready for filament loading. Insert filament and press OK." R"Filament Handling" S2
      M291 P"Feeding filament..." T5                       ; Display new message
      G1 E150 F450                                         ; Feed 150mm of filament at 600mm/min
      G1 E20 F100                                          ; Feed 20mm of filament at 100mm/min
      G4 P1000                                             ; Wait one second
      G1 E-1 F1800                                         ; Retract 10mm of filament at 1800mm/min
      M400                                                 ; Wait for moves to complete
      M98 P"0:/sys/filaset"                                ; Set system filament type
      M400                                                 ; Wait for moves to complete
      M104 S-273                                           ; Turn off hotend
      M140 S-273                                           ; Turn off heatbed

else

   M291 P"Press OK to begin filament CHANGE, else press CANCEL to exit." R"Filament Handling" S3
   M98 P"0:/sys/filament-change.g"                         ; Call filament-change.g
   M24                                                     ; Start/resume SD print

```
##### /macros/Heat Nozzle
```g-code
; 0:/macros/Heat Nozzle
; Heat nozzle to set temp

M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T10
T0                                                         ; Select Tool 0
M109 S230                                                  ; set temp to 230c and wait

```
##### /macros/Set Filament Type
```g-code
; 0:/macros/Set Filament Type
; Macro used to set system's loaded filament type

if sensors.filamentMonitors[0].filamentPresent = false        ; if filament is loaded then reject action to change filament type

  M291 P{"System filament is currently set to " ^ move.extruders[0].filament ^ ". Press OK to change filament type, else press CANCEL to exit."} R"Filament Handling" S3

  ; Set PLA temp
  M28 "0:/macros/Heat Nozzle"                                 ; Begin writing to SD card file
  M291 R"Filament Handling" P"Heating nozzle for PLA, please wait." S0 T10
  T0                                                          ; Activate Hotend
  M109 S200                                                   ; set temp to 200c and wait
  M29                                                         ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                        ; Begin writing to SD card file
  T0 M702                                                     ; Set system filament as UNLOADED
  T0 M701 S"PLA"                                              ; Set system filament as PLA
  M29                                                         ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to PLA. Press cancel to save this selection or OK to proceed to next filament type."
  
  ; Set PETg temp
  M28 "0:/macros/Heat Nozzle"                                 ; Begin writing to SD card file
  M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T10
  T0                                                          ; Activate Hotend
  M109 S230                                                   ; set temp to 230c and wait
  M29                                                         ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                        ; Begin writing to SD card file
  T0 M702                                                     ; Set system filament as UNLOADED
  T0 M701 S"PETG"                                             ; Set system filament as PETG
  M29                                                         ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to PETg. Press cancel to save this selection or OK to proceed to next filament type."

  ; Set ABS temp
  M28 "0:/macros/Heat Nozzle"                                 ; Begin writing to SD card file
  M291 R"Filament Handling" P"Heating nozzle for ABS, please wait." S0 T10
  T0                                                          ; Activate Hotend
  M109 S250                                                   ; set temp to 250c and wait
  M29                                                         ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                        ; Begin writing to SD card file
  T0 M702                                                     ; Set system filament as UNLOADED
  T0 M701 S"ABS"                                              ; Set system filament as ABS
  M29                                                         ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to ABS. Press cancel to save this selection or OK to proceed to next filament type."

  ; Set PC temp
  M28 "0:/macros/Heat Nozzle"                                 ; Begin writing to SD card file
  M291 R"Filament Handling" P"Heating nozzle for PC, please wait." S0 T10
  T0                                                          ; Activate Hotend
  M109 S270                                                   ; set temp to 270c and wait
  M29                                                         ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                        ; Begin writing to SD card file
  T0 M702                                                     ; Set system filament as UNLOADED
  T0 M701 S"PC"                                               ; Set system filament as PC
  M29                                                         ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to PC. Press cancel to save this selection or OK to proceed to next filament type."

else

  M291 S3 R"Filament Handling" P"Filament is currently loaded. Please unload filament before changing filament type."


```
#### /macros/Maintenance
##### /macros/Maintenance/Hotmesh
```g-code
; 0:/macros/Maintenance/Hotmesh
; Called to perform automatic heated bedmesh compensation
; This saves the heightmap to the system's set filament's type directory (0:/filaments/XXXX/heightmap.csv)

if state.status = "processing"                             ; Printer is currently printing!
   M99                                                     ; Abort this macro   
 
T0                                                         ; Ensure tool is selected
M703                                                       ; Heat bed to set temp based off current system filament type
M104 S-273                                                 ; Turn off hotend
M106 S0                                                    ; Turn part cooling blower off if it is on
M291 P{"Performing bed heatup per " ^ move.extruders[0].filament ^ " profile. This process will take approximately 6 minutes."} R"Hotmesh" S0 T10
G28                                                        ; Home
G1 X105 Y105                                               ; Place nozzle center of bed
 
; Give 5 minutes for stabilization
G91                                                        ; Set to Rel Positioning
while iterations <=9                                       ; Perform 10 passes
    G1 Z15 F300                                            ; Move Z 15mm up
    G4 S0.5                                                ; Wait .5 seconds
G1 Z3 F300                                                 ; Raise an additional 3mm
M116                                                       ; Wait for all temperatures
M291 P"Bed temperature at setpoint. Please wait 5 minutes for stabilization, Z indicates countdown." R"Hotmesh" S0 T10
; Start countdown - use Z as indicator   
while iterations <=9                                       ; Perform 10 passes
    G4 S30                                                 ; Wait 30 seconds
    G1 Z-15 F300                                           ; Move Z 15mm down
G90                                                        ; Set to Absolute Positioning

M291 P"Performing homing, gantry alignment, and mesh probing. Please wait." R"Hotmesh" S0 T10
G32                                                        ; Home and Level gantry
M400                                                       ; Clear queue
M558 F50 A4 S-1                                            ; slow z-probe, take 5 probes and yield average
G29                                                        ; Perfrom bed mesh
G29 S3 [P{"0:/filaments/" ^ move.extruders[0].filament ^ "/heightmap.csv"}] ; Save heightmap.csv to filament type's directory
M558 F200 A1                                               ; normal z-probe
M104 S-273                                                 ; Turn off hotend
M140 S-273                                                 ; Turn off heatbed
M291 P"Hotmesh complete. Hotend and Heatbed are turned off. Performing final homing routine. Please wait." R"Hotmesh" S0 T10

G28                                                        ; Home
M18                                                        ; Free all

```
##### /macros/Maintenance/Save-Z-Baby
```g-code
; 0:/macros/Maintenance/Save-Z-Baby
; This macro subtracts the current babystep offset from the current Z trigger height and informs the user what offset
; value to change the G31 Z metric to in the 0:/sys/config.g. Additionally, the macro issues a G31 command with the new
; calculated z-offset, clears the current babystepping, and then rehomes the machine to make the new z-offset effective. 
; If this is for a specific filament type, recommend placing this yielded information in the filament's config.g - not
; the 0:/sys/config.g.
	 
 
if state.status != "processing"                                     ; Printer is not currently printing!
 
   if move.axes[2].babystep !=0                                     ; If no babysteps are currently adjusted - exit routine
      echo {"Previous Z probe trigger height: " ^ sensors.probes[0].triggerHeight ^ ", New: " ^ sensors.probes[0].triggerHeight - move.axes[2].babystep}
      echo {"Edit the G31 command in your config.g with a new Z offset of: " ^ sensors.probes[0].triggerHeight - move.axes[2].babystep}
      M291 P{"Set probe offset to " ^ sensors.probes[0].triggerHeight - move.axes[2].babystep ^ ", clear babysteps, and REHOME ALL?"} R"!WARNING! Do not proceed if printing!" S3
      M400                                                           ; Finish all current moves / clear the buffer
      G31 Z{sensors.probes[0].triggerHeight - move.axes[2].babystep} ; set G31 Z offset to corrected
      M500 P10:31                                                    ; save settings to config-overide.g - G31 P31 saves trigger height
      M290 R0 S0                                                     ; set babystep to 0mm absolute
      G28                                                            ; home all
      M291 P"Ensure M501 exists in 0:/sys/config, or manually edit the G31 Z offset, to make this change permanent." R"Note on making change permanent." S3 
   else
      echo "Babystepping is not currently active, nothing to do."
 
else
   M291 S2 P"This would be detrimental to the ongoing print. Please run this macro when the print is finished, and the bed is clear & ready for the homing sequence to be conducted." R"WARNING"
```
#### /sys
##### /sys/bed.g
```g-code
; 0:/sys/bed.g
; Called to perform automatic bed compensation via G32

M561                                                       ; Clear any existing bed transform.
G28                                                        ; Home all axis.

M558 F50 A5 S0.003                                         ; Slow z-probe, up to 5 probes until disparity is 0.003 or less - else yield average.
while iterations <=2                                       ; Perform 3 passes.
   G30 P0 X25 Y105 Z-99999                                 ; Probe near a leadscrew, halfway along Y-axis.
   G30 P1 X225 Y105 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors.
   G1 X105 F10000                                          ; Move to the center of the bed.
   G30                                                     ; Probe the bed at the current XY position.
   M400                                                    ; Finish all moves, clear the buffer.

M558 F50 A5 S-1                                            ; Slow the z-probe, perform 5 probes and yield the average.
while move.calibration.initial.deviation >= 0.003          ; Perform additional leveling if previous deviation was over 0.003mm. 
   if iterations = 5                                       ; Perform 5 addition checks, if needed.
      M300 S3000 P500                                      ; Sound alert, the required deviation could not be achieved.
      M558 F200 A1                                         ; Set normal z-probe speed.
      abort "!!! ABORTED !!! Failed to achieve < 0.002 deviation. Current deviation is " ^ move.calibration.initial.deviation ^ "mm."
   G30 P0 X25 Y105 Z-99999                                 ; Probe near the left leadscrew, halfway along Y-axis.
   G30 P1 X225 Y105 Z-99999 S2                             ; Probe near the right leadscrew and calibrate 2 motors.
   G1 X105 F10000                                          ; Move the nozzle to the center of the bed.
   G30                                                     ; Probe the bed at the current XY position.
   M400                                                    ; Finish all moves, clear the buffer.

M558 F200 A1                                               ; Set normal z-probe speed.
echo "Gantry deviation of " ^ move.calibration.initial.deviation ^ "mm obtained."
G1 Z8                                                      ; Raise head 8mm to ensure it is above the Z probe trigger height.
```
##### /sys/cancel.g
```g-code
; 0:/sys/cancel.g
; Called when a print is canceled after a pause.

M83                                                        ; Set the extrusion values as relative.
M104 S-273                                                 ; Turn off the hotend.
M140 S-273                                                 ; Turn off the heatbed.
M107                                                       ; Turn off part cooling fan.
G1 F1000.0                                                 ; Set the feed rate.
G1 E-2                                                     ; Retract 2mm of filament.
M98 P"current-sense-homing.g"                              ; Set the current and sensitivity for homing, non-print, routines.
M400                                                       ; Finish all moves, clear the buffer.
M18 YXE                                                    ; Unlock the X, Y, and E axis.


```
##### /sys/config.g
```g-code
; 0:/sys/config.g
; Configuration file for MK3s Duet WiFi, firmware version 3.11
; Go to https://github.com/rkolbi/RRF-machine-config-files/blob/master/Prusa%20MK3s/Duet-MK3s.pdf
; for corresponding wiring information.

; General preferences
G90                                                        ; Set absolute coordinates
M83                                                        ; Set relative extruder moves
M550 P"ZMK3-BMGm"                                          ; Set printer name

; Network
M551 P"3D"                                                 ; Set password
M552 S1                                                    ; Enable network
M586 P0 S1                                                 ; Enable HTTP
M586 P1 S1                                                 ; Enable FTP
M586 P2 S0                                                 ; Disabled Telnet
M575 P1 S1 B38400                                          ; Enable support for PanelDue

; Drive Mappings S0 = backwards, S1 = forwards
M569 P0 S1                                                 ; Drive 0 goes forwards: X Axis
M569 P1 S1                                                 ; Drive 1 goes forwards: Y Axis
M569 P2 S1                                                 ; Drive 2 goes forwards: Z Axis Left
M569 P3 S0                                                 ; Drive 3 goes backwards: E Axis
M569 P4 S1                                                 ; Drive 4 goes forwards: Z Axis Right (using E1)

; Motor Configuration
; !!! For stock motors, use the following as a starting point:
; M906 X620.00 Y620.00 Z560.00 E650.00 I10.                ; Set motor currents (mA) and motor idle factor in percent
; M350 X16 Y16 Z16 I1                                      ; Set X, Y, and Z Microstepping with interpolation 
; M350 E32 I0                                              ; Set Extruder Microstepping without interpolation 
; M92 X100.00 Y100.00 Z400.00 E280.00                      ; Steps per mm
; !!! Also note that you should edit the current-sense-homing.g file and increase current to 50 on X and Y, 100 on Z.
; !!! M913 X20 Y20 Z60   --->   M913 X50 Y50 Z100
;
M350 X16 Y16 E16 Z16 I1                                    ; Set X, Y, Z, and E microstepping with interpolation.
M92 X200.00 Y200.00 Z400.00 E415.00                        ; Set steps per mm
M566 X480.00 Y480.00 Z24.00 E300.00 P1                     ; Set maximum instantaneous speed changes (mm/min)
M203 X15000.00 Y15000.00 Z900.00 E2000.00                  ; Set maximum speeds (mm/min)
M201 X4000.00 Y4000.00 Z1000.00 E5000.00                   ; Set accelerations (mm/s^2)
M906 X1340.00 Y1600.00 Z550.00 E550.00 I50                 ; Set initial motor currents (mA) and motor idle factor in percent
M84 S1000                                                  ; Set idle timeout before shifitng to idle-current  

; Motor remapping for dual Z and axis Limits
M584 X0 Y1 Z2:4 E3                                         ; Set two Z motors connected to driver outputs Z and E1
M671 X-37:287 Y0:0 S10                                     ; Leadscrew at left connected to Z, leadscrew at right connected to E1  

; Set bed dimensions
M208 X0:250 Y-4:215 Z-0.1:205                              ; X carriage moves from 0 to 250, Y bed goes from 0 to 210
M564 H0                                                    ; Allow unhomed movement

; Endstops for each Axis
M574 X1 S3                                                 ; Set endstops controlled by the motor load detection
M574 Y1 S3                                                 ; Set endstops controlled by the motor load detection

; Stallgaurd Sensitivity
M98 P"current-sense-homing.g"                              ; Set the current and sensitivity for normal routine, per the macro

; Z-Probe Settings for BLTouch
M558 P9 C"^zprobe.in" H4 F200 T10000                       ; BLTouch, connected to Z probe IN pin
M950 S0 C"exp.heater3"                                     ; BLTouch, create servo/gpio 0 on heater 3 pin on expansion 
G31 P1000 X22.8 Y3.8 Z1.32                                 ; BLTouch, Z offset with MICRO SWISS NOZZLE
M574 Z1 S2                                                 ; Set Z axis endstop, controlled by probe
M557 X25:225 Y10:195 P9                                    ; Define mesh grid for probing

; Z-Probe Setting for PINDA v2
; 1 - If using PindaV2, Remove above M558 & M950 lines, replace with the following M558 & M308 line
; 2 - Uncomment one of the Z-Offsets below, follow the wiki guide steps to get the proper Z-offset for your printer
; 3 - Comment out the 2 BLTouch lines in the homez and homeall files
; 
; M558 P5 C"^zprobe.in" I1 H1 F1000 T6000 A20 S0.005              ; Prusa PindaV2
; M308 S2 P"e1_temp" A"Pinda V2" Y"thermistor" T100000 B3950      ; Prusa PindaV2
;
; Z-Offsets - Read here: https://duet3d.dozuki.com/Wiki/Test_and_calibrate_the_Z_probe   
; G31 P1000 X23 Y5 Z0.985                                  ; PEI Sheet (Prusa) Offset Spool3D Tungsten Carbide
; G31 P1000 X23 Y5 Z0.440                                  ; PEI Sheet (Prusa) Offset MICRO SWISS NOZZLE	
; G31 P1000 X23 Y5 Z1.285                                  ; Textured Sheet (Prusa) Offset MICRO SWISS NOZZLE
; G31 P1000 X23 Y5 Z0.64                                   ; Textured Sheet (thekkiinngg) Offset MICRO SWISS NOZZLE

; Heatbed Heaters and Thermistor Bed 
M308 S0 P"bed_temp" Y"thermistor" A"Build Plate" T100000 B4138 R4700 ; Set thermistor + ADC parameters for heater 0 Bed
M950 H0 C"bedheat" T0                                      ; Creates Bed Heater
M307 H0 A91.5 C264.0 D10.2 S1.00 V24.0 B0                  ; Bed PID Calibration @ 75c - updated 11AUG2020
M140 H0                                                    ; Bed uses Heater 0
M143 H0 S120                                               ; Set temperature limit for heater 0 to 120C Bed

; Filament Sensor
M591 D0 P2 C"e0stop" S1                                    ; Filament Runout Sensor  

; HotEnd Heaters and Thermistor HotEnd
; !!! Use this line for stock thermisotr: M308 S1 P"e0_temp" Y"thermistor" A"Nozzle" T100000 B4725 R4700  ; Set thermistor + ADC parameters for heater 1 HotEnd
M308 S1 P"e0_temp" Y"pt1000" A"Mosquito"                   ; Set extruder thermistor for PT1000
M950 H1 C"e0heat" T1                                       ; Create HotEnd Heater
M307 H1 A311.0 C130.0 D4.3 S1.00 V24.1 B0                  ; Hotend PID Calibration @ 240c - updated 09AUG2020
M143 H1 S285                                               ; Set temperature limit for heater 1 to 285C HotEnd
M302 S190 R190                                             ; Allow cold extrudes, S-Minimum extrusion temperature, R-Minimum retraction temperature

; Fans
M950 F1 C"Fan1" Q1000                                      ; Creates HOTEND Fan  
                                                           ; FAN 40X10MM 24VDC - 6.0 CFM (0.168m³/min). 
                                                           ; Digi-Key: G4010L24B-RSR  
M106 P1 T45 S255 H1                                        ; HOTEND Fan Settings  
M950 F0 C"Fan0" Q5000                                      ; Creates PARTS COOLING FAN
                                                           ; BLOWER 50X15MM 24VDC - 5.0 CFM (0.140m³/min)
                                                           ; Digi-Key: B5015E24B-BSR
M106 P0 H-1                                                ; Set fan 1 value, PWM signal inversion and frequency. Thermostatic control is turned off PARTS COOLING FAN
; The following lines are for auto case fan control, attached to 'fan2' header on duet board
M308 S4 Y"drivers" A"TMC2660"                              ; Case fan - configure sensor 2 as temperature warning and overheat flags on the TMC2660 on Duet
                                                           ; !!! Reports 0C when there is no warning, 100C if any driver reports over-temperature
                                                           ; !!! warning , and 150C if any driver reports over-temperature shutdown
M308 S3 Y"mcu-temp" A"Duet2Wifi"                           ; Case fan - configure sensor 3 as thermistor on pin e1temp for left stepper
M950 F2 C"fan2" Q100                                       ; Case fan - create fan 2 on pin fan2 and set its frequency                        
M106 P2 H4:3 L0.15 X1 B0.3 T40:70                          ; Case fan - set fan 2 value
M912 P0 S-5.5                                              ; MCU Temp calibration - default reads 5.5c higher than ambient

; Tools
M563 P0 D0 H1 F0                                           ; Define tool 0
G10 P0 X0 Y0 Z0                                            ; Set tool 0 axis offsets
G10 P0 R0 S0                                               ; Set initial tool 0 active and standby temperatures to 0C
T0                                                         ; Set Tool 0 active

; Relase X, Y, and E axis
M18 XYZE                                                    ; Unlock the X, Y, and E axis

```
##### /sys/current-sense-homing.g
```g-code
; 0:/sys/current-sense-homing.g
; Set the current and sensitivity for homing, non-printing, routines

M915 X S2 F0 H400 R0                                       ; Set the X axis sensitivity.
M915 Y S2 F0 H400 R0                                       ; Set the Y axis sensitivity.
M913 X30 Y30 Z60                                           ; Set the X, Y, and Z drivers current percentage for non-print moves, per config.g.
```
##### /sys/current-sense-normal.g
```g-code
; 0:/sys/current-sense-normal.g
; Set the current and sensitivity for normal routines

M913 X100 Y100 Z100                                        ; Set the X, Y, and Z drivers to 100% of their normal current per config.g.
M915 X S3 F0 H200 R0                                       ; Set the X axis sensitivity.
M915 Y S3 F0 H200 R0                                       ; Set the Y axis sensitivity.
```
##### /sys/deployprobe.g
```g-code
; 0:/sys/deployprobe.g
; Called to deploy a physical Z probe

M280 P0 S10                                                ; Deploy the BLTouch probe.
```
##### /sys/filament-change.g
```g-code
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
```
##### /sys/filaments.csv
```g-code
RepRapFirmware filament assignment file v1 generated at 2020-08-01 15:01
extruder,filament
0,PETG

```
##### /sys/filaset
```g-code
T0 M702                                                     
T0 M701 S"PETG"                                             

```
##### /sys/homeall.g
```g-code
; 0:/sys/homeall.g
; Home X, Y, and Z axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release.
G4 P100                                                    ; BLTouch, delay for the release command.

G91                                                        ; Set relative positioning.
G1 Z3 F800 H2                                              ; Lift the Z axis 3mm.

; HOME X
G1 H0 X5 F1000                                             ; Move slowly away. 
G1 H1 X-255 F3000                                          ; Move quickly to the X endstop. 
G1 H0 X5 F1000                                             ; Move slowly away. 
G1 H1 X-255 F3000                                          ; Move quickly to the X endstop, a second check. 

; HOME Y
G1 H0 Y5 F1000                                             ; Move slowly away. 
G1 H1 Y-215 F3000                                          ; Move quickly to the Y endstop. 
G1 H0 Y5 F1000                                             ; Move slowly away. 
G1 H1 Y-215 F3000                                          ; Move quickly to the Y endstops, a second check.

; HOME Z
G1 H2 Z2 F2600                                             ; Raise the Z axis 2mm to ensure it is above the Z probe trigger height.
G90                                                        ; Set absolute positioning mode.
G1 X105 Y105 F6000                                         ; Go to the center of the bed for probe point.

M558 F1000 A1                                              ; Set the Z-probe to fast for the first pass.  
G30                                                        ; Perform Z probing.
G1 H0 Z5 F400                                              ; Lift the Z axis to the 5mm position.

M558 F50 A5 S-1                                            ; Set the Z-probe to slow for the second pass, take 5 probes and yield the average.
G30                                                        ; Perform Z probing.
G1 H0 Z5 F400                                              ; Lift the Z axis to the 5mm position.

M558 F200 A1                                               ; Set the Z-probe to normal speed.  
```
##### /sys/homex.g
```g-code
; 0:/sys/homex.g
; Home the X axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

G91                                                        ; Set relative positioning.
G1 Z3 F800 H2                                              ; Lift the Z axis 3mm.

G1 H0 X5 F1000                                             ; Move slowly away. 
G1 H1 X-255 F3000                                          ; Move quickly to the X endstop. 
G1 H0 X5 F1000                                             ; Move slowly away. 
G1 H1 X-255 F3000                                          ; Move quickly to the X endstop, the second check.

G1 Z-3 F800 H2                                             ; Place Z axis back to the starting position.

```
##### /sys/homey.g
```g-code
; 0:/sys/homey.g
; Home the Y axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

G91                                                        ; Set relative positioning.
G1 Z3 F800 H2                                              ; Lift the Z axis 3mm.  

G1 H0 Y5 F1000                                             ; Move slowly away. 
G1 H1 Y-215 F3000                                          ; Move quickly to the Y endstop. 
G1 H0 Y5 F1000                                             ; Move slowly away. 
G1 H1 Y-215 F3000                                          ; Move quickly to the Y endstop, second check.

G1 Z-3 F800 H2                                             ; Place Z back to the starting position.

```
##### /sys/homez.g
```g-code
; 0:/sys/homez.g
; Home the Z axis

M98 P"current-sense-homing.g"                              ; Ensure the current and sensitivity is set for homing routines.

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release.
G4 P100                                                    ; BLTouch, delay for the release command.

G91                                                        ; Set relative positioning.
G1 H0 Z3 F6000                                             ; Lift Z axis 3mm.
G90                                                        ; Set absolute positioning.

G1 X105 Y105 F6000                                         ; Go to the center of the bed for probe point.

M558 F1000 A1                                              ; Set probing speed to fast for the first pass.  
G30                                                        ; Perform Z probing.
G1 H0 Z5 F400                                              ; Lift Z axis to the 5mm position.

M558 F50 A5 S-1                                            ; Set probing speed to slow for second pass, take 5 probes and yield the average.
G30                                                        ; Perform Z probing.
G1 H0 Z5 F400                                              ; Lift Z axis to the 5mm position.

M558 F200 A1                                               ; Set normal z-probe speed.  
```
##### /sys/pause.g
```g-code
; 0:/sys/pause.g
; Called when a print from SD card is paused

M120                                                       ; Push the state of the machine onto a memory stack.

if sensors.filamentMonitors[0].filamentPresent = false
   G1 E-3 F1000                                            ; If the filament has run out, retract 6mm of filament.

M83                                                        ; Set relative extruder moves.
G1 E-3 F3000                                               ; Retract 3mm of filament.
G91                                                        ; Set relative positioning.
G1 Z10 F360                                                ; Raise Z 10 mm.
G90                                                        ; Set absolute positioning.
G1 X10 Y0 F6000                                            ; Move to the parking position.
M300 S80 P2000                                             ; Play a beep sound.

```
##### /sys/primeline.g
```g-code
; 0:/sys/primeline.g
; Print prime-line at a 'randomized' Y position from -1.1 to -2.9
 
; Charge! tune
M400                                                       ; Finish all moves, clear the buffer.
G4 S1
M300 P200 S523.25
G4 P200
M300 P200 S659.25
G4 P200
M300 P200 S739.99
G4 P250
M300 P285 S880.00
G4 P450
M300 P285 S880.00
G4 P285
M300 P625 S1108.73
G4 S1
M400		
	
G1 X0 Z0.6 Y{-2+(0.1*(floor(10*(cos(sqrt(sensors.analog[0].lastReading * state.upTime))))))} F3000.0;
G92 E0.0                                                   ; Reset the extrusion distance.
G1 E8                                                      ; Purge Bubble.
G1 X60.0 E11.0 F1000.0                                     ; Intro line part 1.
G1 X120.0 E16.0 F1000.0                                    ; Intro line part 2.
G1 X122.0 F1000.0                                          ; Wipe 2mm of filament.
G92 E0.0                                                   ; Reset the extrusion distance.
M400                                                       ; Finish all moves, clear the buffer.

```
##### /sys/resume.g
```g-code
; 0:/sys/resume.g
; Called before a print from SD card is resumed

M98 P"current-sense-normal.g"                              ; Ensure the drivers current and sensitivity is set for normal routines.
G1 E3 F400                                                 ; Extract 3mm of filament.
G1 R1 X0 Y0 Z5                                             ; Go back to the last print position with Z 5mm above.
G1 R1 Z0                                                   ; Go to Z position of the last print move.
M121                                                       ; Recover the last state pushed onto the stack.

```
##### /sys/retractprobe.g
```g-code
; 0:/sys/retractprobe.g
; Called to retract a physical Z probe

M280 P0 S90                                                ; Retract the BLTouch probe.
```
##### /sys/sleep.g
```g-code
; 0:/sys/sleep.g
; Called when M1 (Sleep) is being processed.

M104 S-273                                                 ; Turn off the hotend.
M140 S-273                                                 ; Turn off the heatbed.
M107                                                       ; Turn off the part cooling fan.
M400                                                       ; Finish all moves, clear the buffer.
M18 XEZY                                                   ; Unlock all axis.

```
##### /sys/start.g
```g-code
; 0:/sys/start.g
; Executed before each print - BEFORE ANY SLICER CODE IS RAN
; This also loads the heightmap from the system's set filament type directory
; (0:/filaments/XXXX/heightmap.csv), if the heightmap does not exist, it will
; create one, and then save in the filament's directory. The HotMesh macro is
; a better choice to generate the heightmap as it performs a heat stabilization
; routine for ~5 minutes.

M122                                                       ; Clear diagnostic data to cleanly capture print evolution statistics. 
 
T0                                                         ; Ensure the tool is selected.
;M280 P0 S160                                              ; BLTouch, alarm release.
;G4 P100                                                   ; BLTouch, delay for the release command.
M572 D0 S0.0                                               ; Clear pressure advance.
M220 S100                                                  ; Set speed factor back to 100% in case it was changed.
M221 S100                                                  ; Set extrusion factor back to 100% in case it was changed.
M290 R0 S0                                                 ; Clear any babystepping.
M106 S0                                                    ; Turn part cooling blower off if it is on.
M703                                                       ; Execute loaded filament's config.g.
G28                                                        ; Home all.

;G1 Z5 X100 Y100                                           ; [PINDA] Place nozzle center of the bed, 5mm up.

G1 Z160 F300                                               ; [BLTouch] Last chance to check nozzle cleanliness.

M300 S4000 P100 G4 P200 M300 S4000 P100                    ; Give a double beep.
M116                                                       ; Wait for all temperatures.
M300 S4000 P100                                            ; Give a single beep.

; [BLTouch] Start countdown - use Z as indicator  
G91                                                        ; [BLTouch] Set to Relative Positioning.
while iterations <=9                                       ; [BLTouch] Perform 10 passes.
    G4 S12                                                 ; [BLTouch] Wait 12 seconds.
    G1 Z-15 F300                                           ; [BLTouch] Move Z 15mm down.
G90                                                        ; [BLTouch] Set to Absolute Positioning.

;G4 S120                                                   ; [PINDA] wait an additional 2 minutes for the bed to stabilize.

G32                                                        ; Level the gantry.
G29 S1 [P{"0:/filaments/" ^ move.extruders[0].filament ^ "/heightmap.csv"}] ; Load bed mesh for the system's set filament type.
if result > 1                                              ; If the file doesn't exist, perform mesh and save.
   G29                                                     ; Perform mesh now.
   G29 S3 [P{"0:/filaments/" ^ move.extruders[0].filament ^ "/heightmap.csv"}] ; Save heightmap.csv to filament type's directory.

M400                                                       ; Finish all moves, clear the buffer.
G90                                                        ; Absolute Positioning.
M83                                                        ; Extruder relative mode.
M98 P"0:/sys/current-sense-normal.g"                       ; Ensure that motor currents and sense are set for printing. 
G1 X0 Y0 F800                                              ; Final position before slicer's temp is reached and primeline is printed.
G1 Z2 F300                                                 ; Final position before slicer's temp is reached and primeline is printed.
 
; The primeline macro is executed by the slicer gcode to enable direct printing.
; of the primeline at the objects temp and to immediately print the object.
; following primeline completion. 
 
; Slicer generated gcode takes it away from here.

```
##### /sys/stop.g
```g-code
; 0:/sys/stop.g
; Called when M0 (Stop) is run (e.g. when a print from SD card is canceled)

M83                                                        ; Set extruder to relative mode.
M106 S255                                                  ; Turn the part cooling fan fully on.
M572 D0 S0.0                                               ; Clear pressure advance.
M220 S100                                                  ; Set the speed factor back to 100% incase it was changed.
M221 S100                                                  ; Set the extrusion factor back to 100% incase it was changed.
G1 E-2                                                     ; Retract 2mm of filament.
M104 S-273                                                 ; Turn off the hotend.
M140 S-273                                                 ; Turn off the heatbed.
G1 F1000.0                                                 ; Set feed rate.
M98 P"current-sense-homing.g"                              ; Adjust the current and sensitivity for homing routines.

; Let cool and wiggle for bit to reduce end stringing
M300 S4000 P100 G4 P200 M300 S4000 P100                    ; Give a double beep.
G91                                                        ; Set to Relative Positioning.
G1 Z2 F400                                                 ; Move Z axis up 3mm.

; Start countdown - use X/Y as indicators of counting  
while iterations <=9                                       ; Perform 10 passes.
    G4 S6                                                  ; Wait 6 seconds.
    G1 X1 Y1 F1000                                         ; Wiggle +1mm.
    G4 S6                                                  ; Wait 6 seconds.
    G1 Z0.5 X-1 Y-1 F1000                                  ; Wiggle -1mm, Z +0.5.

G90                                                        ; Set to Absolute Positioning.

G1 X220 Y205 Z205 F1000                                    ; Place nozzle to the right side, build plate to front, Z at top.
M400                                                       ; Finish all moves, clear the buffer.
M107                                                       ; Turn off the part cooling fan.
M18 YXE                                                    ; Unlock the X, Y, and E axis.

; Play a triumphant tune to celebrate a successful print.
G4 S1
M300 P250 S750
G4 P251
M300 P200 S1250
G4 P201
M300 P250 S750
G4 P251
M300 P200 S1250
G4 P201
M300 P250 S2500
G4 P251
M300 P150 S2000
G4 P151
M300 P150 S2500
G4 P151
M300 P350 S3700
G4 P351
M400                                                       ; Finish all moves, clear the buffer.

```
