# Creality 3D Printer Configurations

**Author:** Josh Merritt, CTO @ QUX Technologies
**Last Updated:** January 2026

Optimized slicer profiles, G-code macros, and calibration guides for Creality 3D printers.

---

## Supported Printers

| Printer | Build Volume | Features |
|---------|--------------|----------|
| Ender 3 V2/V3 | 220x220x250mm | Direct drive, silent board |
| Ender 3 S1/S1 Pro | 220x220x270mm | Direct drive, auto-leveling |
| Ender 5 S1 | 220x220x280mm | Cube frame, stable Z |
| CR-10 Smart Pro | 300x300x400mm | Large format, WiFi |
| K1 / K1 Max | 220x220x250mm / 300x300x300mm | High-speed CoreXY |
| Ender 3 V3 KE | 220x220x240mm | Klipper, high-speed |

---

## Quick Start

1. Download the profile for your slicer ([Cura](#cura-profiles), [OrcaSlicer](#orcaslicer-profiles), [PrusaSlicer](#prusaslicer-profiles))
2. Import into your slicer
3. Select material profile
4. Slice and print!

---

## Slicer Profiles

### Cura Profiles

Located in [`profiles/cura/`](profiles/cura/)

| Profile | Description |
|---------|-------------|
| `creality-ender3-v2-standard.curaprofile` | Balanced quality/speed |
| `creality-ender3-v2-quality.curaprofile` | High detail, slower |
| `creality-ender3-v2-fast.curaprofile` | Draft quality, fast |
| `creality-k1-highspeed.curaprofile` | Optimized for K1 speeds |

### OrcaSlicer Profiles

Located in [`profiles/orcaslicer/`](profiles/orcaslicer/)

| Profile | Description |
|---------|-------------|
| `Creality_Ender3_V2.json` | Standard profile |
| `Creality_K1.json` | High-speed CoreXY |
| `Creality_K1_Max.json` | Large format high-speed |

### PrusaSlicer Profiles

Located in [`profiles/prusaslicer/`](profiles/prusaslicer/)

| Profile | Description |
|---------|-------------|
| `Creality_Ender3_V2.ini` | Compatible profile |
| `Creality_K1_Series.ini` | K1/K1 Max profile |

---

## Material Profiles

### PLA (Standard)

```
Temperature:
  Nozzle: 200-210°C (first layer: 215°C)
  Bed: 60°C (first layer: 65°C)

Speed:
  Print: 50-60 mm/s
  Travel: 150 mm/s
  First Layer: 20 mm/s

Cooling:
  Fan: 100% after layer 2
  Min Layer Time: 10s

Retraction:
  Distance: 5mm (Bowden) / 1mm (Direct Drive)
  Speed: 45 mm/s
```

### PETG

```
Temperature:
  Nozzle: 230-240°C (first layer: 235°C)
  Bed: 80°C (first layer: 85°C)

Speed:
  Print: 40-50 mm/s
  Travel: 150 mm/s
  First Layer: 15 mm/s

Cooling:
  Fan: 50% after layer 3
  Min Layer Time: 15s

Retraction:
  Distance: 4mm (Bowden) / 0.8mm (Direct Drive)
  Speed: 35 mm/s

Notes:
  - Disable Z-hop to prevent stringing
  - Use glue stick on glass beds
```

### ABS

```
Temperature:
  Nozzle: 240-250°C (first layer: 245°C)
  Bed: 100-110°C (first layer: 110°C)

Speed:
  Print: 40-50 mm/s
  Travel: 150 mm/s
  First Layer: 15 mm/s

Cooling:
  Fan: 0-30% (enclosed printer only)
  Min Layer Time: 20s

Retraction:
  Distance: 5mm (Bowden) / 1mm (Direct Drive)
  Speed: 40 mm/s

Notes:
  - REQUIRES enclosure
  - Good ventilation essential
  - Brim recommended for bed adhesion
```

### TPU (Flexible)

```
Temperature:
  Nozzle: 220-235°C (first layer: 230°C)
  Bed: 50°C (first layer: 55°C)

Speed:
  Print: 20-30 mm/s
  Travel: 100 mm/s
  First Layer: 10 mm/s

Cooling:
  Fan: 50% after layer 2
  Min Layer Time: 15s

Retraction:
  Distance: 0-2mm (Direct Drive ONLY)
  Speed: 20 mm/s

Notes:
  - Direct drive extruder recommended
  - Disable retraction for Bowden setups
  - Linear advance off
```

### High-Speed PLA (K1/K1 Max)

```
Temperature:
  Nozzle: 220-230°C
  Bed: 55°C

Speed:
  Print: 300 mm/s
  Travel: 500 mm/s
  First Layer: 50 mm/s
  Acceleration: 10000-20000 mm/s²

Cooling:
  Fan: 100% after layer 1
  Aux Fan: 100%

Flow:
  Volumetric: 24+ mm³/s
  Line Width: 0.42mm (0.4 nozzle)
```

---

## Start G-code

### Ender 3 V2 / V3 (Marlin)

```gcode
; Ender 3 V2/V3 Start G-code
; ==============================

G90                          ; Absolute positioning
M82                          ; Absolute extrusion
G28                          ; Home all axes
M420 S1                      ; Enable bed leveling mesh (if saved)

; Heat bed first (prevents warping)
M190 S{material_bed_temperature_layer_0}

; Preheat nozzle (prevent ooze during leveling)
M104 S150

; Auto bed level (optional - uncomment if needed)
; G29

; Heat nozzle to print temp
M109 S{material_print_temperature_layer_0}

; Prime line
G92 E0                       ; Reset extruder
G1 Z2.0 F3000               ; Move Z up
G1 X0.1 Y20 Z0.3 F5000.0    ; Move to start
G1 X0.1 Y200.0 Z0.3 F1500.0 E15  ; Draw first line
G1 X0.4 Y200.0 Z0.3 F5000.0      ; Move to side
G1 X0.4 Y20 Z0.3 F1500.0 E30     ; Draw second line
G92 E0                       ; Reset extruder
G1 Z2.0 F3000               ; Move Z up
G1 X5 Y20 Z0.3 F5000.0      ; Move away from prime line

; Ready to print
M117 Printing...
```

### Ender 3 S1 (Direct Drive)

```gcode
; Ender 3 S1 Start G-code
; ==============================

G90                          ; Absolute positioning
M82                          ; Absolute extrusion
G28                          ; Home all axes

; Bed heating
M190 S{material_bed_temperature_layer_0}

; CR Touch probe
G29                          ; Auto bed level

; Nozzle heating
M109 S{material_print_temperature_layer_0}

; Prime line
G92 E0
G1 Z2.0 F3000
G1 X0.1 Y20 Z0.3 F5000.0
G1 X0.1 Y200.0 Z0.3 F1500.0 E15
G1 X0.4 Y200.0 Z0.3 F5000.0
G1 X0.4 Y20 Z0.3 F1500.0 E30
G92 E0
G1 Z2.0 F3000
G1 X5 Y20 Z0.3 F5000.0

M117 Printing...
```

### K1 / K1 Max (Klipper)

```gcode
; K1/K1 Max Start G-code (Klipper)
; ==============================

START_PRINT BED_TEMP={material_bed_temperature_layer_0} EXTRUDER_TEMP={material_print_temperature_layer_0}

; The START_PRINT macro handles:
; - Heating
; - Homing
; - Bed mesh (if enabled)
; - Prime line
; - Waiting for chamber temp (if enclosed)
```

### Klipper START_PRINT Macro (printer.cfg)

```ini
[gcode_macro START_PRINT]
gcode:
    {% set BED_TEMP = params.BED_TEMP|default(60)|float %}
    {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(200)|float %}

    # Start heating
    M140 S{BED_TEMP}                    ; Set bed temp
    M104 S150                           ; Preheat nozzle

    # Home
    G90                                 ; Absolute positioning
    G28                                 ; Home all axes

    # Wait for bed
    M190 S{BED_TEMP}

    # Bed mesh
    BED_MESH_CALIBRATE ADAPTIVE=1       ; Adaptive mesh

    # Heat nozzle
    M109 S{EXTRUDER_TEMP}

    # Prime line
    G92 E0
    G1 Z2.0 F3000
    G1 X0.1 Y20 Z0.3 F5000.0
    G1 X0.1 Y200.0 Z0.3 F1500.0 E15
    G1 X0.4 Y200.0 Z0.3 F5000.0
    G1 X0.4 Y20 Z0.3 F1500.0 E30
    G92 E0
    G1 Z5.0 F3000

    M117 Printing...
```

---

## End G-code

### Universal End G-code

```gcode
; End G-code
; ==============================

G91                          ; Relative positioning
G1 E-2 F2700                ; Retract filament
G1 Z10 F3000                ; Raise Z
G90                          ; Absolute positioning
G1 X0 Y220 F6000            ; Present print
M104 S0                      ; Turn off hotend
M140 S0                      ; Turn off bed
M106 S0                      ; Turn off fan
M84                          ; Disable motors

M117 Print Complete!
```

### K1 End G-code (Klipper)

```gcode
END_PRINT
```

### Klipper END_PRINT Macro

```ini
[gcode_macro END_PRINT]
gcode:
    # Safe retract
    G91
    G1 E-5 F1800
    G1 Z10 F3000

    # Present print
    G90
    G1 X0 Y{printer.toolhead.axis_maximum.y - 10} F6000

    # Turn off heaters
    TURN_OFF_HEATERS

    # Disable motors after delay
    M84 X Y E

    # Part cooling
    M106 S255
    G4 P30000                           ; Wait 30 seconds
    M106 S0

    M117 Print Complete!
```

---

## Calibration Guides

### 1. PID Tuning

**Hotend PID (Marlin)**
```gcode
M303 E0 S200 C8             ; PID tune hotend at 200°C
M500                         ; Save to EEPROM
```

**Hotend PID (Klipper)**
```gcode
PID_CALIBRATE HEATER=extruder TARGET=200
SAVE_CONFIG
```

**Bed PID (Marlin)**
```gcode
M303 E-1 S60 C8             ; PID tune bed at 60°C
M500                         ; Save to EEPROM
```

**Bed PID (Klipper)**
```gcode
PID_CALIBRATE HEATER=heater_bed TARGET=60
SAVE_CONFIG
```

### 2. E-Steps Calibration

```gcode
; 1. Heat hotend
M104 S200
M109 S200

; 2. Mark filament at 120mm from extruder entrance

; 3. Extrude 100mm slowly
G91
G1 E100 F100
G90

; 4. Measure remaining distance to mark
;    If 20mm remains = perfect
;    If <20mm = over-extruding
;    If >20mm = under-extruding

; 5. Calculate new E-steps
;    New E-steps = Current E-steps × (100 / actual extruded)

; 6. Set new E-steps (example: 93)
M92 E93
M500                         ; Save to EEPROM
```

### 3. Flow Rate Calibration

1. Print single-wall cube (no infill, no top)
2. Measure wall thickness with calipers
3. Calculate: `New Flow = (Expected Width / Measured Width) × 100`
4. Update flow rate in slicer

### 4. Pressure Advance (Klipper) / Linear Advance (Marlin)

**Klipper Pressure Advance**
```gcode
; Print PA test pattern
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=1 ACCEL=500
TUNING_TOWER COMMAND=SET_PRESSURE_ADVANCE PARAMETER=ADVANCE START=0 FACTOR=.005

; Measure best layer height, calculate PA value
; Add to printer.cfg:
; [extruder]
; pressure_advance: 0.05
```

**Marlin Linear Advance**
```gcode
; Use K-factor test print from Marlin documentation
; Set in firmware or via G-code:
M900 K0.05
M500
```

### 5. Input Shaper (Klipper)

```gcode
; Using ADXL345 accelerometer
SHAPER_CALIBRATE

; Or manual resonance test
TEST_RESONANCES AXIS=X
TEST_RESONANCES AXIS=Y

; Analyze and apply results
; Add to printer.cfg:
; [input_shaper]
; shaper_freq_x: 48.8
; shaper_freq_y: 35.2
; shaper_type: mzv
```

---

## Troubleshooting

### Common Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| First layer not sticking | Bed too far, bed dirty | Re-level, clean with IPA |
| Stringing | Temp too high, retraction low | Lower temp, increase retraction |
| Layer shifts | Belts loose, speed too high | Tighten belts, reduce speed |
| Under-extrusion | Clogged nozzle, low temp | Clean/replace nozzle, raise temp |
| Over-extrusion | E-steps wrong, flow too high | Calibrate E-steps, reduce flow |
| Warping | Bed cooling, poor adhesion | Enclosure, brim, bed adhesive |
| Z-banding | Lead screw issue, Z binding | Clean/lube lead screw, check coupling |
| Ghosting/Ringing | Speed too high, loose belts | Reduce speed/accel, tighten belts |

### Bed Adhesion Solutions

| Surface | Best For | Adhesion Aid |
|---------|----------|--------------|
| Glass | PLA, PETG | Glue stick, hairspray |
| PEI (Smooth) | PLA, ABS | Clean with IPA |
| PEI (Textured) | PETG, PLA | Clean with IPA |
| BuildTak | PLA, ABS | None needed |
| Magnetic Flex | PLA, PETG | None needed |

---

## Maintenance Schedule

### Every Print
- [ ] Check bed level (first layer)
- [ ] Clear debris from bed
- [ ] Inspect nozzle for clogs

### Weekly
- [ ] Clean bed with IPA
- [ ] Check belt tension
- [ ] Lubricate Z-axis lead screw
- [ ] Clean extruder gears

### Monthly
- [ ] Tighten all frame bolts
- [ ] Check wheel/rail wear
- [ ] Clean/replace nozzle
- [ ] Update firmware (if available)
- [ ] Backup printer settings

### Quarterly
- [ ] Replace Bowden tube (if applicable)
- [ ] Check wiring for wear
- [ ] Re-calibrate E-steps
- [ ] Full PID tune

---

## Useful G-code Commands

### Status & Info
```gcode
M115                         ; Firmware info
M503                         ; Current settings
M119                         ; Endstop status
M105                         ; Current temps
```

### Movement
```gcode
G28                          ; Home all
G28 X Y                      ; Home X and Y only
G28 Z                        ; Home Z only
G1 X100 Y100 F3000          ; Move to position
G1 Z10 F300                  ; Move Z
```

### Temperature
```gcode
M104 S200                    ; Set hotend (no wait)
M109 S200                    ; Set hotend (wait)
M140 S60                     ; Set bed (no wait)
M190 S60                     ; Set bed (wait)
```

### Bed Leveling
```gcode
G29                          ; Auto bed level
M420 S1                      ; Enable mesh
M420 S0                      ; Disable mesh
M421 X0 Y0 Z0.1             ; Set mesh point manually
```

### Extruder
```gcode
G92 E0                       ; Reset extruder position
M82                          ; Absolute extrusion
M83                          ; Relative extrusion
G1 E10 F100                  ; Extrude 10mm
G1 E-5 F1800                 ; Retract 5mm
```

### Save/Load
```gcode
M500                         ; Save to EEPROM
M501                         ; Load from EEPROM
M502                         ; Reset to defaults
```

---

## File Structure

```
3d-printing/
├── README.md
├── profiles/
│   ├── cura/
│   │   ├── creality-ender3-v2-standard.curaprofile
│   │   ├── creality-ender3-v2-quality.curaprofile
│   │   └── creality-k1-highspeed.curaprofile
│   ├── orcaslicer/
│   │   ├── Creality_Ender3_V2.json
│   │   └── Creality_K1.json
│   └── prusaslicer/
│       └── Creality_Ender3_V2.ini
├── gcode/
│   ├── start-gcode-ender3.gcode
│   ├── start-gcode-k1.gcode
│   └── end-gcode-universal.gcode
└── klipper/
    ├── printer-ender3-v2.cfg
    └── macros.cfg
```

---

## Resources

- [Creality Official](https://www.creality.com/)
- [Klipper Documentation](https://www.klipper3d.org/)
- [Marlin Firmware](https://marlinfw.org/)
- [OrcaSlicer](https://github.com/SoftFever/OrcaSlicer)
- [Teaching Tech Calibration](https://teachingtechyt.github.io/calibration.html)
- [Ellis' Print Tuning Guide](https://ellis3dp.com/Print-Tuning-Guide/)

---

*Profiles tested on Creality printers with stock and upgraded components. Your results may vary based on specific hardware configuration.*
