;===============================================================================
; BASIC Loader

*=$0801 ; 10 SYS (2064)

        byte $0E, $08, $0A, $00, $9E, $20, $28, $32
        byte $30, $36, $34, $29, $00, $00, $00

        ; Our code starts at $0810 (2064 decimal)
        ; after the 15 bytes for the BASIC loader

        jmp $8000

;===============================================================================
; Initialize

*=$8000

        ; Turn off interrupts to stop LIBSCREEN_WAIT failing every so 
        ; often when the kernal interrupt syncs up with the scanline test
        ;sei

        ; Disable run/stop + restore keys
        lda #$FC 
        sta $0328

        ; disable BASIC ROM
        lda $01
        and #%11111110
        sta $01

        ; Set multicolor background mode
        LIBSCREEN_SETMULTICOLORMODE

        ; Set border and background colors
        ; The last 3 parameters are not used yet
        LIBSCREEN_SETCOLORS Black, Black, Black, Black, Black

        ; Fill 1000 bytes (40x25) of screen memory 
        LIBSCREEN_SET1000 SCREENRAMONE, SpaceCharacter

        ; Fill 1000 bytes (40x25) of screen memory 
        LIBSCREEN_SET1000 SCREENRAMTWO, SpaceCharacter

        ; Fill 1000 bytes (40x25) of color memory
        LIBSCREEN_SET1000 COLORRAM, Black

        ; Set sprite multicolors
        LIBSPRITE_SETMULTICOLORS_VV MediumGray, Black

        ; Set the memory location of the custom character set
        LIBSCREEN_SETCHARMEMORY 14

        ; Set 38 column screen mode
        LIBSCREEN_SET38COLUMNMODE
        
        ; Set 24 row screen mode
        ;LIBSCREEN_SET24ROWMODE

        lda #1
        sta screenOneActive
        lda #0
        sta screenTwoActive

        ; set up raster interrupt
        lda #%01111111
        sta $DC0D
        and $D011
        sta $D011
        lda #255
        sta $D012
        lda #<Irq3
        sta $0314
        lda #>Irq3
        sta $0315
        lda #%00000001
        sta $D01A
       
        ; initialize the music
        jsr libMusicInit
 
        ; initialize the sound
        jsr libSoundInit

        ; Initialize the game
        jsr gamePlayerInit
        jsr gameBaronInit

        ; Initialize the game
        jsr gameMapInit

mainLoop
        jmp mainLoop


;===============================================================================
; Update

gMLoop1

        ; Update the library
        lda #13
        sta EXTCOL
        jsr libInputUpdate

        ; Update the game
        lda #8
        sta EXTCOL
        jsr gamePlayerUpdate

        ; End code timer reset border color
        lda #0
        sta EXTCOL

        rts

gMLoop2

        lda #3
        sta EXTCOL
        jsr gameBulletsUpdate

        lda #8
        sta EXTCOL
        jsr gameBombUpdate

        ; End code timer reset border color
        lda #0
        sta EXTCOL

        rts

gmLoop3

        lda #11
        sta EXTCOL
        jsr gameBaronUpdate

        ; End code timer reset border color
        lda #0
        sta EXTCOL

        rts

Irq     ; fires at raster line 10
        LIBSCREEN_SETCOLORS Black, LightBlue, Brown, White, Black
        LIBSCREEN_SCROLLTOBACKGROUND

        lda #5
        sta EXTCOL

        SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     6, 6, gameMapUpdateBottom, gameMapUpdateBottom
        ;SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     0, 6, gameColorUpdateBottom, gameColorUpdateBottom
        SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     0, 0, gameMapUpdateBottomExtra, gameMapUpdateBottomExtra


        ;lda #9
        ;sta EXTCOL

        SCREEN_UPDATE_SCROLLING_AVVAA backgroundScrollXValue,     1, 1, gameMapUpdateTop, gameMapUpdateTop
        SCREEN_UPDATE_SCROLLING_AVVAA backgroundScrollXValue,     5, 5, gameMapUpdateTop, gameMapUpdateTop
        ;SCREEN_UPDATE_SCROLLING_AVVAA backgroundScrollXValue,     6, 0, gameColorUpdateTop, gameColorUpdateTop
        SCREEN_UPDATE_SCROLLING_AVVAA backgroundScrollXValue,     2, 2, gameMapUpdateTopExtra, gameMapUpdateTopExtra
        SCREEN_UPDATE_SCROLLING_AVVAA backgroundScrollXValue,     6, 6, gameMapUpdateTopExtra, gameMapUpdateTopExtra
        
        lda #15
        sta EXTCOL

        ; play a music frame only if the player is not alive
        lda playerActive
        bne @skipMusic
        jsr libMusicUpdate

@skipMusic        
        jsr libSoundUpdate

        jsr libSpritesUpdate

        lda #0
        sta EXTCOL

        jsr gMLoop3

        lda #<Irq2
        sta $0314
        lda #>Irq2
        sta $0315
        lda #146
        sta $D012
        lsr $D019
        jmp $EA81

Irq2    ; fires at raster line 146
        LIBSCREEN_SETCOLORS Black, Brown, Green, White, Black
        lda #5
        sta EXTCOL
        LIBSCREEN_SCROLLTOFOREGROUND
        ;SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     2, 4, gameMapUpdateBottomExtra, gameMapUpdateBottomExtra
        ;SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     0, 6, gameColorUpdateBottomExtra, gameColorUpdateBottomExtra
        ;SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     4, 2, gameMapUpdateTopExtra, gameMapUpdateTopExtra
        ;SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue,     6, 0, gameColorUpdateTopExtra, gameColorUpdateTopExtra

        jsr gMLoop2

        lda #<Irq3
        sta $0314
        lda #>Irq3
        sta $0315
        lda #234
        sta $D012
        lsr $D019
        jmp $EA81

Irq3    ; fires at raster line 234
        LIBSCREEN_SETCOLORS Black, Red, Green, White, Red
        lda #2
        sta EXTCOL
        LIBSCREEN_SCROLLTOSCOREBOARD

        SCREEN_UPDATE_SCROLLING_AVVAA screenScrollXValue, 6, 0, flipScreenLeft, flipScreenRight
        SCREEN_UPDATE_SCROLLING_AVVAA backgroundScrollXValue, 4, 4, flipBackgroundLeft, flipBackgroundRight

        jsr gMLoop1

        lda #30
        sta ZeroPageTemp
        lda #23
        sta ZeroPageTemp2
        LIBSCREEN_DRAWDECIMAL_AAAVV ZeroPageTemp, ZeroPageTemp2, screenDebugZero, 1, 0
        LIBSCREEN_DRAWDECIMAL_AAAVV ZeroPageTemp, ZeroPageTemp2, screenDebugZero, 1, 1

        lda #30
        sta ZeroPageTemp
        lda #24
        sta ZeroPageTemp2
        LIBSCREEN_DRAWDECIMAL_AAAVV ZeroPageTemp, ZeroPageTemp2, screenDebugOne, 1, 0
        LIBSCREEN_DRAWDECIMAL_AAAVV ZeroPageTemp, ZeroPageTemp2, screenDebugOne, 1, 1

        lda #<Irq
        sta $0314
        lda #>Irq
        sta $0315
        lda #10
        sta $D012
        lsr $D019
        jmp $EA81

;===============================================================================

defm SCREEN_UPDATE_SCROLLING_AVVAA

        lda ScreenScrollingRight
        bne @scrollNegative
        lda ScreenScrollingLeft
        bne @scrollPositive
        jmp @finished
@scrollNegative
        lda /1
        cmp #/2
        bne @finished
        jsr /4
        jmp @finished
@scrollPositive
        lda /1
        cmp #/3
        bne @finished
        jsr /5
@finished

        endm

;===============================================================================

flipScreen

        lda screenOneActive
        beq @flipSecondary

@flipPrimary
        lda $D018
        and #%00001111
        ora #%10000000      ; set active screen RAM to SCREENRAMTWO/$2000
        sta $D018
        lda #1
        sta screenTwoActive
        lda #0
        sta screenOneActive

        jmp @finished

@flipSecondary
        lda $D018
        and #%00001111
        ora #%00010000      ; set active screen RAM to SCREENRAMONE/$0400
        sta $D018
        lda #0
        sta screenTwoActive
        lda #1
        sta screenOneActive

@finished

        rts

;===============================================================================

flipScreenRight

        jsr flipScreen

        inc screenColumn
        lda screenColumn
        cmp #MapLastColumn
        bcc @screenColumnResetDone
        lda #0
        sta screenColumn
@screenColumnResetDone

        rts

;===============================================================================

flipBackgroundRight

        inc backgroundColumn
        lda backgroundColumn
        cmp #MapLastColumn
        bcc @finished
        lda #0
        sta backgroundColumn

@finished
        rts

;===============================================================================

flipScreenLeft

        jsr flipScreen

        dec screenColumn
        lda screenColumn
        cmp #1
        bcs @screenColumnResetDone
        lda #MapLastColumn
        sta screenColumn
@screenColumnResetDone

        rts

;===============================================================================

flipBackgroundLeft

        dec backgroundColumn
        lda backgroundColumn
        cmp #1
        bcs @finished
        lda #MapLastColumn
        sta backgroundColumn

@finished
        rts
