; 0:/sys/primeline.g
; Print prime-line at a 'randomized' Y positon from -1.1 to -2.9

G1 X0 Z0.6 Y{-2+(0.1*(floor(10*(cos(sqrt(sensors.analog[0].lastReading * state.upTime))))))} F3000.0;
G92 E0.0                                                   ; set E position to 0
G1 Z0.2 X100.0 E30.0 F1000.0                               ; prime line
G92 E0.0                                                   ; set E position to 0
M400                                                       ; finish all current moves / clear the buffer