# Prusa MK3s - Duet 2 WiFi - RRF 3.11

## MK3s - Duet 2 WiFi wiring guide [PDF](Duet-MK3s.pdf)    

## MK3s - Duet 2 WiFi sd-card file dump [TXT](ALLFiles.md)    

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

## **Print flow events:**   
When initiating a print, the following sequence of events occur in this order.  
**1 - /sys/start.g** is the first codeset that starts at the beginning of each print. This contains the generic processes that apply to all filament types. From this codeset, the fillament's config.g is called.  
**2 - /filaments/PETG/config.g** is the second codeset that get initiated from the "M703" command in the "start.g" file. As written in this example, we are set to use the PETG "config.g" file, located in the "filaments/PETG" directory. This contains the gcode commands that are particular to PETG filament type.  
**3 - Slicer's Start GCode** is the last bit of codeset to be executed before the object's sliced gcode starts. This contains the settings particulr to the actual print and the exact PETG filament loaded. This would be your *'fine'* settings, where PETG/config.g could be considered your *'medium'* settings, and start.g would be the *'rough'* - performing evaluations to get the printer ready.    
**4 - The part's actual gcode** made by the slicer.  
**5 - Slicer's End GCode** follows the printed object's gcode. This codeset lets the duet know that the print is finished which calls  
 **6 - /sys/stop.g**, the very last codeset that is executed. This last part commonly shutdowns heaters, retracts a bit of filament, and positions the machine to easily retrieve the printed part.  

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
M116                                     ; wait for all temperatures

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
M116                                             ; wait for all temperatures

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
M116                                     ; wait for all temperatures

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

