; ==============================================
; Ender 3 V2/V3/S1 Start G-code
; Author: Josh Merritt
; Last Updated: January 2026
; ==============================================
;
; Usage:
; Copy this into your slicer's start G-code section
; Replace temperature variables with your slicer's syntax:
;   Cura: {material_bed_temperature_layer_0}, {material_print_temperature_layer_0}
;   PrusaSlicer: [first_layer_bed_temperature], [first_layer_temperature]
;   OrcaSlicer: [bed_temperature_initial_layer], [nozzle_temperature_initial_layer]
;
; ==============================================

; --- Initialization ---
G90                          ; Absolute positioning
M82                          ; Absolute extrusion mode
G28                          ; Home all axes

; --- Load Bed Mesh (if saved) ---
M420 S1                      ; Enable bed leveling mesh from EEPROM
; Uncomment below for auto bed leveling before each print:
; G29                        ; Auto bed level

; --- Heating Sequence ---
; Heat bed first to allow thermal expansion before probing
M190 S{material_bed_temperature_layer_0}    ; Wait for bed temp

; Preheat nozzle to prevent oozing during bed level
M104 S150                    ; Set nozzle to 150°C (no wait)

; Optional: Auto bed level after bed is heated
; G29                        ; Uncomment if you want ABL every print

; Heat nozzle to print temperature
M109 S{material_print_temperature_layer_0}  ; Wait for nozzle temp

; --- Prime Line ---
; Draws a priming line along the left edge of the bed
G92 E0                       ; Reset extruder position
G1 Z2.0 F3000               ; Move Z up to safe height
G1 X0.1 Y20 Z0.3 F5000.0    ; Move to start position
G1 X0.1 Y200.0 Z0.3 F1500.0 E15   ; Draw first prime line
G1 X0.4 Y200.0 Z0.3 F5000.0       ; Move to second line start
G1 X0.4 Y20 Z0.3 F1500.0 E30      ; Draw second prime line
G92 E0                       ; Reset extruder position
G1 Z2.0 F3000               ; Lift Z
G1 X5 Y20 Z0.3 F5000.0      ; Move away from prime line

; --- Ready to Print ---
M117 Printing...             ; Display message on LCD

; ==============================================
; End of Start G-code
; ==============================================
