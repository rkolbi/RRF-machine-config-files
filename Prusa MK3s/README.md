# Prusa MK3s config - Duet 2 WiFi - RepRap Firmware 3.11


## **Hardware changes from stock Prusa MK3s:**  
- Bondtech Mosquito Extruder  

- Bear frame  

- 0.9 steppers for X and Y axis  

- Duet WiFi ([Duet-MK3s Wiring Guide Here](Duet-MK3s.pdf))  
  
  <br><br>

## **!? What do those hardware changes mean for your config?**  
1) **Extruder and X/Y microstepping resolution and steps/mm.**  
Unless you have the same exact setup as referenced above, you will have to change the microstepping resolution and the steps/mm located in the 'config.g' file. Your current machine’s configuration can be obtained by issuing a M503 command in the terminal of pronterface or any other terminal connected to the running printer. Pay attention to the microstepping assigned to the axis as that can change your steps per mm. More about this can be read here: https://www.linearmotiontips.com/microstepping-basics/ and here: https://blog.prusaprinters.org/calculator_3416/.  
<br>-This config uses 0.9 stepper motors on X/Y & Bondtech Mosquito Extruder:  
M350 X16 Y16 E16 Z16 I1 ; Microstepping with interpolation  
M92 X200.00 Y200.00 Z400.00 E415.00 ; Steps per mm  
<br>-For the default/stock hardware it should be:  
M350 X16 Y16 Z16 I1 ; Microstepping with interpolation  
M350 E32 I0 ; Microstepping without interpolation  
M92 X100.00 Y100.00 Z400.00 E280.00 ; Steps per mm  
<br>!! Once you have changed/verified the motor settings, review the networking top portion of the file. When completed, copy all the files located in the 'sys' directory over to your sd-card's 'sys' folder. Additionally, copy the files located in the 'macros' folder over to your sd-card's 'macros' folder. More can be read about sd-card here: https://duet3d.dozuki.com/Wiki/SD_Card, more can be read about macros here: https://duet3d.dozuki.com/Wiki/Macros.  

2) **Stallguard sensitivity.**  
As the config.g file is for using 0.9 X/Y steppers, you most likely need to adjust your stallguard sensitivity. Look for the "M915" gcode.  
A good explanation on how to calibrate stallguard can be read here: https://duet3d.dozuki.com/Wiki/Stall_detection_and_sensorless_homing

3) **Mandatory changes to your start gcode (Slicer).**  
 To use the autoload feature you may also find in the stock Prusa MK3s firmware.    
; Prime Filament Sensor for Runout detection  
M581 P1 T2 S-1 R0 ; Filament Sensor P1 triggers Trigger2.g always (R0)  TRIGGER OFF  
M950 J1 C"nil" ; free input 1 e0 Filament Sensor  
M591 D0 P2 C"e0stop" S1 ; Filament Runout Sensor active  

4) **Use the included Macros to unload the filament.**  
"Unload Filament"  
"Unload Mid Print Filament"  
Why? Several reasons, at the moment it is not possible (at least not to my knowledge) to use runout detection and filament autoload features at the same time. What we may need is conditional gcode for that to be simpler.  
Use the "Unload Filament" macro when the printer is not printing and the "Unload Mid Print Filament" macro when you change your filament during a print (e.g. to change the colour).

<br><br>

## **Additional notes:**  
**-The confg is set up to use two independent Z motors.** Meaning, the right Z motor is connected to the E1 stepper driver. Use the "G32" gcode to level both lead screws.  

**-The PINDA thermistor is connected to thermistor E1.** What about the "PINDA temperature calibration feature". You may read my (@Argo) posting in the Duet forums: https://forum.duet3d.com/topic/16972/pinda-2-probe-with-temperature-compensation?_=1593546022132   TL:DR -> right now it's not possible without conditional gcode. Prusa uses a temperature table as the PINDA inaccuracy isn't linear with rising temperatures.  
-I always use "G32" to home my axis or "Home all".

<br><br>

## **Example start gcode for Prusa Slicer:**  
; Prime Filament Sensor for Runout  
M581 P1 T2 S-1 R0 ; Filament Sensor P1 triggers Trigger2.g always (R0)  TRIGGER OFF  
M950 J1 C"nil" ; Input 1 e0 Filament Sensor  
M591 D0 P2 C"e0stop" S1 ; Filament Runout Sensor  
M83 ; extruder relative mode  
M140 S[first_layer_bed_temperature] ; set bed temp  
M109 S165 ; Set extruder temp 165C before bed level  
M190 S[first_layer_bed_temperature] ; wait for bed temp  
G32 ; Levels Z Tilt and probes Z=0  
G29 S0 ; mesh bed leveling  
G1 X0 Y0 Z2 F2000  
M109 S[first_layer_temperature] ; wait for extruder temp  
G1 X10 Y-7 Z0.3 F1000.0 ; go outside print area  
G92 E0.0  
G1 Z0.2 E8 ; Purge Bubble  
G1 X60.0 E9.0  F1000.0 ; intro line  
G1 X100.0 E12.5  F1000.0 ; intro line  
G92 E0.0  

<br><br>

**I tried to be as thorough as possible. I highly recommend to read through the very detailed Duet Wiki pages (https://duet3d.dozuki.com) to understand what those gcodes in the config mean and do!*
