; Configuration file for MK3s Duet WiFi (firmware version 3)
; Use this config.g for stock Prusa MK3s with .09 stepper motors on X & Y with Bondtech BMGm.
; If using stock 1.8 stepper motors, or stock extruder, step/mm will need to be changed - please see the readme file.

; General preferences
G90                                              ; send absolute coordinates...
M83                                              ; ...but relative extruder moves
M550 P"ZMK3-BMGm"                                ; set printer name

; Network
M551 P"3D"                                       ; set password
M552 S1                                          ; enable network
M586 P0 S1                                       ; enable HTTP
M586 P1 S0                                       ; disabled FTP
M586 P2 S0                                       ; disabled Telnet
M575 P1 S1 B38400                                ; enable support for PanelDue

; Drive Mappings S0 = backwards, S1 = forwards
M569 P0 S1                                       ; Drive 0 goes forwards: X Axis
M569 P1 S1                                       ; Drive 1 goes forwards: Y Axis
M569 P2 S1                                       ; Drive 2 goes forwards: Z Axis
M569 P3 S0                                       ; Drive 3 goes backwards: E Axis (Bondtech BMGm)
M569 P4 S1                                       ; Drive 4 goes forwards: Z Axis (at E1)

; Micrpstepping and Speed
M350 X16 Y16 E16 Z16 I1                          ; Configure microstepping with interpolation
M92 X200.00 Y200.00 Z400.00 E415.00              ; Set steps per mm
M566 X480.00 Y480.00 Z24.00 E1500.00 P1          ; Set maximum instantaneous speed changes (mm/min)
M203 X12000.00 Y12000.00 Z750.00 E1500.00        ; Set maximum speeds (mm/min)
M201 X2500.00 Y2500.00 Z1000.00 E5000.00         ; Set accelerations (mm/s^2)
M906 X620.00 Y620.00 Z560.00 E700.00 I10         ; Set motor currents (mA) and motor idle factor in percent - prusa stock motors
M84 S30                                          ; Set idle timeout

; Motor remapping for dual Z and axis Limits
M584 X0 Y1 Z2:4 E3                               ; two Z motors connected to driver outputs Z and E1
M671 X-37:287 Y0:0 S10                           ; leadscrews at left (connected to Z) and right (connected to E1) of X axis
M208 X0:250 Y-4:215 Z-0.1:205                    ; X carriage moves from 0 to 250, Y bed goes from 0 to 210
M564 H0                                          ; allow unhomed movement

; Endstops for each Axis
M574 X1 S3                                       ; Set endstops controlled by motor load detection
M574 Y1 S3                                       ; Set endstops controlled by motor load detection

; Stallgaurd Sensitivy
M915 X S3 F0 H400 R1                             ; Set X axis Sensitivity
M915 Y S3 F0 H400 R1                             ; Set Y axis Sensitivity

; Z-Probe PINDA
M574 Z1 S2                                       ; Set endstops controlled by probe
M558 P5 C"^zprobe.in" I1 H0.7 F800 T6000 A20 S0.005 ; PINDA
M308 S2 P"e1_temp" A"PINDA" Y"thermistor" T100000 B3950
M557 X25:235 Y10:195 P9                          ; Define mesh grid for probing

; Z-Offsets - Once done with babystepping place your final here for ease of use, then uncomment the one your currently using  
;G31 P1000 X23 Y5 Z0.985                         ; PEI Sheet (Prusa) Offset Spool3D Tungsten Carbide
;G31 P1000 X23 Y5 Z0.440                         ; PEI Sheet (Prusa) Offset MICRO SWISS NOZZLE	
;G31 P1000 X23 Y5 Z1.285                         ; Textured Sheet (Prusa) Offset MICRO SWISS NOZZLE
G31 P1000 X23 Y5 Z0.64                           ; Textured Sheet (thekkiinngg) Offset MICRO SWISS NOZZLE

; Heatbed Heaters and Thermistor Bed 
M308 S0 P"bed_temp" Y"thermistor" T100000 B4138 R4700 ; Set thermistor + ADC parameters for heater 0 Bed
M950 H0 C"bedheat" T0                            ; Creates Bed Heater
M307 H0 A146.6 C407.6 D8.4 S1.00 V24.0 B0        ; Bed PID Calibration
M140 H0                                          ; Bed uses Heater 0
M143 H0 S120                                     ; Set temperature limit for heater 0 to 120C Bed

; Filament Sensor Port and Loading Feature ON
;M950 J1 C"e0stop"                               ; Input 1 e0 Filament Sensor 
;M581 P1 T2 S0 R0                                ; Filament Sensor P1 triggers Trigger2.g always (R0)

M950 J1 C"nil"                                   ; Input 1 e0 Filament Sensor  
M591 D0 P2 C"e0stop" S1                          ; Filament Runout Sensor  

; HotEnd Heaters and Thermistor HotEnd           
M308 S1 P"e0_temp" Y"thermistor" T100000 B4725 R4700  ; Set thermistor + ADC parameters for heater 1 HotEnd - use this for stock prusa thermistor
M950 H1 C"e0heat" T1                             ; Create HotEnd Heater
M307 H1 A415.2 C182.2 D3.2 S1.00 V24.0 B0        ; Hotend PID Calibration
M143 H1 S285                                     ; Set temperature limit for heater 1 to 285C HotEnd
M302 S185 R185

; Fans
M950 F1 C"Fan1" Q250                             ; Creates HOTEND Fan
M106 P1 T45 S255 H1                              ; HOTEND Fan Settings
M950 F0 C"Fan0" Q250                             ; Creates PARTS COOLING FAN
M106 P0 H-1                                      ; Set fan 1 value, PWM signal inversion and frequency. Thermostatic control is turned off PARTS COOLING FAN
; The following lines are for auto case fan control, attached to 'fan2' header on duet board
M308 S2 Y"drivers" A"DRIVERS"                    ; Case fan - configure sensor 2 as temperature warning and overheat flags on the TMC2660 on Duet
M308 S3 Y"mcu-temp" A"MCU"                       ; Case fan - configure sensor 3 as thermistor on pin e1temp for left stepper
M950 F2 C"fan2" Q100                             ; Case fan - create fan 2 on pin fan2 and set its frequency                        
M106 P2 H2:3 L0.15 X1 B0.3 T40:70                ; Case fan - set fan 2 value
M912 P0 S-5.5                                    ; MCU Temp calibration - default reads 7.5c higher than ambient

; Tools
M563 P0 D0 H1 F0                                 ; Define tool 0
G10 P0 X0 Y0 Z0                                  ; Set tool 0 axis offsets
G10 P0 R0 S0                                     ; Set initial tool 0 active and standby temperatures to 0C

; Relase X, Y, and E axis
M18 YXE                                          ; unlock X, Y, and E axis