; The catalog of ui element crop boundaries
global UI_CATALOG := {}

; Available elements in the catalog
global UI_ELEMENTS := [ "Sensitivity", "InspectedItemName", "InspectedEmblemName" ]

; Crop boundaries are as follows: [ left, top, right, bottom ]

; Element crop boundaries
Sensitivity := [ 0.83, 0.25, 0.87, 0.275 ]
InspectedItemName := [ 0.137, 0.13, 0.80, 0.196 ]
InspectedEmblemName := [ 0.12, 0.025, 0.70, 0.20 ]

for _, ui_element in UI_ELEMENTS {
    UI_CATALOG[ui_element] := %ui_element%
}

; Example usage: print the crop boundaries of 'Sensitivity'
; for key, value in ui_catalog {
;     MsgBox, % key "Left: " value[1] ", Top: " value[2] ", Right: " value[3] ", Bottom: " value[4]
; }
