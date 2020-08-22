; 0:/sys/current-sense-normal.g
; Set the current and sensitivity for normal routines

M913 X100 Y100 Z100                                        ; Set the X, Y, and Z drivers to 100% of their normal current per config.g.
M915 X S3 F0 H200 R0                                       ; Set the X axis sensitivity.
M915 Y S3 F0 H200 R0                                       ; Set the Y axis sensitivity.