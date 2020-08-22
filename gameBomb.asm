;==============================================================================
; Constants

BombMaxFrame           = 24
BombXMinHigh           = 0     ; 0*256 + 0 = 0  minX
BombXMinLow            = 16
BombXMaxHigh           = 1     ; 1*256 + 255 = 511 maxX
BombXMaxLow            = 72
BombYMin               = 30
BombYMax               = 216
BombInputDelay         = 10

;===============================================================================
; Variables

bombActive           byte 0
bombFrame            byte 1
bombSprite           byte 4
debrisSprite         byte 5
debrisColor          byte 1
debrisSpriteFrame    byte 0
bombSpriteFrame      byte 0
bombXHigh            byte 0
bombXLow             byte 0
debrisXHigh          byte 0
debrisXLow           byte 0
bombY                byte 0
debrisY              byte 0
bombXChar            byte 0
bombXOffset          byte 0
bombYChar            byte 0
bombYOffset          byte 0
bombHorizontalSpeed  byte 0
bombVerticalSpeed    byte 0
bombExploding        byte 0
bombImpactChar       byte 0
bombTerrainImpact    byte 0

                        ; down-sampled animation frames to reduce sprite size
bombSpriteFrameConv   byte    0,  0,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4
                      byte    4,  4,  5,  5,  5,  6,  6,  6,  7,  7,  7,  0

;===============================================================================
; Macros/Subroutines

defm    GAMEBOMB_DROPBOMB_AAAAVV
                        ; /1 = initial frame/orientation
                        ; /2 = initial Y position
                        ; /3 = initial X position high byte
                        ; /4 = initial X position low byte
                        ; /5 = initial vertical speed
                        ; /6 = initial horizontal speed

        lda bombActive ; only one bomb at a time
        bne @noDrop

        lda #0
        sta bombExploding

        lda /1
        sta bombFrame

        lda /2
        sta bombY

        lda /3
        sta bombXHigh

        lda /4
        sta bombXLow

        lda #/5
        sta bombVerticalSpeed

        lda #/6
        sta bombHorizontalSpeed

        jsr gameBombInit

@noDrop

        endm

defm    GAMEBOMB_DROPBOMB_AAAAAA
                        ; /1 = initial frame/orientation
                        ; /2 = initial Y position
                        ; /3 = initial X position high byte
                        ; /4 = initial X position low byte
                        ; /5 = initial vertical speed
                        ; /6 = initial horizontal speed

        lda bombActive ; only one bomb at a time
        bne @noDrop

        lda #0
        sta bombExploding

        lda /1
        sta bombFrame

        lda /2
        sta bombY

        lda /3
        sta bombXHigh

        lda /4
        sta bombXLow

        lda /5
        sta bombVerticalSpeed

        lda /6
        sta bombHorizontalSpeed

        jsr gameBombInit

@noDrop

        endm

;==============================================================================

gameBombDebris
        
        LIBSPRITE_ENABLE_AV             debrisSprite, True
        LIBSPRITE_SETFRAME_AAV          debrisSprite, debrisSpriteFrame, DEBRISRAM
        LIBSPRITE_SETPRIORITY_AV        debrisSprite, False
        LIBSPRITE_SETSIZEX_AV           debrisSprite, True
        LIBSPRITE_SETSIZEY_AV           debrisSprite, True
        LIBSPRITE_SETPOSITION_AAAA      debrisSprite, bombXHigh, bombXLow, bombY
        LIBSPRITE_MULTICOLORENABLE_AV   debrisSprite, False
        LIBSPRITE_SETCOLOR_AV           debrisSprite, White
        LIBSPRITE_PLAYANIM_AVVVV        debrisSprite, 0, 11, 3, False

        rts

gameBombPositionDebris

        lda bombExploding
        cmp #0
        beq debrisNoMove

        LIBMATH_SUB8BIT_AVA bombY, #10, debrisY

        LIBMATH_SUB16BIT_AAVAAA bombXHigh, bombXLow, 0, #12, debrisXHigh, debrisXLow

debrisNoMove
        jsr gameDebrisScrollAdjust

        ; center the debris animation on the collision point
        LIBSPRITE_SETPOSITION_AAAA debrisSprite, debrisXHigh, debrisXLow, debrisY

        rts

;==============================================================================

gameBombInit
        
        lda #True
        sta bombActive

        LIBSPRITE_STOPANIM_A bombSprite

        LIBSPRITE_ENABLE_AV             bombSprite, True
        ldx bombFrame
        lda bombSpriteFrameConv,x
        sta bombSpriteFrame
        LIBSPRITE_SETFRAME_AAV          bombSprite, bombSpriteFrame, BOMBRAM
        LIBSPRITE_SETCOLOR_AV           bombSprite, Black
        LIBSPRITE_MULTICOLORENABLE_AV   bombSprite, True

        LIBSOUND_BOMB_START_AA bombY, bombY

        lda #0
        sta bombDelayCounter
        sta debrisColor

        rts

;==============================================================================

gameBombReset

        jsr gameBombInit

        inc EXTCOL
        jsr gameBombUpdatePosition
        dec EXTCOL
        
        rts

;===============================================================================

gameBombUpdate      

        lda bombActive
        beq @skipUpdate
        jsr gameBombUpdatePosition
        inc EXTCOL
        jsr gameBombUpdateCollisions
        dec EXTCOL

        LIBSOUND_BOMB_UPDATE_AA bombY, bombY

        jmp @updateDone

@skipUpdate
        ; pin the sprite's location relative to background
        jsr gameBombScrollAdjust

        ; set the sprite position
        jsr gameBombSetSpritePosition

        ;
        inc debrisColor
        LIBSPRITE_SETCOLOR_AA debrisSprite, debrisColor

@updateDone

        rts

;==============================================================================

gameBombDestroyBackground

        lda #0
        sta bombTerrainImpact

        LIBSCREEN_SETCHARPOSITION_AA bombXChar, bombYChar
        LIBSCREEN_SETCHAR_V #12

        LIBSCREEN_TWO_SETCHARPOSITION_AA bombXChar, bombYChar
        LIBSCREEN_SETCHAR_V #12

        GAMEMAP_SETCHARPOSITION_AAA screenColumn, bombYChar, bombXChar

@centerImpact
        GAMEMAP_GETCHAR bombImpactChar
        cmp #12
        ; empty space
        beq @leftImpact
        cmp #98
        ; regular terrain
        bcc @centerImpactLandscape
        cmp #101
        ; building target
        bcs @centerImpactTarget
        ;debris
        jsr gameBombDeactivate
        jmp @leftImpact

@centerImpactTarget
        GAMEMAP_SETCHAR_V #12

        ; raise impact point to top of building
        dec bombYChar
        jsr gameBombDestroyBackground
        inc bombYChar
        GAMEMAP_SETCHARPOSITION_AAA screenColumn, bombYChar, bombXChar

        ; factory destroyed, summon the baron
        lda baronActive
        bne @leftImpact
        jsr gameBaronReset

        jmp @leftImpact

@centerImpactLandscape
        GAMEMAP_SETCHAR_V #99
        lda #1
        sta bombTerrainImpact

@leftImpact
        dey
        GAMEMAP_GETCHAR bombImpactChar
        cmp #12
        beq @rightImpact
        cmp #98
        bcc @leftImpactLandscape
        cmp #101
        bcs @leftImpactTarget
        jmp @rightImpact

@leftImpactTarget
        GAMEMAP_SETCHAR_V #12
        jmp @rightImpact

@leftImpactLandscape
        GAMEMAP_SETCHAR_V #98
        lda #1
        sta bombTerrainImpact
      
@rightImpact
        iny
        iny
        GAMEMAP_GETCHAR bombImpactChar
        cmp #12
        beq @doneImpact
        cmp #98
        bcc @rightImpactLandscape
        cmp #101
        bcs @rightImpactTarget
        jmp @doneImpact

@rightImpactTarget
        GAMEMAP_SETCHAR_V #12
        jmp @doneImpact

@rightImpactLandscape
        GAMEMAP_SETCHAR_V #100
        lda #1
        sta bombTerrainImpact

@doneImpact

        lda bombTerrainImpact
        cmp #0
        beq @doneTerrainImpact

        jsr gameBombDebris
        jsr gameBombDeactivate

        dec bombYChar
        GAMEMAP_SETCHARPOSITION_AAA screenColumn, bombYChar, bombXChar
        GAMEMAP_SETCHAR_V #12
        dey
        GAMEMAP_SETCHAR_V #12
        iny
        iny
        GAMEMAP_SETCHAR_V #12

@doneTerrainImpact

        rts


;==============================================================================

gameBombUpdateCollisions

        ; if we have collided with someone else's bullet, always collision
        ;GAMEBULLETS_COLLIDED_AAAV bombXChar, bombYChar, bombSprite
        ;cmp #1
        ;beq @gBUCCollision

        ; if we haven't hit someone else's bullet and we're in the background layer, no collision
        lda bombYChar
        cmp #13
        bcc @gBUCNoCollision

        ; if we're above the vertical display area, no collision
        ;lda bombY
        ;cmp #40
        ;bcc @gBUCNoCollision

        ; if we have hit a non-terrain background character, no collision
        LIBSCREEN_BACKGROUND_CHECK_AA bombXChar, bombYChar
        cmp #0
        beq @gBUCNoCollision

@gBUCCollision

        lda #1
        sta bombExploding

        ; run explosion animation
        LIBSPRITE_SETFRAME_AVV          bombSprite, #0, EXPLOSION1RAM
        LIBSPRITE_SETCOLOR_AV           bombSprite, Yellow
        LIBSPRITE_PLAYANIM_AVVVV        bombSprite, 0, 11, 3, False

        jsr gameBombDestroyBackground
                                
@gBUCNoCollision

        rts

gameBombDeactivate

        lda #False
        sta bombActive

        lda #0
        sta bombVerticalSpeed

        lda #0
        sta bombHorizontalSpeed

        ; play explosion sound
        LIBSOUND_BOMB_STOP
        LIBSOUND_PLAY_VAA 1, soundExplosionHigh, soundExplosionLow

        rts

;===============================================================================

defm INCREMENT_BOMB_DELAY_A ; /1 = Current delay counter
        
        ldx /1
        inx
        cpx #bombInputDelay
        bcc @endDelay
        lda #0
        sta /1
        jmp @finished
@endDelay
        stx /1
        jmp gBoEndmove
@finished

        endm

;===============================================================================

gameBombAIMove

        lda bombFrame
        cmp #13
        beq @doneMoving
        bcs @movingLeft 

@movingRight ; bomb is flying to the right
        inc bombFrame
        jmp @doneMoving

@movingLeft ; bomb is flying to the left
        dec bombFrame
        jmp @doneMoving

@doneMoving
        lda bombFrame
        cmp #0
        bpl @doneLeftReset
        lda #23
        sta bombFrame

@doneLeftReset
        cmp #24
        bmi @doneRightReset
        lda #0
        sta bombFrame

@doneRightReset
        ;lda bombHorizontalSpeed
        ;cmp #1
        ;bmi @dragDone
        ;dec bombHorizontalSpeed

@dragDone
        lda bombVerticalSpeed
        cmp #4
        bpl @gravityDone
        inc bombVerticalSpeed

@gravityDone

        rts

;===============================================================================

gameBombScrollAdjust

        lda ScreenScrollingLeft
        beq @doneScrollingLeft
        LIBMATH_SUB16BIT_AAVAAA bombXHigh, bombXLow, 0, #2, bombXHigh, bombXLow
        jmp @doneScrollingRight

@doneScrollingLeft
        lda ScreenScrollingRight
        beq @doneScrollingRight
        LIBMATH_ADD16BIT_AAVAAA bombXHigh, bombXLow, 0, #2, bombXHigh, bombXLow

@doneScrollingRight

        rts

;===============================================================================

gameDebrisScrollAdjust

        lda ScreenScrollingLeft
        beq @doneScrollingLeft
        LIBMATH_SUB16BIT_AAVAAA debrisXHigh, debrisXLow, 0, #2, debrisXHigh, debrisXLow
        jmp @doneScrollingRight

@doneScrollingLeft
        lda ScreenScrollingRight
        beq @doneScrollingRight
        LIBMATH_ADD16BIT_AAVAAA debrisXHigh, debrisXLow, 0, #2, debrisXHigh, debrisXLow

@doneScrollingRight

        rts

;===============================================================================

gameBombSetSpritePosition

        lda #BombXMaxHigh
        cmp bombXHigh
        bcs @resetDone
        lda #0
        sta bombXHigh
        sta bombXLow
@resetDone
        ; clamp bomb's x position
        LIBMATH_MAX16BIT_AAVV bombXHigh, bombXLow, BombXMinHigh, BombXMinLow
        LIBMATH_MIN16BIT_AAVV bombXHigh, bombXLow, BombXMaxHigh, BombXMaxLow

        ; clamp bomb's y position
        LIBMATH_MIN8BIT_AV bombY, BombYMax
        LIBMATH_MAX8BIT_AV bombY, BombYMin

        ; set the sprite position
        LIBSPRITE_SETPOSITION_AAAA bombSprite, bombXHigh, bombXLow, bombY

        jsr gameBombPositionDebris

        rts

;===============================================================================

gameBombUpdatePosition

        INCREMENT_BOMB_DELAY_A bombDelayCounter

        jsr gameBombAIMove
        
gBoEndmove
        ldx bombFrame

        ;LIBSPRITE_ENABLE_AV             bombSprite, True
        lda bombSpriteFrameConv,x
        sta bombSpriteFrame
        LIBSPRITE_SETFRAME_AAV          bombSprite, bombSpriteFrame, BOMBRAM

        ; apply horizontal velocity
        cpx #13
        bcs @leftMove
@rightMove
        LIBMATH_ADD16BIT_AAVAAA bombXHigh, bombXLow, 0, bombHorizontalSpeed, bombXHigh, bombXLow
        jmp @doneMove
@leftMove
        LIBMATH_SUB16BIT_AAVAAA bombXHigh, bombXLow, 0, bombHorizontalSpeed, bombXHigh, bombXLow

@doneMove
        jsr gameBombScrollAdjust

        ; apply vertical velocity
        LIBMATH_ADD8BIT_AAA bombY, bombVerticalSpeed, bombY 

        jsr gameBombSetSpritePosition

        ; update the bomb's char positions
        LIBSCREEN_PIXELTOCHAR_AAVAVAAAA bombXHigh, bombXLow, 24, bombY, 40, bombXChar, bombXOffset, bombYChar, bombYOffset

        rts

