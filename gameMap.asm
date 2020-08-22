;===============================================================================
; Constants

MapLastColumn = 240 ; (6 * 40) - 1

;===============================================================================
; Variables

Operator Calc

MapRAMRowStartLow ; increments are 6 screens x 40 characters per row (240)
        byte <MAPRAM,      <MAPRAM+240,  <MAPRAM+480
        byte <MAPRAM+720,  <MAPRAM+960,  <MAPRAM+1200
        byte <MAPRAM+1440, <MAPRAM+1680, <MAPRAM+1920
        byte <MAPRAM+2160, <MAPRAM+2400, <MAPRAM+2640
        byte <MAPRAM+2880, <MAPRAM+3120, <MAPRAM+3360
        byte <MAPRAM+3600, <MAPRAM+3840, <MAPRAM+4080
        byte <MAPRAM+4320, <MAPRAM+4560, <MAPRAM+4800
        byte <MAPRAM+5040, <MAPRAM+5280, <MAPRAM+5520
        byte <MAPRAM+5760
MapRAMRowStartHigh
        byte >MAPRAM,      >MAPRAM+240,  >MAPRAM+480
        byte >MAPRAM+720,  >MAPRAM+960,  >MAPRAM+1200
        byte >MAPRAM+1440, >MAPRAM+1680, >MAPRAM+1920
        byte >MAPRAM+2160, >MAPRAM+2400, >MAPRAM+2640
        byte >MAPRAM+2880, >MAPRAM+3120, >MAPRAM+3360
        byte >MAPRAM+3600, >MAPRAM+3840, >MAPRAM+4080
        byte >MAPRAM+4320, >MAPRAM+4560, >MAPRAM+4800
        byte >MAPRAM+5040, >MAPRAM+5280, >MAPRAM+5520
        byte >MAPRAM+5760

MAPCOLORRAM = MAPRAM + 6000  ; 6 screens x 25 rows x 40 characters

MapRAMCOLRowStartLow ; increments are number of screens x 40 characters per row
        byte <MAPCOLORRAM,      <MAPCOLORRAM+240,  <MAPCOLORRAM+480
        byte <MAPCOLORRAM+720,  <MAPCOLORRAM+960,  <MAPCOLORRAM+1200
        byte <MAPCOLORRAM+1440, <MAPCOLORRAM+1680, <MAPCOLORRAM+1920
        byte <MAPCOLORRAM+2160, <MAPCOLORRAM+2400, <MAPCOLORRAM+2640
        byte <MAPCOLORRAM+2880, <MAPCOLORRAM+3120, <MAPCOLORRAM+3360
        byte <MAPCOLORRAM+3600, <MAPCOLORRAM+3840, <MAPCOLORRAM+4080
        byte <MAPCOLORRAM+4320, <MAPCOLORRAM+4560, <MAPCOLORRAM+4800
        byte <MAPCOLORRAM+5040, <MAPCOLORRAM+5280, <MAPCOLORRAM+5520
        byte <MAPCOLORRAM+5760
MapRAMCOLRowStartHigh
        byte >MAPCOLORRAM,      >MAPCOLORRAM+240,  >MAPCOLORRAM+480
        byte >MAPCOLORRAM+720,  >MAPCOLORRAM+960,  >MAPCOLORRAM+1200
        byte >MAPCOLORRAM+1440, >MAPCOLORRAM+1680, >MAPCOLORRAM+1920
        byte >MAPCOLORRAM+2160, >MAPCOLORRAM+2400, >MAPCOLORRAM+2640
        byte >MAPCOLORRAM+2880, >MAPCOLORRAM+3120, >MAPCOLORRAM+3360
        byte >MAPCOLORRAM+3600, >MAPCOLORRAM+3840, >MAPCOLORRAM+4080
        byte >MAPCOLORRAM+4320, >MAPCOLORRAM+4560, >MAPCOLORRAM+4800
        byte >MAPCOLORRAM+5040, >MAPCOLORRAM+5280, >MAPCOLORRAM+5520
        byte >MAPCOLORRAM+5760

Operator HiLo

;===============================================================================
; Macros/Subroutines

defm    GAMEMAP_SETCHAR_V              ; /1 = Character Code (Value)
        lda #/1
        sta (ZeroPageLow),Y
        endm

;==============================================================================

defm    GAMEMAP_GETCHAR  ; /1 = Return character code (Address)
        lda (ZeroPageLow),Y
        sta /1
        endm

;==============================================================================

defm    GAMEMAP_SETCHARPOSITION_AAA    ; /1 = X Position 0-240 (Address)
                                       ; /2 = Y Position 0-24 (Address)
                                       ; /3 = screen offset 0-40 (Address)
        
        ldy /2 ; load y position as index into list
        
        lda MapRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda MapRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        lda /1 ; load x position into Y register
        clc
        adc /3
        tay

        endm

;==============================================================================

gameMapInit
        lda #0
        sta screenColumn
        sta backgroundColumn
        sta backgroundScrollingColumn

        jsr gameColorUpdateTopExtra
        jsr gameColorUpdateTop
        jsr gameMapUpdateTopExtra
        jsr gameMapUpdateTop
        jsr gameColorUpdateBottomExtra
        jsr gameColorUpdateBottom
        jsr gameMapUpdateBottomExtra
        jsr gameMapUpdateBottom

        ;jsr gameMapUpdateBottomPrimaryScoreArea
        ;jsr gameMapUpdateBottomSecondaryScoreArea

        rts

;===============================================================================

gameMapUpdateTopExtra
        lda screenTwoActive
        beq @updateSecondary
        jsr gameMapUpdateTopPrimaryExtra
        jmp @finished
@updateSecondary
        jsr gameMapUpdateTopSecondaryExtra
@finished

        rts

gameMapUpdateTop
        lda screenTwoActive
        beq @updateSecondary
        jsr gameMapUpdateTopPrimary
        jmp @finished
@updateSecondary
        jsr gameMapUpdateTopSecondary
@finished

        rts

gameColorUpdateTopExtra

        ; colors
        ;LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM,     COLORRAM,     backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+240,  COLORRAM+40,  backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+480,  COLORRAM+80,  backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+720,  COLORRAM+120, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+960,  COLORRAM+160, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+1200, COLORRAM+200, backgroundColumn

        rts

gameColorUpdateTop

        ; colors
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+1440, COLORRAM+240, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+1680, COLORRAM+280, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+1920, COLORRAM+320, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+2160, COLORRAM+360, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+2400, COLORRAM+400, backgroundColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+2640, COLORRAM+440, backgroundColumn

        rts

gameMapUpdateBottomExtra
        lda screenTwoActive
        beq @updateSecondary
        jsr gameMapUpdateBottomPrimaryExtra
        jmp @finished
@updateSecondary
        jsr gameMapUpdateBottomSecondaryExtra
@finished

        rts

gameMapUpdateBottom

        lda screenTwoActive
        beq @updateSecondary
        jsr gameMapUpdateBottomPrimary
        jmp @finished
@updateSecondary
        jsr gameMapUpdateBottomSecondary
@finished

        rts

gameColorUpdateBottomExtra

        ; colors
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+4320, COLORRAM+720, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+4560, COLORRAM+760, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+4800, COLORRAM+800, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+5040, COLORRAM+840, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+5280, COLORRAM+880, screenColumn
        ;LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+5520, COLORRAM+920, screenColumn
        ;LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+5760, COLORRAM+960, screenColumn

        rts

gameColorUpdateBottom

        ; colors
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+2880, COLORRAM+480, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+3120, COLORRAM+520, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+3360, COLORRAM+560, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+3600, COLORRAM+600, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+3840, COLORRAM+640, screenColumn
        LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA MAPCOLORRAM+4080, COLORRAM+680, screenColumn

        rts

;===============================================================================

gameMapUpdateTopPrimaryExtra

        ; map characters
        ;LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM,      SCREENRAMONE,     backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+240,  SCREENRAMONE+40,  backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+480,  SCREENRAMONE+80,  backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+720,  SCREENRAMONE+120, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+960,  SCREENRAMONE+160, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1200, SCREENRAMONE+200, backgroundScrollingColumn

        rts

gameMapUpdateTopPrimary

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1440, SCREENRAMONE+240, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1680, SCREENRAMONE+280, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1920, SCREENRAMONE+320, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2160, SCREENRAMONE+360, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2400, SCREENRAMONE+400, backgroundScrollingColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2640, SCREENRAMONE+440, backgroundScrollingColumn

        rts

;===============================================================================

gameMapUpdateBottomPrimaryScoreArea

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5520, SCREENRAMONE+920, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5760, SCREENRAMONE+960, screenColumn

        rts

gameMapUpdateBottomPrimaryExtra

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4320, SCREENRAMONE+720, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4560, SCREENRAMONE+760, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4800, SCREENRAMONE+800, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5040, SCREENRAMONE+840, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5280, SCREENRAMONE+880, screenColumn
        ;LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5520, SCREENRAMONE+920, screenColumn
        ;LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5760, SCREENRAMONE+960, screenColumn

        rts

gameMapUpdateBottomPrimary

        ; map characters        
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2880, SCREENRAMONE+480, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3120, SCREENRAMONE+520, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3360, SCREENRAMONE+560, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3600, SCREENRAMONE+600, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3840, SCREENRAMONE+640, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4080, SCREENRAMONE+680, screenColumn

        rts

;===============================================================================

gameMapUpdateTopSecondaryExtra

        ; map characters
        ;LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM,      SCREENRAMTWO,     backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+240,  SCREENRAMTWO+40,  backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+480,  SCREENRAMTWO+80,  backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+720,  SCREENRAMTWO+120, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+960,  SCREENRAMTWO+160, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1200, SCREENRAMTWO+200, backgroundColumn

        rts

gameMapUpdateTopSecondary

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1440, SCREENRAMTWO+240, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1680, SCREENRAMTWO+280, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+1920, SCREENRAMTWO+320, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2160, SCREENRAMTWO+360, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2400, SCREENRAMTWO+400, backgroundColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2640, SCREENRAMTWO+440, backgroundColumn

        rts

;===============================================================================

gameMapUpdateBottomSecondaryScoreArea

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5520, SCREENRAMTWO+920, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5760, SCREENRAMTWO+960, screenColumn

        rts

gameMapUpdateBottomSecondaryExtra

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4320, SCREENRAMTWO+720, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4560, SCREENRAMTWO+760, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4800, SCREENRAMTWO+800, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5040, SCREENRAMTWO+840, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5280, SCREENRAMTWO+880, screenColumn
        ;LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5520, SCREENRAMTWO+920, screenColumn
        ;LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+5760, SCREENRAMTWO+960, screenColumn

        rts

gameMapUpdateBottomSecondary

        ; map characters
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+2880, SCREENRAMTWO+480, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3120, SCREENRAMTWO+520, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3360, SCREENRAMTWO+560, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3600, SCREENRAMTWO+600, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+3840, SCREENRAMTWO+640, screenColumn
        LIBSCREEN_COPYMAPROW_NEW_VVA MAPRAM+4080, SCREENRAMTWO+680, screenColumn

        rts
