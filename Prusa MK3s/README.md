# Zaribo/Prusa i3 MK3s - Duet 2 WiFi - RRF 3.11

## MK3s - Duet 2 WiFi wiring guide [PDF](Duet-MK3s.pdf)    

<br>

## **Hardware changes from stock MK3s:**

*Note: The config.g file contains notes to facilitate easy adaptation to stock Prusa MK3s.*

- Bondtech Mosquito Extruder  

- 0.9 Stepper motors on X & Y axis (17HM15-0904S @ omc-stepperonline.com) 	

- Duet WiFi  
  
- PanelDue 5i  
  
- PT1000 hotend thermistor  
  
- BLTouch v3.1  
  
  <br><br>

## **:interrobang:What do those hardware changes mean for your config?**  
**:wrench:Motors, microstepping resolution, and steps/mm.**  
Unless you have the same setup as referenced above, you may have to change the microstepping resolution and the steps per millimeter located in the 'config.g' file. To retrieve your current machine's configuration, issue a M503 command in the terminal connected to the running printer. Pay attention to the microstepping assigned to the axis as that can change your steps per millimeter. Read through the /sys/config.g file comments and make the applicable changes as needed.  *More about this can be read here: https://duet3d.dozuki.com/Wiki/Choosing_and_connecting_stepper_motors, here: https://www.linearmotiontips.com/microstepping-basics/, and here: https://blog.prusaprinters.org/calculator3416/.*  

:warning:Once you have changed/verified the motor settings, review the networking top portion of the file. When completed, copy all the files located in the 'sys', 'macros', and 'filaments' directory over to your sd-card. The 'www' and 'gcode' folder are present in the repository for reference and should not be needed to copy over to the sd-card in normal circumstances. *More can be read about sd-card here: https://duet3d.dozuki.com/Wiki/SDCard, more can be read about macros here: https://duet3d.dozuki.com/Wiki/Macros.*  

**:wrench:Sensorless Homing / Stallguard sensitivity.**  
The TMC2660 drivers used on the Duet WiFi support the stallGuard feature. This feature allows the driver to detect motor stalls under some circumstances. Stall detection may be useful for detecting when a motor has skipped steps due to the nozzle hitting an obstruction, and for homing the printer without using endstop switches.  
As the given configuration files were authored while using 0.9 degree stepper motors on the X and Y axis, you may need to adjust your stallguard sensitivity and sensorless homing. For stallguard sensitivity, look for the "M915" in the current-sense-homing.g and current-sense-normal.g files. *Read the full documentation here: https://duet3d.dozuki.com/Wiki/Stall_detection_and_sensorless_homing.*

**:bulb:Use the included Macros for filament handling.**  
To make filament loading, unloading, and changing the most straightforward and simplistic possible evolution, I have made a macro set that is readily accessible from the PanelDue.  To take full advantage of the duet filament system you will need to make the system filaments PLA, PETG, ABS, and PC. This will allow you to have custom instructions for each different filament, by adding such to the filament's config.g file. *!Note: Based on my current macro version, it is required that each filament's load.g and unload.g remain empty. Placing code into these files will make these macro fail.*  
**"Set Filament Type"** asks what type filament you are going to use; PLA, PETg, ABS, or PC. Based on the selection, this macro rewrites the "Heat Nozzle" macro to heat the nozzle for the selected filament type.  *!Note: This macro only has to be executed once for the given filament type change as it's settings are nonvolatile, regardless of reset or power off. !Note: The script will not let you change the filament type while filament is loaded.*   
**"Filament Handling"** is for any filament unloading, loading, and changing regardless of the printer's state, printing or not. This macro will load, unload, and change filament based on two conditions; whether it detects filament is currently loaded or not, and if a print is in progress or not.  *!Note: The logic function in the macro retrieves the current status of the filament sensor to base the perceived desired action to enact. If your printer's filament is currently empty and you intend to load filament, please do not place it into the extruder until requested to do so by the macro. Else the macro will determine that filament is loaded and that you desire to unload filament, instead of load.*   
**"Heat Nozzle"** is created by the "Set Filament Type" macro and can be selected to heat the hotend to the set temperature for the last chosen filament type. You do not need to run this to change filament, the "Filament Handling" macro automatically runs this macro to perform the heating of the hotend to carry out the filament handling, whether it be loading, unloading, or changing.

![Start Screen](Start-screen.jpg)

## **Print flow events:**   
When initiating a print, the following sequence of events occur in this order.  
**/sys/start.g** is the first codeset that starts at the beginning of each print. This contains the generic processes that apply to all filament types. From this codeset, the fillament's config.g is called.  
**/filaments/PETG/config.g** is the second codeset that get initiated from the "M703" command in the "start.g" file. As written in this example, we are set to use the PETG "config.g" file, located in the "filaments/PETG" directory. This contains the gcode commands that are particular to PETG filament type.  
**Slicer's Start GCode** is the last bit of codeset to be executed before the object's sliced gcode starts. This contains the settings particulr to the actual print and the exact PETG filament loaded. This would be your *'fine'* settings, where PETG/config.g could be considered your *'medium'* settings, and start.g would be the *'rough'* - performing evaluations to get the printer ready.    
**The part's actual gcode** made by the slicer.  
**Slicer's End GCode** follows the printed object's gcode. This codeset lets the duet know that the print is finished which calls  
 **/sys/stop.g**, the very last codeset that is executed. This last part commonly shutdowns heaters, retracts a bit of filament, and positions the machine to easily retrieve the printed part.  

<br><br>

## **Additional notes:**  
**:bulb:Electrically independent Z motors**: On printers, such as MK3, which uses two Z motors to raise/lower the bed or gantry, you can have the firmware probe the bed and adjust the motors individually to eliminate tilt.  The auto calibration uses a least squares algorithm that minimises the sum of the height errors. The deviation before and expected deviation after calibration is reported. Run G32 to initiate the process. *Read the full documentation here: https://duet3d.dozuki.com/Wiki/Bed_levelling_using_multiple_independent_Z_motors.*  

**:bulb:PINDA v2**: Pinda version 2 is upgraded from the previous version in that it now has an integrated thermistor, which this configuration electrically ties to thermistor E1 on the duet.  Pinda temperature compensation has to be mitigated via g-code macro but will be handled via integrated function within the duet firmware shortly.  *Read @Argo's posting in the Duet forums: https://forum.duet3d.com/topic/16972/pinda-2-probe-with-temperature-compensation?_=1593546022132.*    

**:bulb:BLTouch v3.1**: The config.g has comment sections for using this probe and the wiring guide covers the electrical installation of the BLTouch v3.1 in the last few pages. *Read the full documentation here: https://duet3d.dozuki.com/Wiki/Connecting_a_Z_probe*      

<br><br>

### **Example start gcode for ideaMaker Slicer:**  

```g-code
; ideaMaker Start G-Code

; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S{temperature_heatbed}              ; set bed temp
M104 S{temperature_extruder1}            ; set extruder temp
M116                                     ; wait for all temperatures

; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                ; primeline macro

; Set pressure advance
M572 D0 S0.07                            ; set pressure advance
```

### **Example end gcode for ideaMaker Slicer:**  

```g-code
; ideaMaker End G-Code
M400                                     ; Make sure all moves are complete
M0                                       ; Stop everything and run sys/stop.g
```

<br>

<br>

### **Example start gcode for Simplify3D Slicer:**  

```g-code
; Simplify3D Start G-Code

; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S[bed0_temperature]                         ; set bed temp
M104 S[extruder0_temperature]                    ; set extruder temp
M116                                             ; wait for all temperatures

; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                        ; primeline macro

; Set pressure advance
M572 D0 S0.07                                    ; set pressure advance
```

### **Example end gcode for Simplify3D Slicer:**  

```g-code
; Simplify3D End G-Code
M400                                             ; Make sure all moves are complete
M0  
```

<br>

<br>

### **Example start gcode for Prusa Slicer:**  

```g-code
; PrusaSlicer Start G-Code:

; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S[first_layer_bed_temperature]      ; set bed temp
M104 S[first_layer_temperature]          ; set extruder temp
M116                                     ; wait for all temperatures

; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                ; primeline macro

; Set pressure advance
M572 D0 S0.07                            ; set pressure advance
```
### **Example end gcode for Prusa Slicer:**  

```g-code
; PrusaSlicer End G-Code
M400                                     ; Make sure all moves are complete
M0                                       ; Stop everything and run sys/stop.g
```

<br>



**It is highly recommend to read through the very detailed Duet Wiki pages at https://duet3d.dozuki.com. RepRapFirmware supported G-code reference can be found here https://duet3d.dozuki.com/Wiki/Gcode#main.*

<br><br>

## DUET System (sd-card contents) files follow:

***Always use the github folders as they will contain the latest revisions of these files.**

### 0:/sys/

**bed.g - v08/06/20**

```g-code
; 0:/sys/bed.g
; Called to perform automatic bed compensation via G32

M561                                                       ; Clear any bed transform
G28                                                        ; Home

while iterations <=2                                       ; Perform 3 passes
   G30 P0 X25 Y107 Z-99999                                 ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y107 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors
   G90                                                     ; Set to Absolute Positioning
   G1 X100 F10000                                          ; Move to center
   G30                                                     ; Probe the bed at the current XY position
   M400                                                    ; Finish moves, clear buffer

while move.calibration.initial.deviation >= 0.002          ; perform additional tramming if previous deviation was over 0.002mm 
   if iterations = 5                                       ; Perform 5 addition checks, if needed
      M300 S3000 P500                                      ; Sound alert, required deviation could not be achieved
      abort "!!! ABORTED !!! Failed to achieve < 0.002 deviation. Current deviation is " ^ move.calibration.initial.deviation ^ "mm."
   G30 P0 X25 Y107 Z-99999                                 ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y107 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors
   G90                                                     ; Set to Absolute Positioning
   G1 X100 F10000                                          ; Move to center
   G30                                                     ; Probe the bed at the current XY position
   M400                                                    ; Finish moves, clear buffer

echo "Gantry deviation of " ^ move.calibration.initial.deviation ^ "mm obtained."
G1 Z8                                                      ; Raise head 8mm to ensure it is above the Z probe trigger height
```
**cancel.g - v08/06/20**
```g-code
; 0:/sys/cancel.g
; called when a print is canceled after a pause.

M83                                                        ; Makes the extruder interpret extrusion values as relative positions
M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
G1 F1000.0                                                 ; set feed rate
G1 E-2                                                     ; retract 2mm
M98 P"current-sense-homing.g"                              ; Set current and sensitivity for homing routines
M18 YXE                                                    ; unlock X, Y, E axis

```
**config.g - v08/06/20**
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
M569 P2 S1                                                 ; Drive 2 goes forwards: Z Axis Left
M569 P3 S0                                                 ; Drive 3 goes backwards: E Axis
M569 P4 S1                                                 ; Drive 4 goes forwards: Z Axis Right (using E1)

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
M98 P"current-sense-homing.g"                              ; Current and Sensitivity for normal routine

; Z-Probe Settings for BLTouch
M558 P9 C"^zprobe.in" H5 F600 T10000                       ; BLTouch, connected to Z probe IN pin
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
M912 P0 S-5.5                                              ; MCU Temp calibration - default reads 5.5c higher than ambient

; Tools
M563 P0 D0 H1 F0                                           ; Define tool 0
G10 P0 X0 Y0 Z0                                            ; Set tool 0 axis offsets
G10 P0 R0 S0                                               ; Set initial tool 0 active and standby temperatures to 0C
T0                                                         ; Set Tool 0 active

; Relase X, Y, and E axis
M18 YXE                                                    ; Unlock X, Y, and E axis

```
**current-sense-homing.g - v08/06/20**
```g-code
; 0:/sys/current-sense-homing.g
; Current and Sensitivity for homing routines

M915 X S2 F0 H400 R0                                       ; Set X axis Sensitivity
M915 Y S2 F0 H400 R0                                       ; Set y axis Sensitivity
M913 X20 Y20 Z60                                           ; set X Y Z motors to X% of their normal current
```
**current-sense-normal.g - v08/06/20**
```g-code
; 0:/sys/current-sense-normal.g
; Current and Sensitivity for normal routine

M913 X100 Y100 Z100                                        ; set X Y Z motors to 100% of their normal current
M915 X S3 F0 H200 R0                                       ; Set X axis Sensitivity
M915 Y S3 F0 H200 R0                                       ; Set y axis Sensitivity
```
**deployprobe.g - v08/06/20**
```g-code
; 0:/sys/deployprobe.g
; called to deploy a physical Z probe

M280 P0 S10                                                ; deploy BLTouch
```
**dwc2settings.json - v08/06/20**
```g-code
{"main":{"language":"en","lastHostname":"10.0.1.124","darkTheme":false,"useBinaryPrefix":true,"disableAutoComplete":false,"settingsStorageLocal":false,"settingsSaveDelay":2000,"cacheStorageLocal":true,"cacheSaveDelay":4000,"notifications":{"errorsPersistent":false,"timeout":5000},"webcam":{"url":"","updateInterval":5000,"liveUrl":"","useFix":false,"embedded":false,"rotation":0,"flip":"none"}},"machine":{"ajaxRetries":2,"updateInterval":250,"extendedUpdateEvery":20,"fileTransferRetryThreshold":358400,"crcUploads":true,"pingInterval":2000,"babystepAmount":0.05,"codes":[],"displayedExtraTemperatures":[2,3,4],"displayedExtruders":[0,1],"displayedFans":[-1,0],"moveSteps":{"X":[100,50,10,1,0.1],"Y":[100,50,10,1,0.1],"Z":[50,25,5,0.5,0.05],"default":[100,50,10,1,0.1]},"moveFeedrate":6000,"extruderAmounts":[100,50,20,10,5,1],"extruderFeedrates":[60,30,15,5,1],"temperatures":{"tool":{"active":[250,235,220,205,195,160,120,100,0],"standby":[210,180,160,140,0]},"bed":{"active":[110,100,90,70,65,60,0],"standby":[40,30,0]},"chamber":[]},"spindleRPM":[]}}
```
**filament-change.g - v08/06/20**
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
**filaments.csv - v08/06/20**
```g-code
RepRapFirmware filament assignment file v1 generated at 2020-08-01 15:01
extruder,filament
0,PETG

```
**filaset - v08/06/20**
```g-code
T0 M702                                                     
T0 M701 S"PETG"                                             

```
**homeall.g - v08/06/20**

```g-code
; 0:/sys/homeall.g
; home x, y, and z axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

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
```
**homex.g - v08/06/20**
```g-code
; 0:/sys/homex.g
; home the x axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

G91                                                        ; relative positioning

G1 Z3 F800 H2                                              ; lift Z relative to current position

G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop 

G1 H0 X5 F1000                                             ; move slowly away 
G1 H1 X-255 F3000                                          ; move quickly to X endstop, second check

G1 Z-3 F800 H2                                             ; place Z back to starting position
```
**homey.g - v08/06/20**
```g-code
; 0:/sys/homey.g
; home the y axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

G91                                                        ; relative positioning

G1 Z3 F800 H2                                              ; lift Z relative to current position
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop 
G1 H0 Y5 F1000                                             ; move slowly away 
G1 H1 Y-215 F3000                                          ; move quickly to Y endstop, second check

G1 Z-3 F800 H2                                             ; place Z back to starting position
```
**homez.g - v08/06/20**
```g-code
; 0:/sys/homez.g
; home the z axis

M98 P"current-sense-homing.g"                              ; Ensure current and sensitivity is set for homing routines

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
```
**pause.g - v08/06/20**
```g-code
; 0:/sys/pause.g
; called when a print from SD card is paused

M120                                                       ; Push the state of the machine onto a stack

if sensors.filamentMonitors[0].filamentPresent = false
   G1 E-3 F1000                                            ; if filament has run out, retract 6mm of filament

M83                                                        ; relative extruder moves
G1 E-3 F3000                                               ; retract 3mm of filament
G91                                                        ; Relative Positioning
G1 Z10 F360                                                ; Raise Z
G90                                                        ; Absolute Values
G1 X10 Y0 F6000                                            ; Parking Position
M300 S80 P2000                                             ; play beep sound

```
**primeline.g - v08/06/20**
```g-code
; 0:/sys/primeline.g
; Print prime-line at a 'randomized' Y positon from -1.1 to -2.9
; Prime line routine from second line down ref: http://projects.ttlexceeded.com

G1 X0 Z0.6 Y{-2+(0.1*(floor(10*(cos(sqrt(sensors.analog[0].lastReading * state.upTime))))))} F3000.0;
G0 Z0.15                                                   ; Primeline nozzle position
G92 E0.0                                                   ; Reset extrusion distance
G1 E2 F1000                                                ; De-retract and push ooze
G1 X20.0 E6 F1000.0                                        ; Fat 20mm intro line @ 0.30
G1 X60.0 E3.2 F1000.0                                      ; Thin +40mm intro line @ 0.08
G1 X100.0 E6 F1000.0                                       ; Fat +40mm intro line @ 0.15
G1 E-0.8 F3000                                             ; Retract to avoid stringing
G1 X99.5 E0 F1000.0                                        ; -0.5mm wipe action to avoid string
G1 X110.0 E0 F1000.0                                       ; +10mm intro line @ 0.00
G1 E0.6 F1500                                              ; De-retract
G92 E0.0                                                   ; Reset extrusion distance
M400                                                       ; Finish all current moves / clear the buffer
```
**resume.g - v08/06/20**
```g-code
; 0:/sys/resume.g
; called before a print from SD card is resumed

M98 P"current-sense-normal.g"                              ; Ensure current and sensitivity is set for normal routines
G1 E3 F400                                                 ; extract 3mm of filament
G1 R1 X0 Y0 Z5                                             ; go back to the last print position with Z 5mm above
G1 R1 Z0                                                   ; go to Z position of the last print move
M121                                                       ; Recover the last state pushed onto the stack

```
**retractprobe.g - v08/06/20**
```g-code
; 0:/sys/retractprobe.g
; called to retract a physical Z probe

M280 P0 S90                                                ; retract BLTouch
```
**sleep.g - v08/06/20**
```g-code
; 0:/sys/sleep.g
; called when M1 (Sleep) is being processed

M104 S-273                                                 ; turn off hotend
M140 S-273                                                 ; turn off heatbed
M107                                                       ; turn off fan
M18 XEZY                                                   ; unlock all axis

```
**start.g - v08/06/20**
```g-code
; 0:/sys/start.g
; Executed before each print - BEFORE ANY SLICER CODE IS RAN

T0                                                         ; Ensure tool is selected
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
**stop.g - v08/06/20**
```g-code
; 0:/sys/stop.g
; called when M0 (Stop) is run (e.g. when a print from SD card is cancelled)

M83                                                        ; Set extruder to relative mode
M106 S255                                                  ; Turn fan fully on
M104 S-273                                                 ; Turn off hotend
M140 S-273                                                 ; Turn off heatbed
G1 F1000.0                                                 ; Set feed rate
G1 E-2.5                                                   ; Retract 2.5mm
M98 P"current-sense-homing.g"                              ; Adjust current and sensitivity for homing routines
G1 X0 Y215 Z205 F1000                                      ; Place nozzle to left side, build plate to front, Z at top
M400                                                       ; Clear queue
M107                                                       ; Turn off fan
M18 YXE                                                    ; Unlock X, Y, and E axis

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


### 0:/macros

**Filament Handling - v08/06/20**

```g-code
; 0:/macros/Filament Handling
; Macro used for all filament handling evolutions

if state.status != "processing"                            ; Printer is not currently printing!

   if sensors.filamentMonitors[0].filamentPresent = true   ; Filament is detected, currently loaded
   
      M291 P"Press OK to begin filament UNLOADING, else press CANCEL to exit." R"Filament Handling" S3
      M291 P"Please wait while the nozzle is being heated." T5 
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
      M291 P"Please wait while the nozzle is being heated." T5 
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
**Heat Nozzle - v08/06/20**
```g-code
; 0:/macros/Heat Nozzle
; Heat nozzle to set temp

M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T5
T0                                                         ; Select Tool 0
M109 S230                                                  ; set temp to 230c and wait

```
**Hotmesh - v08/06/20**
```g-code
; 0:/macros/hotmesh.g
; Called to perform automatic heated bedmesh compensation

T0                                                         ; Ensure tool is selected
M703                                                       ; Heat bed to set temp based off current system filament type
M104 S-273                                                 ; Turn off hotend
M106 S0                                                    ; Turn part cooling blower off if it is on
M291 P{"Performing bed heatup per " ^ move.extruders[0].filament ^ " profile. This process will take approximately 6 minutes."} R"Hotmesh" S0 T10
G28                                                        ; Home
G1 X100 Y100                                               ; Place nozzle center of bed

; Give 5 minutes for stabilization
G91                                                        ; Set to Rel Positioning
while iterations <=9                                       ; Perform 10 passes
    G1 Z15                                                 ; Move Z 15mm up
    G4 S0.5                                                ; Wait .5 seconds
M116                                                       ; Wait for all temperatures
M291 P{"Bed temperature at setpoint. Please wait 5 minutes for stabilization, Z indicates countdown."} R"Hotmesh" S0 T10
; Start countdown - use Z as indicator   
while iterations <=9                                       ; Perform 10 passes
    G4 S30                                                 ; Wait 30 seconds
    G1 Z-15                                                ; Move Z 15mm down
G90                                                        ; Set to Absolute Positioning
M291 P{"Performing homing, gantry alignment, and mesh probing. Please wait."} R"Hotmesh" S0 T10

G32                                                        ; Home and Level gantry
M400                                                       ; Clear queue
G29                                                        ; Perfrom bed mesh
M104 S-273                                                 ; Turn off hotend
M140 S-273                                                 ; Turn off heatbed
M291 P{"Hotmesh complete. Hotend and Heatbed are turned off. Performing final homing routine. Please wait."} R"Hotmesh" S0 T10
G28                                                        ; Home
```
**Set Filament Type - v08/06/20**

```g-code
; 0:/macros/Set Filament Type
; Macro used to set system's loaded filament type

if sensors.filamentMonitors[0].filamentPresent = false        ; if filament is loaded then reject action to change filament type

  M291 P{"System filament is currently set to " ^ move.extruders[0].filament ^ ". Press OK to change filament type, else press CANCEL to exit."} R"Filament Handling" S3

  ; Set PLA temp
  M28 "0:/macros/Heat Nozzle"                                 ; Begin writing to SD card file
  M291 R"Filament Handling" P"Heating nozzle for PLA, please wait." S0 T5
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
  M291 R"Filament Handling" P"Heating nozzle for PETg, please wait." S0 T5
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
  M291 R"Filament Handling" P"Heating nozzle for ABS, please wait." S0 T5
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
  M291 R"Filament Handling" P"Heating nozzle for PC, please wait." S0 T5
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


### 0:/filaments/ABS

**config.g - v08/06/20**

```g-code
; 0:/filaments/ABS/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                     ; play some tones
M140 S75                                                    ; set bed temp
M104 S150                                                   ; set extruder warm-up temp
                                                            ; active temp set from slicer gcode

; Insert additional filament specific settings here

```
**load.g - v08/06/20**
```g-code
; LEAVE EMPTY
```
**unload.g - v08/06/20**
```g-code
; LEAVE EMPTY
```


### 0:/filaments/PC

**config.g - v08/06/20**

```g-code
; 0:/filaments/PC/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                     ; play some tones
M140 S75                                                    ; set bed temp
M104 S150                                                   ; set extruder warm-up temp
                                                            ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/06/20**
```g-code
; LEAVE EMPTY
```
**unload.g - v08/06/20**
```g-code
; LEAVE EMPTY
```


### 0:/filaments/PETG

**config.g - v08/06/20**

```g-code
; 0:/filaments/PETG/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                     ; play some tones
M140 S75                                                    ; set bed temp
M104 S150                                                   ; set extruder warm-up temp
                                                            ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/06/20**
```g-code
; LEAVE EMPTY
```
**unload.g - v08/06/20**
```g-code
; LEAVE EMPTY
```


### 0:/filaments/PLA

**config.g - v08/06/20**

```g-code
; 0:/filaments/PLA/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300                     ; play some tones
M140 S65                                                    ; set bed temp
M104 S150                                                   ; set extruder warm-up temp
                                                            ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/06/20**
```g-code
; LEAVE EMPTY
```
**unload.g - v08/06/20**
```g-code
; LEAVE EMPTY
```
