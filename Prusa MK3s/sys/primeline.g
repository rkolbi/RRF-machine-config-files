; 0:/sys/primeline.g
; Print prime-line at a 'randomized' Y positon from -1.1 to -2.9
; Prime line routine from second line down ref: http://projects.ttlexceeded.com
 
G1 X0 Z0.6 Y{-2+(0.1*(floor(10*(cos(sqrt(sensors.analog[0].lastReading * state.upTime))))))} F3000.0;
G0 Z0.15                                                   ; Primeline nozzle position
G92 E0.0                                                   ; Reset extrusion distance
G1 E8 F1000                                                ; De-retract and push ooze
G1 X20.0 E6 F1000.0                                        ; Fat 20mm intro line @ 0.30
G1 X60.0 E3.2 F1000.0                                      ; Thin +40mm intro line @ 0.08
G1 X100.0 E6 F1000.0                                       ; Fat +40mm intro line @ 0.15
G1 E-0.8 F3000                                             ; Retract to avoid stringing
G1 X99.5 E0 F1000.0                                        ; -0.5mm wipe action to avoid string
G1 X110.0 E0 F1000.0                                       ; +10mm intro line @ 0.00
G1 E0.6 F1500                                              ; De-retract
G92 E0.0                                                   ; Reset extrusion distance
M400                                                       ; Finish all current moves / clear the buffer
