; ==============================================
; Creality K1 / K1 Max Start G-code (Klipper)
; Author: Josh Merritt
; Last Updated: January 2026
; ==============================================
;
; This start G-code calls the START_PRINT macro in Klipper
; Make sure the START_PRINT macro is defined in your printer.cfg
; See klipper/macros.cfg for the macro definition
;
; Usage:
; Copy this into your slicer's start G-code section
; Replace temperature variables with your slicer's syntax:
;   Cura: {material_bed_temperature_layer_0}, {material_print_temperature_layer_0}
;   PrusaSlicer: [first_layer_bed_temperature], [first_layer_temperature]
;   OrcaSlicer: [bed_temperature_initial_layer], [nozzle_temperature_initial_layer]
;
; ==============================================

; --- Simple Version (uses macro) ---
START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}

; ==============================================
; Alternative: Full Start G-code (without macro)
; Uncomment below if you don't have START_PRINT macro
; ==============================================
;
; ; --- Initialization ---
; G90                                  ; Absolute positioning
; M82                                  ; Absolute extrusion
;
; ; --- Heating ---
; M140 S{material_bed_temperature_layer_0}    ; Start heating bed
; M104 S150                            ; Preheat nozzle (prevent ooze)
;
; ; --- Homing ---
; G28                                  ; Home all axes
;
; ; --- Wait for Bed ---
; M190 S{material_bed_temperature_layer_0}    ; Wait for bed temp
;
; ; --- Bed Mesh ---
; BED_MESH_CALIBRATE ADAPTIVE=1        ; Adaptive mesh calibration
; ; Or use saved mesh:
; ; BED_MESH_PROFILE LOAD=default
;
; ; --- Heat Nozzle ---
; M109 S{material_print_temperature_layer_0}  ; Wait for nozzle temp
;
; ; --- Prime Line ---
; G92 E0                               ; Reset extruder
; G1 Z2.0 F3000                       ; Move Z up
; G1 X0.1 Y20 Z0.3 F5000.0            ; Move to start
; G1 X0.1 Y200.0 Z0.3 F1500.0 E15     ; Draw first line
; G1 X0.4 Y200.0 Z0.3 F5000.0         ; Move to side
; G1 X0.4 Y20 Z0.3 F1500.0 E30        ; Draw second line
; G92 E0                               ; Reset extruder
; G1 Z5.0 F3000                       ; Lift Z
;
; ; --- Ready ---
; M117 Printing...

; ==============================================
; End of Start G-code
; ==============================================
