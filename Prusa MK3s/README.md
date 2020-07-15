# Prusa MK3s - Duet 2 WiFi - RRF 3.11

## Prusa MK3s - Duet 2 WiFi wiring guide [PDF](Duet-MK3s.pdf)    

<br>

## **Hardware changes from stock Prusa MK3s:**

- Bondtech Mosquito Extruder  

- 0.9 steppers for X and Y axis (17HM15-0904S @ omc-stepperonline.com) 	

- Duet WiFi  
  
- PanelDue 5i  
  
  <br><br>

## **:interrobang:What do those hardware changes mean for your config?**  
1) **:wrench:Extruder and X/Y microstepping resolution and steps/mm.**  
Unless you have the same exact setup as referenced above, you will have to change the microstepping resolution and the steps/mm located in the 'config.g' file. Your current machine’s configuration can be obtained by issuing a M503 command in the terminal of pronterface or any other terminal connected to the running printer. Pay attention to the microstepping assigned to the axis as that can change your steps per mm. _More about this can be read here: https://www.linearmotiontips.com/microstepping-basics/ and here: https://blog.prusaprinters.org/calculator3416/._  
<br>-The provided config.g is set for 0.9 stepper motors on X/Y and a Bondtech Mosquito Extruder:  
M350 X16 Y16 E16 Z16 I1 ; Microstepping with interpolation  
M92 X200.00 Y200.00 Z400.00 E415.00 ; Steps per mm  
<br>-An example stepper motor configuration for the stock hardware:  
M350 X16 Y16 Z16 I1 ; Microstepping with interpolation  
M350 E32 I0 ; Microstepping without interpolation  
M92 X100.00 Y100.00 Z400.00 E280.00 ; Steps per mm  
<br>:warning:Once you have changed/verified the motor settings, review the networking top portion of the file. When completed, copy all the files located in the 'sys' directory over to your sd-card's 'sys' folder. Additionally, copy the files located in the 'macros' folder over to your sd-card's 'macros' folder. _More can be read about sd-card here: https://duet3d.dozuki.com/Wiki/SDCard, more can be read about macros here: https://duet3d.dozuki.com/Wiki/Macros._  

2) **:wrench:Sensorless Homing / Stallguard sensitivity.**  
As the configuration files are for using 0.9 X/Y steppers, you most likely need to adjust your stallguard and sensorless homing. For stallguard sensitivity, look for the "M915" gcode in the config.g file. A good explanation on how to calibrate stallguard can be read here: https://duet3d.dozuki.com/Wiki/Stall_detection_and_sensorless_homing.

 3) **:bulb:Use the included Macros to unload the filament.**  
**"Set Filament Type"** - This macro asks what filament you going to use; PLA, PETg, ABS, or PC. This information will be used to change the "Heat Nozzle" macro, which can be ran individually to heat the hotend for the specified filament. and is also used, or required,  by the macro "Filament Handling"  
**"Filament Handling"** - For any and all filamnet unloading / loading / changing use this macro. This macro will load, unload, and change filament base on weather is detects filament is current loaded or not, and if a print is in progress or not. Please note that since the logic functions look at the current status of the filament sensor, if your printer is currently empty and you intend on loading filament, please do not place filament in the extruder until requested to do so by the macro. Else the macro will think filament is loaded and that you want to unload instead of load.  
**"Heat Nozzle"** is created and changed by the opertion of "Set Filament Type" macro and can be selected on its own and is also used / required by the "Filament Handling" macro. If you select it, the hotend will heat to the set filament type temperature.  

![](Start-screen.jpg)

<br><br>

## **Additional notes:**  
**:bulb:The confg is set up to use two independent Z motors.** Meaning, the right Z motor is connected to the E1 stepper driver. Use the "G32" gcode to level both lead screws.  

**:bulb:The PINDA thermistor is connected to thermistor E1.** What about the "PINDA temperature calibration feature".  Read @Argo posting in the Duet forums: https://forum.duet3d.com/topic/16972/pinda-2-probe-with-temperature-compensation?_=1593546022132.  TL:DR -> right now it's not possible without conditional gcode. Prusa uses a temperature table as the PINDA inaccuracy isn't linear with rising temperatures.  

<br><br>

## **Example start gcode for Prusa Slicer:**  
```g-code
;Start G-Code

G90                                 ; Use absolute positioning
G28                                 ; home
G1 X100 Y100 F3000                  ; place probe about center to stabilized pinda

M140 S[first_layer_bed_temperature] ; set bed temp to first layer temp
M104 S150                           ; set nozzle temp to 150c
M190 S[first_layer_bed_temperature] ; wait for bed temp
M109 S150                           ; wait for extruder temp

G32                                 ; Level R/L Z-axis
G29                                 ; Level Bed

G1 X0 Z0.6 Y-3.0 F3000.0            ; place probe at home position
M104 S[first_layer_temperature]     ; set extruder final temp
M109 S[first_layer_temperature]     ; wait for extruder final temp

G92 E0.0
G1 Z0.2 X200.0 E30.0 F1000.0        ; purge line
G92 E0.0

; pressure advance can be either here or in filament gcode
; M572 D0 S0.11                       ; set pressure advance
```
## **Example end gcode for Prusa Slicer:**  

```g-code
;End G-Code
  
M104 S0                             ; turn off hotend
M140 S0                             ; turn off heatbed
M107                                ; turn off fan

M221 S100                           ; reset extrusuon to 100 percent
G1 F1000.0                          ; set feed rate
G1 E-2                              ; retract
G1 X20 Y200 Z205 F3000              ; home X axis
M84 XYE                             ; unlock motors
```

<br>

<br>

## **Example start gcode for ideaMaker Slicer:**  

```g-code
; ideaMaker Start G-Code

G90                                 ; Absolute Positioning
M83                                 ; extruder relative mode
G28                                 ; home
G1 X100 Y100 F3000                  ; home X axis

M140 S{temperature_heatbed}         ; set bed temp
M104 S150                           ; set extruder temp
M190 S{temperature_heatbed}         ; wait for bed temp

G32                                 ; Level R/L Z-axis
G29                                 ; Level Bed

G1 X0 Z0.6 Y-3.0 F3000.0
M104 S{temperature_extruder1}       ; set extruder
M109 S{temperature_extruder1}       ; wait for extruder temp

G92 E0.0
G1 Z0.2 X100.0 E30.0 F1000.0        ; intro line
G92 E0.0
                                
M572 D0 S0.11                       ; set pressure advance
```

## **Example end gcode for ideaMaker Slicer:**  

```g-code
; ideaMaker End G-Code
  
M104 S0                             ; turn off temperature
M140 S0                             ; turn off heatbed
M107                                ; turn off fan

M221 S100                           ; reset extrusuon to 100 percent
G1 F1000.0                          ; set feed rate
G1 E-2                              ; retract
G1 X20 Y200 Z205 F3000              ; home X axis
M84 XYE                             ; unlock motors
```

<br>

**It is highly recommend to read through the very detailed Duet Wiki pages at https://duet3d.dozuki.com. RepRapFirmware supported G-code reference can be found here https://duet3d.dozuki.com/Wiki/Gcode#main.*

