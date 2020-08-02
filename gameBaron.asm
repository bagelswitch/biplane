;==============================================================================
; Constants

BaronMaxFrame           = 24
BaronXMinHigh           = 0     ; 0*256 + 0 = 0  minX
BaronXMinLow            = 16
BaronXMaxHigh           = 1     ; 1*256 + 255 = 511 maxX
BaronXMaxLow            = 72
BaronYMin               = 40
BaronYMax               = 216
BaronInputDelay         = 5

;===============================================================================
; Variables

baronActive           byte 1
baronFrame            byte 6
BaronSpriteFrame      byte 0
baronSprite           byte 1
baronXHigh            byte 0
baronXLow             byte 75
baronY                byte 55
baronXChar            byte 0
baronXOffset          byte 0
baronYChar            byte 0
baronYOffset          byte 0
baronHorizontalSpeed  byte 3
baronVerticalSpeed    byte 0
baronHorizontalBulletSpeed byte 1
baronVerticalBulletSpeed   byte 1

                        ; down-sampled animation frames to reduce sprite size
baronSpriteFrameConv   byte    0,  0,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4
                       byte    4,  4,  5,  5,  5,  6,  6,  6,  7,  7,  7,  0

                        ; horizontal velocities by sprite frame
baronXmoveArray        byte    0,  1,  1,  2,  2,  2,  3,  2,  2,  2,  1,  1
                       byte    0,  1,  1,  2,  2,  2,  3,  2,  2,  2,  1,  1

                        ; horizontal velocities by sprite frame
baronXmoveArrayScrollLeft  byte    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                           byte    2,  3,  3,  4,  4,  4,  5,  4,  4,  4,  3,  3

                        ; horizontal velocities by sprite frame
baronXmoveArrayScrollRight  byte    2,  3,  3,  4,  4,  4,  5,  4,  4,  4,  3,  3
                            byte    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                            

                        ; vertical velocities by sprite frame
baronYmoveArray        byte   -3, -2, -2, -2, -1,  -1,  0,  1,  1,  2,  2,  2
                        byte    3,  2,  2,  2,  1,   1,  0, -1, -1, -2, -2, -2


                        ; bullet directions by sprite frame
baronXbulletArray      byte    0,  1,  2,  3,  4,  5,  6,  5,  4,  3,  2,  1
                       byte    0, 1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1

                        ; bullet directions by sprite frame
baronYbulletArray      byte   -6, -5, -4, -3, -2,  0,  0,  0,  2,  3,  4,  5
                       byte    6,  5,  4,  3,  2,  0,  0,  0, -2, -3, -4, -5

;===============================================================================
; Macros/Subroutines

gameBaronInit
        
        lda #True
        sta baronActive

        LIBSPRITE_STOPANIM_A baronSprite

        lda #18
        sta baronFrame

        lda #0
        sta baronVerticalSpeed

        lda #0
        sta baronHorizontalSpeed

        lda #1
        sta baronXHigh
        lda #200
        sta baronXLow
        lda #55
        sta baronY

        LIBSPRITE_ENABLE_AV             baronSprite, True
        ldx baronFrame
        lda baronSpriteFrameConv,x
        sta baronSpriteFrame
        LIBSPRITE_SETFRAME_AAV          baronSprite, baronSpriteFrame, BARONRAM
        LIBSPRITE_SETCOLOR_AV           baronSprite, Red
        LIBSPRITE_MULTICOLORENABLE_AV   baronSprite, True

        lda #0
        sta baronDelayCounter

        rts

;==============================================================================

gameBaronReset

        ;inc screenDebugZero

        jsr gameBaronInit

        inc EXTCOL
        jsr gameBaronUpdatePosition
        dec EXTCOL
        
        rts

;===============================================================================

gameBaronUpdate      

        lda baronActive
        beq @skipUpdate
        inc EXTCOL
        jsr gameBaronUpdatePosition
        inc EXTCOL
        jsr gameBaronUpdateCollisions
        dec EXTCOL
        dec EXTCOL
        jsr gameBaronUpdateFiring
@skipUpdate

        rts

;==============================================================================

gameBaronUpdateFiring

        ; do fire after the ship has been clamped to position
        ; so that the bullet lines up
        lda baronIsFiring
        cmp #1
        bne gBNoFire
        GAMEBULLETS_FIRE_AAAVAAAA baronXHigh, baronXLow, baronY, Black, baronHorizontalBulletSpeed, baronVerticalBulletSpeed, baronSprite, baronFrame
gBNoFire

        rts

;==============================================================================

gameBaronUpdateCollisions

        lda baronActive
        beq @jumpNoCollision

        jmp @continue

@jumpNoCollision
        jmp @gBUCNoCollision

@continue

        ; if we have collided with someone else's bullet, always collision
        GAMEBULLETS_COLLIDED_AAAV baronXChar, baronYChar, baronSprite
        cmp #1
        beq @gBUCCollision

        ; if we haven't hit someone else's bullet and we're in the background layer, no collision
        lda baronYChar
        cmp #13
        bcc @gBUCNoCollision

        ; if we're above the vertical display area, no collision
        lda baronY
        cmp #40
        bcc @gBUCNoCollision

        ; if we have hit a non-terrain background character, no collision
        LIBSCREEN_BACKGROUND_CHECK baronXChar, baronYChar
        cmp #0
        beq @gBUCNoCollision

@gBUCCollision
        lda #False
        sta baronActive

        ; run explosion animation
        LIBSPRITE_SETFRAME_AVV          baronSprite, #0, EXPLOSION1RAM
        LIBSPRITE_SETCOLOR_AV           baronSprite, Yellow
        LIBSPRITE_PLAYANIM_AVVVV        baronSprite, 0, 11, 3, False

        ; play explosion sound
        LIBSOUND_PLAY_VAA 2, soundPickupHigh, soundPickupLow
                                
@gBUCNoCollision

        rts

;===============================================================================

defm INCREMENT_BARON_DELAY_A ; /1 = Current delay counter
        
        ldx /1
        inx
        cpx #baronInputDelay
        bcc @endDelay
        lda #0
        sta /1
        jmp @finished
@endDelay
        stx /1
        jmp gBEndmove
@finished

        endm

;===============================================================================

gameBaronAIMove

        lda playerActive
        bne @playerTargetActive
        inc baronFrame
        jmp @doneMoving
@playerTargetActive
        lda baronFrame
        cmp #13
        bcs @movingLeft 

@movingRight ; baron is flying to the right
        lda baronXChar
        cmp playerXChar
        bcs @playerBehindRight

@playerAheadRight
        lda baronYChar
        cmp playerYChar
        beq @isFiring
        bcc @playerBelowRight
@playerAboveRight ; player is above the baron
        lda baronVerticalSpeed
        cmp #0
        bmi @doneMoving
        dec baronFrame
        jmp @doneMoving
@playerBelowRight ; player is below the baron
        lda baronVerticalSpeed
        cmp #1
        bpl @doneMoving
        inc baronFrame
        jmp @doneMoving

@playerBehindRight
        dec baronFrame
        jmp @doneMoving

@movingLeft ; baron is flying to the left
        lda baronXChar
        cmp playerXChar
        bcc @playerBehindLeft

@playerAheadLeft
        lda baronYChar
        cmp playerYChar
        beq @isFiring
        bcc @playerBelowLeft
@playerAboveLeft ; player is above the baron
        lda baronVerticalSpeed
        cmp #0
        bmi @doneMoving
        inc baronFrame
        jmp @doneMoving
@playerBelowLeft ; player is below the baron
        lda baronVerticalSpeed
        cmp #1
        bpl @doneMoving
        dec baronFrame
        jmp @doneMoving

@playerBehindLeft
        inc baronFrame
        jmp @doneMoving

@isFiring
        lda #1
        sta baronIsFiring

@doneMoving
        lda baronFrame
        cmp #0
        bpl @doneLeftReset
        lda #23
        sta baronFrame
@doneLeftReset
        cmp #24
        bmi @doneRightReset
        lda #0
        sta baronFrame
@doneRightReset

        rts

gameBaronUpdatePosition
        lda #0
        sta baronIsFiring

        INCREMENT_BARON_DELAY_A baronDelayCounter

        jsr gameBaronAIMove
        
gBEndmove
        ldx baronFrame

        lda screenScrollingLeft
        cmp #0
        bne @scrollingLeft
        lda screenScrollingRight
        cmp #0
        bne @scrollingRight
        lda baronXmoveArray,x
        jmp @doneScrolling
@scrollingLeft
        lda baronXmoveArrayScrollLeft,x
        jmp @doneScrolling
@scrollingRight
        lda baronXmoveArrayScrollRight,x
@doneScrolling
        sta baronHorizontalSpeed
        lda baronYmoveArray,x
        sta baronVerticalSpeed
        lda baronXbulletArray,X
        sta baronHorizontalBulletSpeed
        lda baronYbulletArray,X
        sta baronVerticalBulletSpeed

        ;LIBSPRITE_ENABLE_AV             baronSprite, True
        lda baronSpriteFrameConv,x
        sta baronSpriteFrame
        LIBSPRITE_SETFRAME_AAV          baronSprite, baronSpriteFrame, BARONRAM

        ; apply horizontal velocity
        cpx #13
        bcs @leftMove
@rightMove
        LIBMATH_ADD16BIT_AAVAAA baronXHigh, baronXLow, 0, baronHorizontalSpeed, baronXHigh, baronXLow
        jmp @doneMove
@leftMove
        LIBMATH_SUB16BIT_AAVAAA baronXHigh, baronXLow, 0, baronHorizontalSpeed, baronXHigh, baronXLow
@doneMove

        ; apply vertical velocity
        LIBMATH_ADD8BIT_AAA baronY, baronVerticalSpeed, baronY 

        lda #BaronXMaxHigh
        cmp baronXHigh
        bcs @resetDone
        lda #0
        sta baronXHigh
        sta baronXLow
@resetDone
        ; clamp baron's x position
        LIBMATH_MAX16BIT_AAVV baronXHigh, baronXLow, BaronXMinHigh, BaronXMinLow
        LIBMATH_MIN16BIT_AAVV baronXHigh, baronXLow, BaronXMaxHigh, BaronXMaxLow

        ; clamp baron's y position
        LIBMATH_MIN8BIT_AV baronY, BaronYMax
        LIBMATH_MAX8BIT_AV baronY, BaronYMin

        ; set the sprite position
        LIBSPRITE_SETPOSITION_AAAA baronSprite, baronXHigh, baronXLow, baronY

        ; update the baron's char positions
        LIBSCREEN_PIXELTOCHAR_AAVAVAAAA baronXHigh, baronXLow, 16, baronY, 40, baronXChar, baronXOffset, baronYChar, baronYOffset

        rts

