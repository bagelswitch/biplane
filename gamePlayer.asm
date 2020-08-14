;==============================================================================
; Constants

PlayerMaxFrame          = 24
PlayerXMinHigh          = 0     ; 0*256 + 24 = 24  minX
PlayerXMinLow           = 24
PlayerXMaxHigh          = 1     ; 1*256 + 64 = 320 maxX
PlayerXMaxLow           = 64
PlayerYMin              = 30
PlayerYMax              = 229
PlayerInputDelay        = 3
PlayerFireDelay         = 1
PlayerXMinScrollHigh    = 0     ; 0*256 + 150 = 150  minX
PlayerXMinScrollLow     = 170
PlayerXMaxScrollHigh    = 0     ; 0*256 + 190 = 190 maxX
PlayerXMaxScrollLow     = 170

;===============================================================================
; Variables

;playerActive          byte 1
;playerFrame           byte 6
;playerSpriteFrame     byte 0
;playerSprite          byte 0
;playerXHigh           byte 0
;playerXLow            byte 25
;playerY               byte 55
;playerXChar           byte 0
;playerXOffset         byte 0
;playerYChar           byte 0
;playerYOffset         byte 0
;playerHorizontalSpeed byte 3
;playerVerticalSpeed   byte 0
;playerHorizontalBombSpeed byte 0
;playerVerticalBombSpeed   byte 0
;playerHorizontalBulletSpeed byte 1
;playerVerticalBulletSpeed   byte 1

                        ; down-sampled animation frames to reduce sprite size
playerSpriteFrameConv   byte    0,  0,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4
                        byte    4,  4,  5,  5,  5,  6,  6,  6,  7,  7,  7,  0

                        ; horizontal velocities by sprite frame
playerXmoveArray        byte    0,  1,  1,  2,  2,  2,  3,  2,  2,  2,  1,  1
                        byte    0,  1,  1,  2,  2,  2,  3,  2,  2,  2,  1,  1

                        ; vertical velocities by sprite frame
playerYmoveArray        byte   -3, -2, -2, -2, -1,  -1,  0,  1,  1,  2,  2,  2
                        byte    3,  2,  2,  2,  1,   1,  0, -1, -1, -2, -2, -2


                        ; bullet directions by sprite frame
playerXbulletArray      byte    0,  0,  3,  3,  3,  6,  6,  6,  3,  3,  3,  0
                        byte    0,  0,  3,  3,  3,  6,  6,  6,  3,  3,  3,  0

                        ; bullet directions by sprite frame
playerYbulletArray      byte   -6, -6, -3, -3, -3,  0,  0,  0,  3,  3,  3,  6
                        byte    6,  6,  3,  3,  3,  0,  0,  0, -3, -3, -3, -6

                        ; horizontal velocities by sprite frame
playerXbombArray        byte    0,  1,  1,  2,  2,  2,  2,  2,  2,  2,  1,  1
                        byte    0,  1,  1,  2,  2,  2,  2,  2,  2,  2,  1,  1

                        ; vertical velocities by sprite frame
playerYbombArray        byte   -4, -4, -3, -2, -1,  0,  0,  1,  1,  2,  2,  2
                        byte    3,  2,  2,  2,  1,  1,  0,  0, -1, -2, -3, -4



;===============================================================================
; Macros/Subroutines

gamePlayerInit

        ; re-initialize the music
        jsr libMusicInit

        lda #True
        sta playerActive

        LIBSPRITE_STOPANIM_A playerOutlineSprite
        LIBSPRITE_STOPANIM_A playerColorSprite

        lda #6
        sta playerFrame

        lda #0
        sta playerVerticalSpeed

        lda #3
        sta playerHorizontalSpeed

        lda #0
        sta playerXHigh
        lda #25
        sta playerXLow
        lda #55
        sta playerY

        lda #1
        sta playerXChar
        
        lda #0
        sta playerOutlineSprite

        lda #1
        sta playerColorSprite

        LIBSPRITE_ENABLE_AV             playerOutlineSprite, True
        LIBSPRITE_ENABLE_AV             playerColorSprite, True
        ldx playerFrame
        lda playerSpriteFrameConv,x
        sta playerSpriteFrame
        LIBSPRITE_SETFRAME_AAV          playerOutlineSprite, playerSpriteFrame, PLAYEROUTLINERAM
        LIBSPRITE_SETCOLOR_AV           playerOutlineSprite, Black
        LIBSPRITE_MULTICOLORENABLE_AV   playerOutlineSprite, False
        LIBSPRITE_SETFRAME_AAV          playerColorSprite, playerSpriteFrame, PLAYERCOLORRAM
        LIBSPRITE_SETCOLOR_AV           playerColorSprite, Green
        LIBSPRITE_MULTICOLORENABLE_AV   playerColorSprite, True

        lda #0
        sta playerDelayCounter
        sta playerFireCounter

        rts

;==============================================================================

gamePlayerReset

        jsr gamePlayerInit

        ;LIBSPRITE_SETPOSITION_AAAA playerSprite, playerXHigh, playerXLow, playerY
        inc EXTCOL
        jsr gamePlayerUpdatePosition
        dec EXTCOL

        rts

;===============================================================================

gamePlayerUpdate      

        jsr gamePlayerUpdateFiring
        lda playerActive
        beq @skipUpdate
        inc EXTCOL
        jsr gamePlayerUpdatePosition
        inc EXTCOL
        jsr gamePlayerUpdateCollisions
        dec EXTCOL
        dec EXTCOL
        jmp @doneUpdate
@skipUpdate
        lda #1
        sta playerFrame
        lda #0
        sta playerVerticalSpeed
        lda #0
        sta playerHorizontalSpeed
        jmp gPUPEndmove
@doneUpdate

        rts

;==============================================================================

gamePlayerUpdateFiring

        ; do fire after the ship has been clamped to position
        ; so that the bullet lines up
        LIBINPUT_GETFIREPRESSED
        beq @firing
        jmp gPUFNofire

@firing
        lda playerActive
        bne playerCharActive
        ; bring the player back to life
        INCREMENT_FIRE_DELAY_AA playerFireCounter, gPUFNofire
        jsr gamePlayerReset
        jmp gPUFNofire

playerCharActive
        ; play firing sound and fire a bullet
        INCREMENT_FIRE_DELAY_AA playerFireCounter, gPUFNofire
        LIBSOUND_PLAY_VAA 1, soundExplosionHigh, soundExplosionLow
        GAMEBULLETS_FIRE_AAAVAAAA playerXHigh, playerXLow, playerY, Black, playerHorizontalBulletSpeed, playerVerticalBulletSpeed, playerOutlineSprite, playerFrame

gPUFNofire

        rts

;==============================================================================

gamePlayerUpdateCollisions

        lda playerActive
        beq @jumpNoCollision

        jmp @continue

@jumpNoCollision
        jmp @gPUCNoCollision

@continue

        ; if we have collided with someone else's bullet, always collision
        GAMEBULLETS_COLLIDED_AAAV playerXChar, playerYChar, playerOutlineSprite
        cmp #1
        beq @gPUCCollision

        ; if we haven't hit someone else's bullet and we're in the background layer, no collision
        lda playerYChar
        cmp #13
        bcc @gPUCNoCollision

        ; if we're above the vertical display area, no collision
        lda playerY
        cmp #40
        bcc @gPUCNoCollision

        ; if we have hit a non-terrain background character, no collision
        LIBSCREEN_BACKGROUND_CHECK playerXChar, playerYChar
        cmp #0
        beq @gPUCNoCollision

@gPUCcollision
        jsr gamePlayerDestroyPlayer
                                
@gPUCNoCollision

        rts

gamePlayerDestroyPlayer

        lda #False
        sta playerActive

        ; run explosion animation
        LIBSPRITE_SETFRAME_AVV          playerOutlineSprite, #0, EXPLOSION1RAM
        LIBSPRITE_SETCOLOR_AV           playerOutlineSprite, Yellow
        LIBSPRITE_PLAYANIM_AVVVV        playerOutlineSprite, 0, 11, 3, False

        LIBSPRITE_SETFRAME_AVV          playerColorSprite, #0, DEBRISRAM
        LIBSPRITE_SETCOLOR_AV           playerColorSprite, Black
        LIBSPRITE_PLAYANIM_AVVVV        playerColorSprite, 0, 11, 3, False

        ; play explosion sound
        LIBSOUND_PLAY_VAA 2, soundFiringHigh, soundFiringLow

        rts

;===============================================================================

defm INCREMENT_INPUT_DELAY_AA ; /1 = Current delay counter
        
        ldx /1
        inx
        cpx #PlayerInputDelay
        bcc @endDelay
        lda #0
        sta /1
        jmp @finished
@endDelay
        stx /1
        jmp /2
@finished

        endm

;===============================================================================

defm INCREMENT_FIRE_DELAY_AA ; /1 = Current delay counter
        
        ldx /1
        inx
        cpx #PlayerFireDelay
        bcc @endDelay
        lda #0
        sta /1
        jmp @finished
@endDelay
        stx /1
        jmp /2
@finished

        endm

;===============================================================================

gamePlayerUpdatePosition

gPUPLeft
        LIBINPUT_GETKEYPRESSED AKeyRow, AKeyBit
        beq keyLeft
        LIBINPUT_GETHELD GameportLeftMask
        bne gPUPRight
keyLeft
        INCREMENT_INPUT_DELAY_AA playerDelayCounter, gPUPEndmove
        dec playerFrame
        ldx playerFrame
        cpx #0
        bpl leftRotate
        ldx #23
        stx playerFrame
leftRotate
        lda playerXmoveArray,x
        sta playerHorizontalSpeed
        lda playerYmoveArray,x
        sta playerVerticalSpeed

        lda playerSpriteFrameConv,x
        sta playerSpriteFrame
        LIBSPRITE_SETFRAME_AAV           playerOutlineSprite, playerSpriteFrame, PLAYEROUTLINERAM
        LIBSPRITE_SETFRAME_AAV           playerColorSprite, playerSpriteFrame, PLAYERCOLORRAM

gPUPRight
        LIBINPUT_GETKEYPRESSED DKeyRow, DKeyBit
        beq keyRight
        LIBINPUT_GETHELD GameportRightMask
        bne gPUPUp
keyRight
        INCREMENT_INPUT_DELAY_AA playerDelayCounter, gPUPEndmove
        inc playerFrame
        ldx playerFrame
        cpx #24
        bmi rightRotate
        ldx #0
        stx playerFrame
rightRotate
        lda playerXmoveArray,x
        sta playerHorizontalSpeed
        lda playerYmoveArray,x
        sta playerVerticalSpeed

        lda playerSpriteFrameConv,x
        sta playerSpriteFrame
        LIBSPRITE_SETFRAME_AAV           playerOutlineSprite, playerSpriteFrame, PLAYEROUTLINERAM
        LIBSPRITE_SETFRAME_AAV           playerColorSprite, playerSpriteFrame, PLAYERCOLORRAM

gPUPUp
;        LIBINPUT_GETHELD GameportUpMask
;        bne gPUPDown
        
gPUPDown
        LIBINPUT_GETKEYPRESSED SKeyRow, SKeyBit
        beq keyDown
        LIBINPUT_GETHELD GameportDownMask
        bne gPUPEndmove
keyDown
        ; create a bomb!
        ldx playerFrame
        lda playerXbombArray,x
        sta playerHorizontalBombSpeed
        lda playerYbombArray,x
        sta playerVerticalBombSpeed
        GAMEBOMB_DROPBOMB_AAAAAA playerFrame, playerY, playerXHigh, playerXLow, playerVerticalBombSpeed, playerHorizontalBombSpeed

gPUPEndmove
        ldx playerFrame

        lda playerXbulletArray,X
        sta playerHorizontalBulletSpeed
        lda playerYbulletArray,X
        sta playerVerticalBulletSpeed

        ; apply horizontal velocity
        cpx #13
        bcs @leftMove
@rightMove
        LIBMATH_ADD16BIT_AAVAAA playerXHigh, PlayerXLow, 0, playerHorizontalSpeed, playerXHigh, PlayerXLow
        jmp @doneMove
@leftMove
        LIBMATH_SUB16BIT_AAVAAA playerXHigh, PlayerXLow, 0, playerHorizontalSpeed, playerXHigh, PlayerXLow
@doneMove

        ; apply vertical velocity
        LIBMATH_ADD8BIT_AAA PlayerY, playerVerticalSpeed, PlayerY 

        ; clamp player x position and scroll the screen if needed
        inc EXTCOL
        jsr gamePlayerClampXandScroll
        dec EXTCOL

        ; clamp the player y position
        LIBMATH_MIN8BIT_AV playerY, PlayerYMax
        LIBMATH_MAX8BIT_AV playerY, PlayerYMin

        ; set the sprite position
        ; can get away with 8 bits b/c the clamp area has <255 max X
        LIBSPRITE_SETPOSITION_AAA playerOutlineSprite, PlayerXLow, PlayerY
        LIBSPRITE_SETPOSITION_AAA playerColorSprite, PlayerXLow, PlayerY

        ; update the player char positions
        LIBSCREEN_PIXELTOCHAR_AAVAVAAAA playerXHigh, playerXLow, 16, playerY, 40, playerXChar, playerXOffset, playerYChar, playerYOffset

        ;LIBSCREEN_DEBUG8BIT_VVA 80, 80, playerDelayCounter

        rts


;===============================================================================

gamePlayerClampXandScroll

        lda #0
        sta screenScrolling
        sta screenScrollingLeft
        sta screenScrollingRight
        
; clamp the player x position ------------------------------

        ; can get away with 8 bits b/c the clamp area has <255 max X
        LIBMATH_MAX8BIT_AV playerXLow, PLayerXMinScrollLow
        LIBMATH_MIN8BIT_AV playerXLow, PLayerXMaxScrollLow

; scroll the screen ----------------------------------------

        lda playerFrame
        cmp #1
        beq @jumpDone            ; if zero velocity (pointing up)
        cmp #13
        beq @jumpDone            ; if zero velocity (pointing down)
        bcs gPCXSNegative
        jmp gPCXSPositive

@jumpDone
        jmp gPCXSDone

gPCXSNegative                   ; if negative velocity
        ; scroll the screen right if player X = min scrollX
        ; can get away with 8 bits b/c the clamp area has <255 max X
        ;lda playerXHigh
        ;cmp #PlayerXMinScrollHigh
        ;bne gPCXSDone
        lda playerXLow
        cmp #PlayerXMinScrollLow
        bne gPCXSDone
        lda #1
        sta screenScrolling
        LIBSCREEN_FOREGROUNDSCROLLRIGHTTWO
        LIBSCREEN_BACKGROUNDSCROLLRIGHTONE

        lda #1
        sta ScreenScrollingRight
        jmp gPCXSDone

gPCXSPositive                    ; if positive velocity
        ; scroll the screen left if player X = max scrollX
        ; can get away with 8 bits b/c the clamp area has <255 max X
        ;lda playerXHigh
        ;cmp #PLayerXMaxScrollHigh
        ;bne gPCXSDone
        lda playerXLow
        cmp #PLayerXMaxScrollLow
        bcc gPCXSDone
        lda #1
        sta screenScrolling
        LIBSCREEN_FOREGROUNDSCROLLLEFTTWO
        LIBSCREEN_BACKGROUNDSCROLLLEFTONE

        lda #1
        sta ScreenScrollingLeft
        
gPCXSDone

        rts
