G90

echo "Homing X Y"
M98 P"0:/sys/homexy.g" 
M400

echo "Homing Z"
M98 P"0:/sys/homez.g" 
M400

echo "Starting Loop" 


while iterations <= 5              ; perform 5 passes
    G4 P200                          ; wait .2 seconds 
    M401                             ; deploy probe
    G4 P200                          ; wait .2 seconds
    echo iterations                  ; echo the pass number
    echo "Moves"                     ; echo the start of Moves
    G30 S-1                          ; Execute Z Probe
    M400
    G1 Z10                           ; Move Z to 10mm height
    M400
    G4 P200                          ; wait .2 seconds
    M402                             ; retract probe
    G4 P200                          ; wait .2 seconds
    M400


echo "Macro Complete"
