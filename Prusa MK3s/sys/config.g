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
M569 P3 S0                                                 ; Drive 3 goes backward: E Axis
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
M566 X600.00 Y600.00 Z24.00 E300.00 P1                     ; Set maximum instantaneous speed changes (mm/min)
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
M558 P9 C"^zprobe.in" H2.5 F200 T10000                     ; BLTouch, connected to Z probe IN pin
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
