; 0:/sys/bed.g
; Called to perform automatic bed compensation via G32

M561                                                       ; Clear any bed transform
G28                                                        ; Home

M558 F50 A5 S0.003                                         ; slow z-probe, up to 5 probes until disparity is 0.003 or less - else yield average
while iterations <=2                                       ; Perform 3 passes
   G30 P0 X25 Y105 Z-99999                                 ; Probe near a leadscrew, halfway along Y-axis
   G30 P1 X225 Y105 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors
   G1 X105 F10000                                          ; Move to center
   G30                                                     ; Probe the bed at the current XY position
   M400                                                    ; Finish moves, clear buffer

M558 F50 A5 S-1                                            ; slow z-probe, take 5 probes and yield average
while move.calibration.initial.deviation >= 0.003          ; perform additional tramming if previous deviation was over 0.003mm 
   if iterations = 5                                       ; Perform 5 addition checks, if needed
      M300 S3000 P500                                      ; Sound alert, required deviation could not be achieved
      M558 F200 A1                                         ; normal z-probe, return to normal speed
      abort "!!! ABORTED !!! Failed to achieve < 0.002 deviation. Current deviation is " ^ move.calibration.initial.deviation ^ "mm."
   G30 P0 X25 Y105 Z-99999                                 ; Probe near a leadscrew, halfway along Y-axis
   G30 P1 X225 Y105 Z-99999 S2                             ; Probe near a leadscrew and calibrate 2 motors
   G1 X105 F10000                                          ; Move to center
   G30                                                     ; Probe the bed at the current XY position
   M400                                                    ; Finish moves, clear buffer

M558 F200 A1                                               ; normal z-probe, return to normal speed
echo "Gantry deviation of " ^ move.calibration.initial.deviation ^ "mm obtained."
G1 Z8                                                      ; Raise head 8mm to ensure it is above the Z probe trigger height