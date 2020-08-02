# Prusa MK3s - Duet 2 WiFi - RRF 3.11

## Prusa MK3s - Duet 2 WiFi wiring guide [PDF](Duet-MK3s.pdf)    

<br>

## **Hardware changes from stock Prusa MK3s:**

*Note: The config.g file contains notes to facilitate easy adaptation to stock Prusa MK3s.*

- Bondtech Mosquito Extruder  

- 0.9 Stepper motors on X & Y axis (17HM15-0904S @ omc-stepperonline.com) 	

- Duet WiFi  
  
- PanelDue 5i  
  
- PT1000 hotend thermistor  
  
- BLTouch v3.1  
  
  <br><br>

## **:interrobang:What do those hardware changes mean for your config?**  
1) **:wrench:Motors, microstepping resolution, and steps/mm.**  
Unless you have the same setup as referenced above, you may have to change the microstepping resolution and the steps per millimeter located in the 'config.g' file. To retrieve your current machine's configuration, issue a M503 command in the terminal connected to the running printer. Pay attention to the microstepping assigned to the axis as that can change your steps per millimeter. Read through the /sys/config.g file comments and make the applicable changes as needed.  *More about this can be read here: https://duet3d.dozuki.com/Wiki/Choosing_and_connecting_stepper_motors, here: https://www.linearmotiontips.com/microstepping-basics/, and here: https://blog.prusaprinters.org/calculator3416/.*  
:warning:Once you have changed/verified the motor settings, review the networking top portion of the file. When completed, copy all the files located in the 'sys', 'macros', and 'filaments' directory over to your sd-card. The 'www' and 'gcode' folder are present in the repository for reference and should not be needed to copy over to the sd-card in normal circumstances. *More can be read about sd-card here: https://duet3d.dozuki.com/Wiki/SDCard, more can be read about macros here: https://duet3d.dozuki.com/Wiki/Macros.*  

2) **:wrench:Sensorless Homing / Stallguard sensitivity.**  
The TMC2660 drivers used on the Duet WiFi support the stallGuard feature. This feature allows the driver to detect motor stalls under some circumstances. Stall detection may be useful for detecting when a motor has skipped steps due to the nozzle hitting an obstruction, and for homing the printer without using endstop switches.  
As the given configuration files were authored while using 0.9 degree stepper motors on the X and Y axis, you may need to adjust your stallguard sensitivity and sensorless homing. For stallguard sensitivity, look for the "M915" in the current-sense-homing.g and current-sense-normal.g files. *Read the full documentation here: https://duet3d.dozuki.com/Wiki/Stall_detection_and_sensorless_homing.*

 3) **:bulb:Use the included Macros for filament handling.**  
To make filament loading, unloading, and changing the most straightforward and simplistic possible evolution, I have made a macro set that is readily accessible from the PanelDue.  To take full advantage of the duet filament system you will need to make the system filaments PLA, PETG, ABS, and PC. This will allow you to have custom instructions for each different filament, by adding such to the filament's config.g file. *!Note: Based on my current macro version, it is required that each filament's load.g and unload.g remain empty. Placing code into these files will make these macro fail.*  
**"Set Filament Type"** asks what type filament you are going to use; PLA, PETg, ABS, or PC. Based on the selection, this macro rewrites the "Heat Nozzle" macro to heat the nozzle for the selected filament type.  *!Note: This macro only has to be executed once for the given filament type change as it's settings are nonvolatile, regardless of reset or power off. !Note: The script will not let you change the filament type while filament is loaded.*   
**"Filament Handling"** is for any filament unloading, loading, and changing regardless of the printer's state, printing or not. This macro will load, unload, and change filament based on two conditions; whether it detects filament is currently loaded or not, and if a print is in progress or not.  *!Note: The logic function in the macro retrieves the current status of the filament sensor to base the perceived desired action to enact. If your printer's filament is currently empty and you intend to load filament, please do not place it into the extruder until requested to do so by the macro. Else the macro will determine that filament is loaded and that you desire to unload filament, instead of load.*   
**"Heat Nozzle"** is created by the "Set Filament Type" macro and can be selected to heat the hotend to the set temperature for the last chosen filament type. You do not need to run this to change filament, the "Filament Handling" macro automatically runs this macro to perform the heating of the hotend to carry out the filament handling, whether it be loading, unloading, or changing.

![Start Screen](Start-screen.jpg)

<br>4) **:bulb:Sliced object flow events.**   
When initiating a print, the following sequence of events occur in this order.  
**1 - "/sys/start.g"** is the first codeset that starts at the beginning of each print. This contains the generic processes that apply to all filament types. From this codeset, the fillament's config.g is called.  
**2 - "/filaments/PETG/config.g"** is the second codeset that get initiated from the "M703" command in the "start.g" file. As written in this example, we are set to use the PETG "config.g" file, located in the "filaments" directory. This codeset contains the gcode commands that are particular to PETG (this is set by use of the macro discussed above or from within DWC).  
**3 - "Slicer's Start GCode"** is the last bit of codeset to be executed before the object's sliced gcode starts.    
**4 - The part's actual gcode** made by the slicer.  
**5 - "Slicer's End GCode"** follows the printed object's gcode. This codeset lets the duet know that the print is finished which calls  
 **6 - "/sys/stop.g"**, the very last codeset that is executed. This last part commonly shutdowns heaters, retracts a bit of filament, and positions the machine to easily retrieve the printed part.  
<br>Combining all of those together would yield the following:  


```g-code
; start.g file
;M280 P0 S160                                     ; BLTouch, alarm release
;G4 P100                                          ; BLTouch, delay for release command
G28                                              ; Home all
G1 Z100                                          ; Last chance to check nozzle cleanliness
M220 S100                                        ; Set speed factor back to 100% in case it was changed
M221 S100                                        ; Set extrusion factor back to 100% in case it was changed
M290 R0 S0                                       ; Clear babystepping
M106 S0                                          ; Turn part cooling blower off if it is on
M703                                             ; Execute loaded filement's config.g

; /filaments/PETG/config.g file
M300 S1000 P200 G4 P500 M300 S3000 P300          ; play some tones
M572 D0 S0.0                                     ; clear pressure advance 
M140 S75                                         ; set bed temp
M104 S150                                        ; set extruder temp
M190 S75                                         ; wait for bed temp
M109 S150                                        ; wait for extruder temp
G32                                              ; Level bed
G29                                              ; Bed mesh
G90                                              ; Absolute Positioning
M83                                              ; Extruder relative mode
; Insert additional filament specific settings here

; start.g file (continued)
G1 X0 Y0 Z2                                      ; Final position before slicer's temp is reached and primeline is printed.
; The primeline macro is executed by the slicer gcode to enable direct printing
; of the primeline at the objects temp and to immediately print the object
; following primeline completion. 
; Slicer generated gcode takes it away from here

; ideaMaker Start G-Code
; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S{temperature_heatbed}                      ; set bed temp
M104 S{temperature_extruder1}                    ; set extruder temp
M190 S{temperature_heatbed}                      ; wait for bed temp
M109 S{temperature_extruder1}                    ; wait for extruder temp
; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                        ; primeline macro

; /sys/primeline.g
; Print prime-line at a 'randomized' Y positon from -1.1 to -2.9
G1 X0 Z0.6 Y{-2+(0.1*(floor(10*(cos(sqrt(sensors.analog[0].lastReading * state.upTime))))))} F3000.0;
G92 E0.0
G1 Z0.2 X100.0 E30.0 F1000.0 ; prime line
G92 E0.0
M400

; ideaMaker Start G-Code (continues)
; Set pressure advance
M572 D0 S0.07                                    ; set pressure advance
```
OBJECTS GCODE HERE
```g-code
; ideaMaker End G-Code
M400                                             ; Make sure all moves are complete
M0                                               ; Stop everything and run sys/stop.g

; /sys/stop.g
; called when M0 (Stop) command is run (e.g. when a print from SD card is cancelled)
M83                                              ; set extruder to relative mode
M104 S0                                          ; turn off temperature
M140 S0                                          ; turn off heatbed
M107                                             ; turn off fan
G1 F1000.0                                       ; set feed rate
G1 E-2                                           ; retract
G1 X110 Y200 Z205 F3000                          ; place nozzle center/top
M400                                             ; Clear queue
M18 YXE                                          ; unlock X, Y, and E axis
```

<br><br>

## **Additional notes:**  
**:bulb:Electrically independent Z motors**: On printers, such as MK3, which uses two Z motors to raise/lower the bed or gantry, you can have the firmware probe the bed and adjust the motors individually to eliminate tilt.  The auto calibration uses a least squares algorithm that minimises the sum of the height errors. The deviation before and expected deviation after calibration is reported. Run G32 to initiate the process. *Read the full documentation here: https://duet3d.dozuki.com/Wiki/Bed_levelling_using_multiple_independent_Z_motors.*  

**:bulb:PINDA v2**: Pinda version 2 is upgraded from the previous version in that it now has an integrated thermistor, which this configuration electrically ties to thermistor E1 on the duet.  Pinda temperature compensation has to be mitigated via g-code macro but will be handled via integrated function within the duet firmware shortly.  *Read @Argo's posting in the Duet forums: https://forum.duet3d.com/topic/16972/pinda-2-probe-with-temperature-compensation?_=1593546022132.*    

**:bulb:BLTouch v3.1**: The config.g has comment sections for using this probe and the wiring guide covers the electrical installation of the BLTouch v3.1 in the last few pages. *Read the full documentation here: https://duet3d.dozuki.com/Wiki/Connecting_a_Z_probe*      

<br><br>

## **Example start gcode for ideaMaker Slicer:**  

```g-code
; ideaMaker Start G-Code

; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S{temperature_heatbed}              ; set bed temp
M104 S{temperature_extruder1}            ; set extruder temp
M190 S{temperature_heatbed}              ; wait for bed temp
M109 S{temperature_extruder1}            ; wait for extruder temp

; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                ; primeline macro

; Set pressure advance
M572 D0 S0.07                            ; set pressure advance
```

## **Example end gcode for ideaMaker Slicer:**  

```g-code
; ideaMaker End G-Code
M400                                     ; Make sure all moves are complete
M0                                       ; Stop everything and run sys/stop.g
```

<br>

<br>

## **Example start gcode for Simplify3D Slicer:**  

```g-code
; Simplify3D Start G-Code

; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S[bed0_temperature]                         ; set bed temp
M104 S[extruder0_temperature]                    ; set extruder temp
M190 S[bed0_temperature]                         ; wait for bed temp
M109 S[extruder0_temperature]                    ; wait for extruder temp

; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                        ; primeline macro

; Set pressure advance
M572 D0 S0.07                                    ; set pressure advance
```

## **Example end gcode for Simplify3D Slicer:**  

```g-code
; Simplify3D End G-Code
M400                                             ; Make sure all moves are complete
M0  
```

<br>

<br>

## **Example start gcode for Prusa Slicer:**  

```g-code
; PrusaSlicer Start G-Code:

; Set nozzle and bed to the specific temperatures declared within this slicer
M140 S[first_layer_bed_temperature]      ; set bed temp
M104 S[first_layer_temperature]          ; set extruder temp
M190 S[first_layer_bed_temperature]      ; wait for bed temp
M109 S[first_layer_temperature]          ; wait for extruder temp

; Run macro to print primeline at a 'randomized' Y positon from -1.1 to -2.9
M98 P"0:/sys/primeLine.g"                ; primeline macro

; Set pressure advance
M572 D0 S0.07                            ; set pressure advance
```
## **Example end gcode for Prusa Slicer:**  

```g-code
; PrusaSlicer End G-Code
M400                                     ; Make sure all moves are complete
M0                                       ; Stop everything and run sys/stop.g
```

<br>



**It is highly recommend to read through the very detailed Duet Wiki pages at https://duet3d.dozuki.com. RepRapFirmware supported G-code reference can be found here https://duet3d.dozuki.com/Wiki/Gcode#main.*

