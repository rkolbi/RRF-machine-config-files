; bed.g
; Called to perform automatic bed compensation via G32

M561                                                      ; Clear any bed transform
G28                                                       ; Home

G30 P0 X25 Y100 Z-99999                                   ; Probe near a leadscrew, half way along Y axis
G30 P1 X235 Y100 Z-99999 S2                               ; Probe near a leadscrew and calibrate 2 motors

while move.calibration.initial.deviation >= 0.01	; perform additional tramming if previous deviation was over 0.01mm
 
   if iterations = 5                                      ; Perform 5 checks
      abort "!!!Failed to achieve < 0.01 deviation within 5 movements. Current deviation is " ^ move.calibration.initial.deviation ^ "mm."

   G30 P0 X25 Y100 Z-99999                                ; Probe near a leadscrew, half way along Y axis
   G30 P1 X235 Y100 Z-99999 S2                            ; Probe near a leadscrew and calibrate 2 motors
   G90                                                    ; Back to absolute mode

echo "Gantry deviation of " ^ move.calibration.initial.deviation ^ "mm obtained within " ^ iterations + 2 ^ " tramming cycles."

G1 H2 Z8 F2600                                            ; Raise head 8mm to ensure it is above the Z probe trigger height
G1 X104 Y100 F6000                                        ; Put head over the centre of the bed, or wherever you want to probe
G30                                                       ; Lower head, stop when probe triggered and set Z to trigger height
