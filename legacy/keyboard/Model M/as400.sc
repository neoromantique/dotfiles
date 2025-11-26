layerblock
  FN1 1  # FN1 is a virtual key and is not the same thing as a physical F1 function key.
endblock

remapblock

F13           ESC
ESC           NUM_LOCK
NUM_LOCK      PAD_SLASH
SCROLL_LOCK   PAD_ASTERIX
EXTRA_SYSRQ   PAD_MINUS
PAD_MINUS     PAD_PLUS
PAD_PLUS      PAD_ENTER
PAD_ASTERIX   TAB
RALT          LGUI
BACKSLASH     EUROPE_2
F23           PRINTSCREEN
F24           SCROLL_LOCK
LANG_4        PAUSE
RALT	      FN1

endblock

remapblock
 layer 1
	BACKSLASH		BACKSLASH
    L               EXSEL
    E               LGUI + E
    D               LGUI + D
    RIGHT_BRACE     MEDIA_VOLUME_UP
    LEFT_BRACE      MEDIA_VOLUME_DOWN
    P               MEDIA_MUTE
    RCTRL           F22
endblock

macroblock
    macro EXSEL
        PUSH_META SET_META LGUI
        press L
        POP_ALL_META
    endmacro

    macro F22
        press 6
        press 1
        press ENTER
    endmacro

endblock
