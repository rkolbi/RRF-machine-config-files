; 0:/sys/primeline.g
; Print prime-line at a 'randomized' Y position from -1.1 to -2.9
 
; Charge! tune
M400
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
G92 E0.0                                                   ; Reset extrusion distance
G1 E8                                                      ; Purge Bubble
G1 X60.0 E11.0 F1000.0                                     ; intro line
G1 X120.0 E16.0 F1000.0                                    ; intro line
G92 E0.0                                                   ; Reset extrusion distance
M400                                                       ; Finish all current moves / clear the buffer
