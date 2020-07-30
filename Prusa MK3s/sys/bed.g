; bed.g
; Called to perform automatic bed compensation via G32

M561                                                      ; Clear any bed transform
G28                                                       ; Home

while iterations <=1                                      ; Do minimum of 2 passes
   G30 P0 X25 Y100 Z-99999                                ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y100 Z-99999 S2                            ; Probe near a leadscrew and calibrate 2 motors
   G90

while move.calibration.initial.deviation >= 0.002         ; perform additional tramming if previous deviation was over 0.002mm 
   if iterations = 5                                      ; Perform 5 checks
      M300 S3000 P500                                     ; Sound alert, required deviation could not be achieved
      abort "!!! ABORTED !!! Failed to achieve < 0.002 deviation within 5 movements. Current deviation is " ^ move.calibration.initial.deviation ^ "mm."
   G30 P0 X25 Y100 Z-99999                                ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y100 Z-99999 S2                            ; Probe near a leadscrew and calibrate 2 motors
   G90                                                    ; Back to absolute mode

echo "Gantry deviation of " ^ move.calibration.initial.deviation ^ "mm obtained."
G1 H2 Z8 F2600                                            ; Raise head 8mm to ensure it is above the Z probe trigger height
G1 X104 Y100 F6000                                        ; Put head over the centre of the bed, or wherever you want to probe
G30 