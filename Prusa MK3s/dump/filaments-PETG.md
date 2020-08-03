**config.g - v08/03/20**
```g-code
; 0:/filaments/PETG/config.g
; Macro use to set 'basic' setting for filament type

M300 S1000 P200 G4 P500 M300 S3000 P300          ; play some tones
M140 S75                                         ; set bed temp
M104 S150                                        ; set extruder warm-up temp
                                                 ; active temp set from slicer gcode
 
; Insert additional filament specific settings here

```
**load.g - v08/03/20**
```g-code

```
**unload.g - v08/03/20**
```g-code

```
