; ==============================================
; Universal End G-code
; Works with Ender 3 series and K1 series
; Author: Josh Merritt
; Last Updated: January 2026
; ==============================================
;
; For K1 with Klipper, you can use the simple macro call:
;   END_PRINT
;
; For Marlin printers (Ender 3), use this full sequence
;
; ==============================================

; --- Retract and Lift ---
G91                          ; Relative positioning
G1 E-2 F2700                ; Retract filament to prevent stringing
G1 E-2 F2700                ; Extra retract
G1 Z10 F3000                ; Raise Z 10mm

; --- Present Print ---
G90                          ; Absolute positioning
G1 X0 Y220 F6000            ; Move bed forward to present print
; For K1 Max (300mm bed), use:
; G1 X0 Y295 F6000

; --- Cooldown ---
M104 S0                      ; Turn off hotend
M140 S0                      ; Turn off heated bed
M106 S0                      ; Turn off part cooling fan

; --- Disable Steppers ---
; Wait a moment for Z to settle
G4 P1000                     ; Dwell 1 second
M84                          ; Disable all stepper motors

; --- Display Message ---
M117 Print Complete!

; ==============================================
; Optional: Beep notification
; Uncomment if your printer has a buzzer
; ==============================================
; M300 S1000 P200             ; Beep at 1kHz for 200ms
; G4 P200                     ; Wait 200ms
; M300 S1500 P200             ; Beep at 1.5kHz for 200ms

; ==============================================
; K1 Klipper Macro Alternative
; ==============================================
; If using K1 with Klipper, replace this entire file with:
;
; END_PRINT
;
; Make sure END_PRINT macro is defined in your printer.cfg
; See klipper/macros.cfg for the macro definition

; ==============================================
; End of End G-code
; ==============================================
