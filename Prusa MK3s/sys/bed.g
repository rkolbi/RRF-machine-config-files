; bed.g
; called to perform automatic bed compensation via G32

M561                                             ; clear any bed transform
G28 W                                            ; home

G30 P0 X25 Y100 Z-99999                          ; probe near a leadscrew, half way along Y axis
G30 P1 X235 Y100 Z-99999 S2                      ; probe near a leadscrew and calibrate 2 motors
G90                                              ; back to absolute mode

G30 P0 X25 Y100 Z-99999                          ; probe near a leadscrew, half way along Y axis
G30 P1 X235 Y100 Z-99999 S2                      ; probe near a leadscrew and calibrate 2 motors
G90                                              ; back to absolute mode

G30 P0 X25 Y100 Z-99999                          ; probe near a leadscrew, half way along Y axis
G30 P1 X235 Y100 Z-99999 S2                      ; probe near a leadscrew and calibrate 2 motors
G1 H2 Z8 F2600                                   ; raise head 4mm to ensure it is above the Z probe trigger height
G90                                              ; back to absolute mode

G1 X104 Y100 F6000                               ; put head over the centre of the bed, or wherever you want to probe
G30                                              ; lower head, stop when probe triggered and set Z to trigger height