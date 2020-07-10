# Prusa MK3s - Duet 2 WiFi - RRF 3.11

## Prusa MK3s - Duet 2 WiFi wiring guide [PDF](Duet-MK3s.pdf)    

<br>

## **Hardware changes from stock Prusa MK3s:**

- Bondtech Mosquito Extruder  

- 0.9 steppers for X and Y axis (17HM15-0904S @ omc-stepperonline.com) 	

- Duet WiFi  
  
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

3) **:bulb:Mandatory changes to your start gcode (Slicer).**  
 To use the autoload feature you may also find in the stock Prusa MK3s firmware.    
; Prime Filament Sensor for Runout detection  
M581 P1 T2 S-1 R0 ; Filament Sensor P1 triggers Trigger2.g always (R0)  TRIGGER OFF  
M950 J1 C"nil" ; free input 1 e0 Filament Sensor  
M591 D0 P2 C"e0stop" S1 ; Filament Runout Sensor active  

4) **:bulb:Use the included Macros to unload the filament.**  
"Unload Filament"  
"Unload Mid Print Filament"  
Why? Several reasons, at the moment it is not possible (at least not to my knowledge) to use runout detection and filament autoload features at the same time. What we may need is conditional gcode for that to be simpler.  
Use the "Unload Filament" macro when the printer is not printing and the "Unload Mid Print Filament" macro when you change your filament during a print (e.g. to change the colour).

<br><br>

## **Additional notes:**  
**:bulb:The confg is set up to use two independent Z motors.** Meaning, the right Z motor is connected to the E1 stepper driver. Use the "G32" gcode to level both lead screws.  

**:bulb:The PINDA thermistor is connected to thermistor E1.** What about the "PINDA temperature calibration feature".  Read @Argo posting in the Duet forums: https://forum.duet3d.com/topic/16972/pinda-2-probe-with-temperature-compensation?_=1593546022132.  TL:DR -> right now it's not possible without conditional gcode. Prusa uses a temperature table as the PINDA inaccuracy isn't linear with rising temperatures.  

<br><br>

## **Example start gcode for Prusa Slicer:**  
```g-code
;Start G-Code

M581 P1 T2 S-1 R0 ; Filament Sensor P1 triggers Trigger2.g always (R0)  TRIGGER OFF  
M950 J1 C"nil" ; Input 1 e0 Filament Sensor  
M591 D0 P2 C"e0stop" S1 ; Filament Runout Sensor  
G90; Use absolute positioning

G28; home
G1 X100 Y100 F3000; place probe about center to heat stabilized pinda

; Heat Bed to [first_layer_bed_temperature] / Nozzle to 150
M140 S[first_layer_bed_temperature] ; set bed temp
M104 S150 ; set nozzle temp
M190 S[first_layer_bed_temperature] ; wait for bed temp
M109 S150 ; wait for extruder temp

G32 ; Level R/L Z-axis
G29 ; Level Bed

G1 X0 Z0.6 Y-3.0 F3000.0 ;
M104 S[first_layer_temperature] ; set extruder final temp
M109 S[first_layer_temperature] ; wait for extruder final temp

G92 E0.0
G1 Z0.2 X200.0 E30.0 F1000.0 ; intro line
G92 E0.0
```
<br>

## **Example end gcode for Prusa Slicer:**  

```g-code
;End G-Code

M221 S100
M104 S0 ; turn off temperature
M140 S0 ; turn off heatbed
M107 ; turn off fan
G1 F1000.0 ; set feed rate
G1 E-2 ; retract
G1 X20 Y200 Z205 F3000; home X axis

M84 XYE; disable motors
```

<br>

**It is highly recommend to read through the very detailed Duet Wiki pages at https://duet3d.dozuki.com. RepRapFirmware supported G-code reference can be found here https://duet3d.dozuki.com/Wiki/Gcode#main.*

