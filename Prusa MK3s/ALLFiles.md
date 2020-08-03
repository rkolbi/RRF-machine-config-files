# **SYS DIRECTORY - v08/03/20**

**bed.g - v08/03/20**
```g-code
; 0:/sys/bed.g
; Called to perform automatic bed compensation via G32

M561                                                       ; Clear any bed transform
G28                                                        ; Home

while iterations <=1                                       ; Do minimum of 2 passes
   G30 P0 X25 Y100 Z-99999                                 ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y100 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors
   G90                                                     ; Set to Absolute Positioning

while move.calibration.initial.deviation >= 0.002          ; perform additional tramming if previous deviation was over 0.002mm 
   if iterations = 5                                       ; Perform 5 checks
      M300 S3000 P500                                      ; Sound alert, required deviation could not be achieved
      abort "!!! ABORTED !!! Failed to achieve < 0.002 deviation within 5 movements. Current deviation is " ^ move.calibration.initial.deviation ^ "mm."
   G30 P0 X25 Y100 Z-99999                                 ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y100 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors
   G90                                                     ; Set to Absolute Positioning

echo "Gantry deviation of " ^ move.calibration.initial.deviation ^ "mm obtained."
G1 H2 Z8 F2600                                             ; Raise head 8mm to ensure it is above the Z probe trigger height
G1 X104 Y100 F6000                                         ; Put head over the centre of the bed, or wherever you want to probe
G30                                                        ; Probe the bed at the current XY position. When the probe is triggered, set the Z coordinate to the probe trigger height.

```
**cancel.g - v08/03/20**
```g-code
; 0:/sys/cancel.g
; called when a print is canceled after a pause.

M83                                                        ; Makes the extruder interpret extrusion values as relative positions
M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
G1 F1000.0                                                 ; set feed rate
G1 E-2                                                     ; retract 2mm
M18 YXE                                                    ; unlock X, Y, E axis

```
**config.g - v08/03/20**
```g-code
; 0:/sys/config.g
; Configuration file for MK3s Duet WiFi, firmware version 3.11
; Go to https://github.com/rkolbi/RRF-machine-config-files/blob/master/Prusa%20MK3s/Duet-MK3s.pdf
; for corresponding wiring information.

; General preferences
G90                                                        ; Send absolute coordinates
M83                                                        ; Relative extruder moves
M550 P"ZMK3-BMGm"                                          ; Set printer name

; Network
M551 P"3D"                                                 ; Set password
M552 S1                                                    ; Enable network
M586 P0 S1                                                 ; Enable HTTP
M586 P1 S0                                                 ; Disabled FTP
M586 P2 S0                                                 ; Disabled Telnet
M575 P1 S1 B38400                                          ; Enable support for PanelDue

; Drive Mappings S0 = backwards, S1 = forwards
M569 P0 S1                                                 ; Drive 0 goes forwards: X Axis
M569 P1 S1                                                 ; Drive 1 goes forwards: Y Axis
M569 P2 S1                                                 ; Drive 2 goes forwards: Z Axis
M569 P3 S0                                                 ; Drive 3 goes backwards: E Axis (Bondtech BMGm)
M569 P4 S1                                                 ; Drive 4 goes forwards: Z Axis (at E1)

; Motor Configuration
; !!! For stock motors, use the following as a starting point:
; M906 X620.00 Y620.00 Z560.00 E650.00 I10.                ; Set motor currents (mA) and motor idle factor in percent
; M350 X16 Y16 Z16 I1                                      ; Microstepping with interpolation 
; M350 E32 I0                                              ; Microstepping without interpolation 
; M92 X100.00 Y100.00 Z400.00 E280.00                      ; Steps per mm
; !!! Also note that you should edit the current-sense-homing.g file and increase current to 50 on X and Y, 100 on Z.
; !!! M913 X20 Y20 Z60   --->   M913 X50 Y50 Z100
;
M350 X16 Y16 E16 Z16 I1                                    ; Configure microstepping with interpolation
M92 X200.00 Y200.00 Z400.00 E415.00                        ; Set steps per mm
M566 X480.00 Y480.00 Z24.00 E1500.00 P1                    ; Set maximum instantaneous speed changes (mm/min)
M203 X12000.00 Y12000.00 Z750.00 E1500.00                  ; Set maximum speeds (mm/min)
M201 X2500.00 Y2500.00 Z1000.00 E5000.00                   ; Set accelerations (mm/s^2)
M906 X1340.00 Y1600.00 Z650.00 E650.00 I10                 ; Set initial motor currents (mA) and motor idle factor in percent
M84 S30                                                    ; Set idle timeout

; Motor remapping for dual Z and axis Limits
M584 X0 Y1 Z2:4 E3                                         ; two Z motors connected to driver outputs Z and E1
M671 X-37:287 Y0:0 S10                                     ; leadscrews at left (connected to Z) and right (connected to E1) of X axis
M208 X0:250 Y-4:215 Z-0.1:205                              ; X carriage moves from 0 to 250, Y bed goes from 0 to 210
M564 H0                                                    ; allow unhomed movement

; Endstops for each Axis
M574 X1 S3                                                 ; Set endstops controlled by motor load detection
M574 Y1 S3                                                 ; Set endstops controlled by motor load detection

; Stallgaurd Sensitivy
M98 P"current-sense-normal.g"                              ; Current and Sensitivity for normal routine

; Z-Probe Settings for BLTouch
M558 P9 C"^zprobe.in" H5 F600 T5000                        ; BLTouch, connected to Z probe IN pin
M950 S0 C"exp.heater3"                                     ; BLTouch, create servo/gpio 0 on heater 3 pin on expansion 
G31 P1000 X22.8 Y3.8 Z1.24                                 ; BLTouch, Z offset with MICRO SWISS NOZZLE
M574 Z1 S2                                                 ; Set endstops controlled by probe
M557 X25:235 Y10:195 P9                                    ; Define mesh grid for probing

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
M307 H0 A117.2 C337.4 D9.1 S1.00 V24.0 B0                  ; Bed PID Calibration - updated 01AUG2020
M140 H0                                                    ; Bed uses Heater 0
M143 H0 S120                                               ; Set temperature limit for heater 0 to 120C Bed

; Filament Sensor
M591 D0 P2 C"e0stop" S1                                    ; Filament Runout Sensor  

; HotEnd Heaters and Thermistor HotEnd
; !!! Use this line for stock thermisotr: M308 S1 P"e0_temp" Y"thermistor" A"Nozzle" T100000 B4725 R4700  ; Set thermistor + ADC parameters for heater 1 HotEnd
M308 S1 P"e0_temp" Y"pt1000" A"Mosquito"                   ; Set extruder thermistor for PT1000
M950 H1 C"e0heat" T1                                       ; Create HotEnd Heater
M307 H1 A444.4 C181.6 D3.9 S1.00 V24.1 B0                  ; Hotend PID Calibration - updated 01AUG2020
M143 H1 S285                                               ; Set temperature limit for heater 1 to 285C HotEnd
M302 S190 R190                                             ; Allow cold extrudes, S-Minimum extrusion temperature, R-Minimum retraction temperature

; Fans
M950 F1 C"Fan1" Q250                                       ; Creates HOTEND Fan
M106 P1 T45 S255 H1                                        ; HOTEND Fan Settings
M950 F0 C"Fan0" Q250                                       ; Creates PARTS COOLING FAN
M106 P0 H-1                                                ; Set fan 1 value, PWM signal inversion and frequency. Thermostatic control is turned off PARTS COOLING FAN
; The following lines are for auto case fan control, attached to 'fan2' header on duet board
M308 S4 Y"drivers" A"TMC2660"                              ; Case fan - configure sensor 2 as temperature warning and overheat flags on the TMC2660 on Duet
                                                           ; !!! Reports 0C when there is no warning, 100C if any driver reports over-temperature
                                                           ; !!! warning , and 150C if any driver reports over temperature shutdown
M308 S3 Y"mcu-temp" A"Duet2Wifi"                           ; Case fan - configure sensor 3 as thermistor on pin e1temp for left stepper
M950 F2 C"fan2" Q100                                       ; Case fan - create fan 2 on pin fan2 and set its frequency                        
M106 P2 H4:3 L0.15 X1 B0.3 T40:70                          ; Case fan - set fan 2 value
M912 P0 S-5.5                                              ; MCU Temp calibration - default reads 7.5c higher than ambient

; Tools
M563 P0 D0 H1 F0                                           ; Define tool 0
G10 P0 X0 Y0 Z0                                            ; Set tool 0 axis offsets
G10 P0 R0 S0                                               ; Set initial tool 0 active and standby temperatures to 0C
T0                                                         ; Set Tool 0 active

; Relase X, Y, and E axis
M18 YXE                                                    ; Unlock X, Y, and E axis

```
**current-sense-homing.g - v08/03/20**
```g-code
; 0:/sys/current-sense-homing.g
; Current and Sensitivity for homing routines

M915 X S2 F0 H400 R0                                       ; Set X axis Sensitivity
M915 Y S2 F0 H400 R0                                       ; Set y axis Sensitivity
M913 X20 Y20 Z60                                           ; set X Y Z motors to X% of their normal current
```
**current-sense-normal.g - v08/03/20**
```g-code
; 0:/sys/current-sense-normal.g
; Current and Sensitivity for normal routine

M913 X100 Y100 Z100                                        ; set X Y Z motors to 100% of their normal current
M915 X S3 F0 H200 R0                                       ; Set X axis Sensitivity
M915 Y S3 F0 H200 R0                                       ; Set y axis Sensitivity
```
**deployprobe.g - v08/03/20**
```g-code
; 0:/sys/deployprobe.g
; called to deploy a physical Z probe

M280 P0 S10                                                ; deploy BLTouch
```
**dwc2settings.json - v08/03/20**
```g-code
{"main":{"language":"en","lastHostname":"10.0.1.124","darkTheme":false,"useBinaryPrefix":true,"disableAutoComplete":false,"settingsStorageLocal":false,"settingsSaveDelay":2000,"cacheStorageLocal":true,"cacheSaveDelay":4000,"notifications":{"errorsPersistent":false,"timeout":5000},"webcam":{"url":"","updateInterval":5000,"liveUrl":"","useFix":false,"embedded":false,"rotation":0,"flip":"none"}},"machine":{"ajaxRetries":2,"updateInterval":250,"extendedUpdateEvery":20,"fileTransferRetryThreshold":358400,"crcUploads":true,"pingInterval":2000,"babystepAmount":0.05,"codes":[],"displayedExtraTemperatures":[2,3,4],"displayedExtruders":[0,1],"displayedFans":[-1,0],"moveSteps":{"X":[100,50,10,1,0.1],"Y":[100,50,10,1,0.1],"Z":[50,25,5,0.5,0.05],"default":[100,50,10,1,0.1]},"moveFeedrate":6000,"extruderAmounts":[100,50,20,10,5,1],"extruderFeedrates":[60,30,15,5,1],"temperatures":{"tool":{"active":[250,235,220,205,195,160,120,100,0],"standby":[210,180,160,140,0]},"bed":{"active":[110,100,90,70,65,60,0],"standby":[40,30,0]},"chamber":[]},"spindleRPM":[]}}
```
**filament-change.g - v08/03/20**
```g-code
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
```
**filaments.csv - v08/03/20**
```g-code
RepRapFirmware filament assignment file v1 generated at 2020-08-01 15:01
extruder,filament
0,PETG

```
**filaset - v08/03/20**
```g-code
; 0:/sys/filaset
; This gcode is used by Filament Handling Macro
T0 M702
T0 M701 S"PETG"

```
**homeall.g - v08/03/20**
```g-code
; 0:/sys/homeall.g
; home x, y, and z axis

M98 P"current-sense-homing.g"                              ; Current and Sensitivity for homing routines

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release
G4 P100                                                    ; BLTouch, delay for release command

G91                                                        ; relative positioning
G1 Z3 F800 H2                                              ; lift Z relative to current position

; HOME X
G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop 
G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop, second check 

; HOME Y
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop 
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstops, second check

; HOME Z
G1 H2 Z2 F2600                                             ; raise head 2mm to ensure it is above the Z probe trigger height
G90                                                        ; back to absolute mode
G1 X15 Y15 F6000                                           ; go to first probe point
G30                                                        ; home Z by probing the bed

G90                                                        ; absolute positioning
G1 H0 Z5 F400                                              ; lift Z relative to current position

M98 P"current-sense-normal.g"                              ; Current and Sensitivity for normal routine
```
**homex.g - v08/03/20**
```g-code
; 0:/sys/homex.g
; home the x axis

M98 P"current-sense-homing.g"                              ; Current and Sensitivity for homing routines

G91                                                        ; relative positioning

G1 Z3 F800 H2                                              ; lift Z relative to current position

G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop 

G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop, second check

G1 Z-3 F800 H2                                             ; place Z back to starting position

M98 P"current-sense-normal.g"                              ; Current and Sensitivity for normal routine
```
**homey.g - v08/03/20**
```g-code
; 0:/sys/homey.g
; home the y axis

M98 P"current-sense-homing.g"                              ; Current and Sensitivity for homing routines

G91                                                        ; relative positioning

G1 Z3 F800 H2                                              ; lift Z relative to current position
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop 
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop, second check

G1 Z-3 F800 H2                                             ; place Z back to starting position

M98 P"current-sense-normal.g"                              ; Current and Sensitivity for normal routine
```
**homez.g - v08/03/20**
```g-code
; 0:/sys/homez.g
; home the z axis

M98 P"current-sense-homing.g"                              ; Current and Sensitivity for homing routines

; !!! If using Pinda, comment-out the following two lines
M280 P0 S160                                               ; BLTouch, alarm release
G4 P100                                                    ; BLTouch, delay for release command

G91                                                        ; relative positioning
G1 H0 Z3 F6000                                             ; lift Z relative to current position
G90                                                        ; absolute positioning

G1 X15 Y15 F6000                                           ; go to first probe point
G30                                                        ; home Z by probing the bed

G90                                                        ; absolute positioning
G1 H0 Z5 F400                                              ; lift Z relative to current position

M98 P"current-sense-normal.g"                              ; Current and Sensitivity for normal routine
```
**pause.g - v08/03/20**
```g-code
; 0:/sys/pause.g
; called when a print from SD card is paused

if sensors.filamentMonitors[0].filamentPresent = false
   G1 E-3 F3000                                            ; if filament has run out, retract 6mm of filament

M83                                                        ; relative extruder moves
G1 E-3 F3000                                               ; retract 3mm of filament
G91                                                        ; Relative Positioning
G1 Z10 F360                                                ; Raise Z
G90                                                        ; Absolute Values
G1 X10 Y0 F6000                                            ; Parking Position
M300 S80 P2000                                             ; play beep sound

```
**primeline.g - v08/03/20**
```g-code
; 0:/sys/primeline.g
; Print prime-line at a 'randomized' Y positon from -1.1 to -2.9

G1 X0 Z0.6 Y{-2+(0.1*(floor(10*(cos(sqrt(sensors.analog[0].lastReading * state.upTime))))))} F3000.0;
G92 E0.0                                                   ; set E position to 0
G1 Z0.2 X100.0 E30.0 F1000.0                               ; prime line
G92 E0.0                                                   ; set E position to 0
M400                                                       ; finish all current moves / clear the buffer
```
**resume.g - v08/03/20**
```g-code
; 0:/sys/resume.g
; called before a print from SD card is resumed

G1 R1 X0 Y0 Z5 F8000                                       ; go to 5mm above position of the last print move
G1 R1 X0 Y0                                                ; go back to the last print move
;G1 E2 F1000                                               ; Feed 70mm of filament at 800mm/min
M83                                                        ; relative extruder moves
```
**retractprobe.g - v08/03/20**
```g-code
; 0:/sys/retractprobe.g
; called to retract a physical Z probe

M280 P0 S90                                                ; retract BLTouch
```
**sleep.g - v08/03/20**
```g-code
; 0:/sys/sleep.g
; called when M1 (Sleep) is being processed

M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
M18 XEZY                                                   ; unlock all axis

```
**start.g - v08/03/20**
```g-code
; 0:/sys/start.g
; Executed before each print - BEFORE ANY SLICER CODE IS RAN

;M280 P0 S160                                              ; BLTouch, alarm release
;G4 P100                                                   ; BLTouch, delay for release command
M572 D0 S0.0                                               ; clear pressure advance
M703                                                       ; Execute loaded filement's config.g
G28                                                        ; Home all

; if using BLTouch probe, use the following line:
G1 Z100                                                    ; Last chance to check nozzle cleanliness
; if using Pinda type probe, use the following line to place probe center of bed to heat the probe
;G1 Z5 X100 Y100                                           ; Place nozzle center of bed, 5mm up

M220 S100                                                  ; Set speed factor back to 100% in case it was changed
M221 S100                                                  ; Set extrusion factor back to 100% in case it was changed
M290 R0 S0                                                 ; Clear babystepping
M106 S0                                                    ; Turn part cooling blower off if it is on
M116                                                       ; wait for all temperatures
G32                                                        ; Level bed
G29                                                        ; Bed mesh
G90                                                        ; Absolute Positioning
M83                                                        ; Extruder relative mode
M98 P"0:/sys/current-sense-normal.g"                       ; Ensure that motor currents and sense are set for printing 
G1 X0 Y0 Z2                                                ; Final position before slicer's temp is reached and primeline is printed.
 
; The primeline macro is executed by the slicer gcode to enable direct printing
; of the primeline at the objects temp and to immediately print the object
; following primeline completion. 

; Slicer generated gcode takes it away from here

```
**stop.g - v08/03/20**
```g-code
; 0:/sys/stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

M83                                                        ; Set extruder to relative mode
M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
G1 F1000.0                                                 ; set feed rate
G1 E-2                                                     ; retract
G1 X110 Y200 Z205 F3000                                    ; place nozzle center/top
M400                                                       ; Clear queue
M18 YXE                                                    ; unlock X, Y, and E axis

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
M400

```

# **MACROS DIRECTORY - v08/03/20**

**Filament Handling - v08/03/20**
```g-code
; 0:/macros/Filament Handling
; Macro used for all filament handling evolutions

if state.status != "processing"                                  ; Printer is not currently printing!

   if sensors.filamentMonitors[0].filamentPresent = true
   
      M291 P"Press OK to begin filament UNLOADING, else press CANCEL to exit." R"Filament Handling" S3
      M291 P"Please wait while the nozzle is being heated." T5   ; Display message
      M98 P"0:/macros/Heat Nozzle"                               ; heat nozzle to predetermined temp
      M291 P"Ready for filament unloading. Gently pull filament and press OK." R"Filament Handling" S2
      M291 P"Retracting filament..." T5                          ; Display another message
      G1 E-150 F5000                                             ; Retract filament
      M400                                                       ; Wait for the moves to finish
      T0 M702                                                    ; Select tool 0, set filament is unloaded
      M104 S-273                                                 ; turn off hotend
      M140 S-273                                                 ; turn off heatbed
      M98 P"0:/macros/Filament Handling"; run again              ; Now that filament is unloaded, lets ask to load filament

   else

      M291 P"Press OK to begin filament LOADING, else press CANCEL to exit." R"Filament Handling" S3
      M291 P"Please wait while the nozzle is being heated." T5   ; Display message
      M98 P"0:/macros/Heat Nozzle"                               ; heat nozzle to predetermined temp
      M291 P"Ready for filament loading. Insert filament and press OK." R"Filament Handling" S2
      M291 P"Feeding filament..." T5                             ; Display new message
      G1 E150 F450                                               ; Feed 150mm of filament at 600mm/min
      G1 E20 F100                                                ; Feed 20mm of filament at 100mm/min
      G4 P1000                                                   ; Wait one second
      G1 E-1 F1800                                               ; Retract 10mm of filament at 1800mm/min
      M400                                                       ; Wait for moves to complete
      M98 P"0:/sys/filaset"                                      ; Set system filament type
      M400                                                       ; Wait for moves to complete
      M104 S-273                                                 ; turn off hotend
      M140 S-273                                                 ; turn off heatbed

else

   M291 P"Press OK to begin filament CHANGE, else press CANCEL to exit." R"Filament Handling" S3
   M98 P"0:/sys/filament-change.g"                               ; call filament-change.g
   M24                                                           ; Start/resume SD print

```
**Heat Nozzle - v08/03/20**
```g-code
; 0:/macros/Heat Nozzle
; Heat nozzle to set temp

M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T5
T0                                  ; Select Tool 0
M109 S230                           ; set temp to 230c and wait

```
**Set Filament Type - v08/03/20**
```g-code
; 0:/macros/Set Filament Type
; Macro used to set system's loaded filament type

if sensors.filamentMonitors[0].filamentPresent = false           ; if filament is loaded then reject action to change filament type

  M291 P"Press OK to change filament type, else press CANCEL to exit." R"Filament Handling" S3

  ; Set PLA temp
  M28 "0:/macros/Heat Nozzle"                                    ; Begin writing to SD card file
  ; 0:/macros/Heat Nozzle
  ; Heat nozzle to set temp
  M291 R"Filament Handling" P"Heating nozzle for PLA, please wait." S0 T5
  T0                                                             ; Activate Hotend
  M109 S200                                                      ; set temp to 200c and wait
  M29                                                            ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                           ; Begin writing to SD card file
  ; 0:/sys/filaset
  ; This gcode is used by Filament Handling Macro
  T0 M702                                                        ; Set system filament as UNLOADED
  T0 M701 S"PLA"                                                 ; Set system filament as PLA
  M29                                                            ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to PLA. Press cancel to save this selection or OK to proceed to next filament type."
  
  ; Set PETg temp
  M28 "0:/macros/Heat Nozzle"                                    ; Begin writing to SD card file
  ; 0:/macros/Heat Nozzle
  ; Heat nozzle to set temp
  M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T5
  T0                                                             ; Activate Hotend
  M109 S230                                                      ; set temp to 230c and wait
  M29                                                            ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                           ; Begin writing to SD card file
  ; 0:/sys/filaset
  ; This gcode is used by Filament Handling Macro
  T0 M702                                                        ; Set system filament as UNLOADED
  T0 M701 S"PETG"                                                ; Set system filament as PETG
  M29                                                            ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to PETg. Press cancel to save this selection or OK to proceed to next filament type."

  ; Set ABS temp
  M28 "0:/macros/Heat Nozzle"                                    ; Begin writing to SD card file
  ; 0:/macros/Heat Nozzle
  ; Heat nozzle to set temp
  M291 R"Filament Handling" P"Heating nozzle for ABS, please wait." S0 T5
  T0                                                             ; Activate Hotend
  M109 S250                                                      ; set temp to 250c and wait
  M29                                                            ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                           ; Begin writing to SD card file
  ; 0:/sys/filaset
  ; This gcode is used by Filament Handling Macro
  T0 M702                                                        ; Set system filament as UNLOADED
  T0 M701 S"ABS"                                                 ; Set system filament as ABS
  M29                                                            ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to ABS. Press cancel to save this selection or OK to proceed to next filament type."

  ; Set PC temp
  M28 "0:/macros/Heat Nozzle"                                    ; Begin writing to SD card file
  ; 0:/macros/Heat Nozzle
  ; Heat nozzle to set temp
  M291 R"Filament Handling" P"Heating nozzle for PC, please wait." S0 T5
  T0                                                             ; Activate Hotend
  M109 S270                                                      ; set temp to 270c and wait
  M29                                                            ; Stop writing to SD card
  
  M28 "0:/sys/filaset"                                           ; Begin writing to SD card file
  ; 0:/sys/filaset
  ; This gcode is used by Filament Handling Macro
  T0 M702                                                        ; Set system filament as UNLOADED
  T0 M701 S"PC"                                                  ; Set system filament as PC
  M29                                                            ; Stop writing to SD card

  M291 S3 R"Filament Handling" P"Filament type currently set to PC. Press cancel to save this selection or OK to proceed to next filament type."

else

 M291 S3 R"Filament Handling" P"Filament is currently loaded. Please unload filament before changing filament type."


```



# **FILAMENTS DIRECTORY - v08/03/20**

## **ABS DIRECTORY - v08/03/20**

**config.g - v08/03/20**

```g-code
; 0:/filaments/ABS/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300          ; play some tones
M140 S75                                         ; set bed temp
M104 S150                                        ; set extruder warm-up temp
                                                 ; active temp set from slicer gcode

; Insert additional filament specific settings here

```
**load.g - v08/03/20**
```g-code

```
**unload.g - v08/03/20**
```g-code

```

## **PC DIRECTORY - v08/03/20**

**config.g - v08/03/20**

```g-code
; 0:/filaments/PC/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300          ; play some tones
M140 S75                                         ; set bed temp
M104 S150                                        ; set extruder warm-up temp
                                                 ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/03/20**
```g-code

```
**unload.g - v08/03/20**
```g-code

```

## **PETG DIRECTORY - v08/03/20**

**config.g - v08/03/20**

```g-code
; 0:/filaments/PETG/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300          ; play some tones
M140 S75                                         ; set bed temp
M104 S150                                        ; set extruder warm-up temp
                                                 ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/03/20**
```g-code

```
**unload.g - v08/03/20**
```g-code

```

## **PLA DIRECTORY - v08/03/20**

**config.g - v08/03/20**

```g-code
; 0:/filaments/PLA/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300          ; play some tones
M140 S65                                         ; set bed temp
M104 S150                                        ; set extruder warm-up temp
                                                 ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/03/20**
```g-code

```
**unload.g - v08/03/20**
```g-code

```
