; Sprite top left corner to char coordinates:
; int((spr_x-24)/8), int((spr_y-50)/8) 
;===============================================================================
; Constants

BulletsMax = 6
Bullet1stCharacter = 123
Temp1stCharacter = 245
BulletMaxLife = 50

;===============================================================================
; Variables

bulletsXHighCurrent     byte 0
bulletsXLowCurrent      byte 0
bulletsYCurrent         byte 0
bulletsXCharCurrent     byte 0
;bulletsXOffsetCurrent   byte 0
bulletsYCharCurrent     byte 0
;bulletsColorCurrent     byte 0
bulletsVelXCurrent      byte 0
;bulletsVelYCurrent      byte 0
bulletsOldCharCurrent   byte 0
;bulletsOldColorCurrent  byte 0
;bulletsOldToggleCurrent byte 0
;bulletIndexCurrent      byte 0
bulletDestCharCurrent   byte 0
bulletSourceCharCurrent byte 0
;bulletLifetimeCurrent   byte 0

bulletsSpriteFrame dcb BulletsMax, 0
bulletsActive    dcb BulletsMax, 0
bulletsSource    dcb BulletsMax, 255
bulletsXChar     dcb BulletsMax, 0
bulletsYChar     dcb BulletsMax, 0
bulletsXHigh     dcb BulletsMax, 0
bulletsXLow      dcb BulletsMax, 0
bulletsY         dcb BulletsMax, 0
bulletsXOffset   dcb BulletsMax, 0
;bulletsColor     dcb BulletsMax, 0
bulletsVelX      dcb BulletsMax, 0
bulletsVelY      dcb BulletsMax, 0
bulletsOldChar   dcb BulletsMax, 0
;bulletsOldColor  dcb BulletsMax, 0
bulletsOldToggle dcb BulletsMax, 0
bulletsLifetime  dcb BulletsMax, 0
bulletsXFlag     byte 0
bulletsYFlag     byte 0

bulletsXCharCol    byte 0
bulletsYCharCol    byte 0
bulletsSourceCol   byte 255
bulletsSourceCheck byte 0

;===============================================================================
; Macros/Subroutines

defm    GAMEBULLETS_FIRE_AAAVAAAA  ; /1 = X position high byte(Address)
                                  ; /2 = X position low byte (Address)
                                  ; /3 = Y position          (Address)
                                  ; /4 = Color               (Value)
                                  ; /5 = X velocity
                                  ; /6 = Y velocity
                                  ; /7 = Source Sprite       (Address)
                                  ; /8 = Sprite Frame        (Address)
        ldx #0
@loop
        lda bulletsActive,X
        bne @skip

        ; save the current bullet in the list
        lda #1
        sta bulletsActive,X
        lda /1
        sta bulletsXHigh,X
        lda /2
        sta bulletsXLow,X
        lda /3
        sta bulletsY,X
        ;lda #/4
        ;sta bulletsColor,X
        lda /5
        sta bulletsVelX,X
        lda /6
        sta bulletsVelY,X
        lda /7
        sta bulletsSource,X
        lda /8
        sta bulletsSpriteFrame,X

        lda #0
        ;sta bulletsOldChar,X
        ;sta bulletsOldColor,X
        sta bulletsLifetime,X

        jsr gameBulletsFireGet
        jsr gameBulletsBackup

        ; found a slot, quit the loop
        jmp @found
@skip
        ; loop for each bullet
        inx
        cpx #BulletsMax
        bne @loop
@found

        stx screenDebugZero

        endm

;===============================================================================

gameBulletsFireGet
        ;lda bulletsLifetime,X
        ;sta bulletLifetimeCurrent
        lda bulletsXHigh,X
        sta bulletsXHighCurrent
        lda bulletsXLow,X
        sta bulletsXLowCurrent
        lda bulletsY,X
        sta bulletsYCurrent
        lda bulletsOldChar,X
        sta bulletsOldCharCurrent

        LIBSCREEN_PIXELTOCHAR_AAVAVAA bulletsXHighCurrent, bulletsXLowCurrent, 16, bulletsYCurrent, 40, bulletsXCharCurrent, bulletsYCharCurrent

        lda bulletsXCharCurrent
        sta bulletsXChar,X
        lda bulletsYCharCurrent
        sta bulletsYChar,X

        rts

gameBulletsGet
        ;lda bulletsLifetime,X
        ;sta bulletLifetimeCurrent
        lda bulletsXHigh,X
        sta bulletsXHighCurrent
        lda bulletsXLow,X
        sta bulletsXLowCurrent
        lda bulletsY,X
        sta bulletsYCurrent
        ;lda bulletsColor,X
        ;sta bulletsColorCurrent
        lda bulletsVelX,X
        sta bulletsVelXCurrent
        ;lda bulletsVelY,X
        ;sta bulletsVelYCurrent
        lda bulletsOldChar,X
        sta bulletsOldCharCurrent
        ;lda bulletsOldColor,X
        ;sta bulletsOldColorCurrent
        ;lda bulletsOldToggle,X
        ;sta bulletsOldToggleCurrent
        ;stx bulletIndexCurrent

        lda bulletsXChar,X
        sta bulletsXCharCurrent
        lda bulletsYChar,X
        sta bulletsYCharCurrent

        rts

;===============================================================================

gameBulletsBackup

        lda screenTwoActive
        sta bulletsOldToggle,X
        beq @setSecondary
        LIBSCREEN_TWO_SETCHARPOSITION_AA bulletsXCharCurrent, bulletsYCharCurrent
        jmp @setDone
@setSecondary
        LIBSCREEN_SETCHARPOSITION_AA bulletsXCharCurrent, bulletsYCharCurrent
@setDone

        lda (ZeroPageLow),Y
        sta bulletsOldChar,X
        sta bulletsOldCharCurrent

        LIBSCREEN_SETCHAR_A bulletDestCharCurrent ;bulletsXOffsetCurrent

        rts

;===============================================================================

gameBulletsRestore

        lda screenTwoActive
        cmp bulletsOldToggle,X
        bne @skipRestore

        lda screenTwoActive
        beq @resetSecondary

        LIBSCREEN_TWO_SETCHARPOSITION_AA bulletsXCharCurrent, bulletsYCharCurrent
        jmp @resetDone
@resetSecondary
        LIBSCREEN_SETCHARPOSITION_AA bulletsXCharCurrent, bulletsYCharCurrent
@resetDone
        LIBSCREEN_SETCHAR_A bulletsOldCharCurrent
        ;LIBSCREEN_SETCOLORPOSITION_AA bulletsXCharCurrent, bulletsYCharCurrent
        ;LIBSCREEN_SETCHAR_A bulletsOldColorCurrent
@skipRestore

        rts

;===============================================================================

gameBulletsUpdate

        ldx #0
buloop
        lda bulletsActive,X
        bne buok
        jmp skipBulletUpdate
buok
        ; get the current bullet from the list
        jsr gameBulletsGet
        jsr gameBulletsRestore

        ; apply vertical velocity
        clc
        lda bulletsYCurrent
        adc bulletsVelY,X
        sta bulletsYCurrent
        sta bulletsY,X
        
        ; apply horizontal velocity
        lda bulletsSpriteFrame,X
        cmp #13
        bcs @leftMove
@rightMove
        LIBMATH_ADD16BIT_AAVAAA bulletsXHighCurrent, BulletsXLowCurrent, 0, bulletsVelXCurrent, bulletsXHighCurrent, BulletsXLowCurrent
        jmp @doneMove
@leftMove
        LIBMATH_SUB16BIT_AAVAAA bulletsXHighCurrent, BulletsXLowCurrent, 0, bulletsVelXCurrent, bulletsXHighCurrent, BulletsXLowCurrent
@doneMove
        lda bulletsXHighCurrent
        sta bulletsXHigh,X
        lda bulletsXLowCurrent
        sta bulletsXLow,X

        LIBSCREEN_PIXELTOCHAR_AAVAVAA bulletsXHighCurrent, bulletsXLowCurrent, 16, bulletsYCurrent, 40, bulletsXCharCurrent, bulletsYCharCurrent

        lda bulletsYCharCurrent
        cmp #1
        bcc @deadBullet
        cmp #22
        bcs @deadBullet

        lda bulletsXCharCurrent
        cmp #1
        bcc @deadBullet
        cmp #39
        bcs @deadBullet

        lda bulletsLifetime,X
        cmp #BulletMaxLife
        beq @deadBullet
        inc bulletsLifetime,X

        jmp @dirdone

@deadBullet
        lda #0
        sta bulletsActive,X
        lda #255
        sta bulletsSource,X
        jmp skipBulletUpdate     
   
@dirdone
        ; set the bullet color
        ;LIBSCREEN_SETCOLORPOSITION_AA bulletsXCharCurrent, bulletsYCharCurrent
        ;lda (ZeroPageLow),Y
        ;sta bulletsOldColor,X
        ;LIBSCREEN_SETCHAR_A bulletsColorCurrent
        
        ; set the bullet character
        clc
        txa
        adc #Temp1stCharacter
        sta bulletDestCharCurrent

        jsr gameBulletsBackup

        lda bulletsYCharCurrent
        sta bulletsYChar,X

        cmp #12
        bcc @scrollBackground
        lda screenScrollXValue
        jmp @scrollScreen
@scrollBackground
        lda backgroundScrollXValue
@scrollScreen
        lsr
        adc #Bullet1stCharacter
        sta bulletSourceCharCurrent

        GAMEBULLETS_BLEND_AAA bulletsOldCharCurrent, bulletSourceCharCurrent, bulletDestCharCurrent

        lda bulletsXCharCurrent
        sta bulletsXChar,X

skipBulletUpdate

        inx
        cpx #BulletsMax
        beq @finished
        jmp buloop
@finished
        
        rts

;===============================================================================

defm GAMEBULLETS_BLEND_AAA ; /1 = Source char index (Address)
                           ; /2 = Blend char index  (Address)
                           ; /3 = Dest char index   (Address)

        inc EXTCOL

        lda /1
        sta ZeroPageParam1

        lda /2
        sta ZeroPageParam2

        lda /3
        sta ZeroPageParam3

        stx ZeroPageParam4

        jsr gameBulletsBlend

        ldx ZeroPageParam4

        dec EXTCOL

        endm
        

gameBulletsBlend

        ; load base char
        ldx ZeroPageParam1
        lda CharRAMLow,X ; load low address byte
        sta ZeroPageLow
        ;sta screenDebugZero
        lda CharRAMHigh,X ; load high address byte
        sta ZeroPageHigh
        ;sta screenDebugOne

        ; load additional char
        ldx ZeroPageParam2
        lda CharRAMLow,X ; load low address byte
        sta ZeroPageLow2
        lda CharRAMHigh,X ; load high address byte
        sta ZeroPageHigh2

        ; target character
        ldx ZeroPageParam3
        lda CharRAMLow,X ; load low address byte
        sta ZeroPageLow3
        ;sta screenDebugZero
        lda CharRAMHigh,X ; load high address byte
        sta ZeroPageHigh3
        ;sta screenDebugOne

        ; bullets use only the two middle rows of a char, so no need to blend the other bytes

        ldy #0
        lda (ZeroPageLow),Y
        ;ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #1
        lda (ZeroPageLow),Y
        ;ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #2
        lda (ZeroPageLow),Y
        ;ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #3
        lda (ZeroPageLow),Y
        ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #4
        lda (ZeroPageLow),Y
        ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #5
        lda (ZeroPageLow),Y
        ;ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #6
        lda (ZeroPageLow),Y
        ;ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        ldy #7
        lda (ZeroPageLow),Y
        ;ora (ZeroPageLow2),Y
        sta (ZeroPageLow3),Y

        rts

;===============================================================================

defm    GAMEBULLETS_COLLIDED_AAAV    ; /1 = XChar                (Address)
                                    ; /2 = YChar                (Address)
                                    ; /3 = Check sprite         (Address)

        lda /1
        sta bulletsXCharCol
        lda /2
        sta bulletsYCharCol
        lda /3
        sta bulletsSourceCol
        jsr gameBullets_Collided

        endm

gameBullets_Collided

        ldx #0
@loop
        ; skip this bullet if not active
        lda bulletsActive,X
        cmp #0
        beq @skip

        ; skip this bullet if from current sprite
        lda bulletsSource,X
        cmp bulletsSourceCol
        beq @skip

        lda #0
        sta bulletsYFlag

        ; skip if currentbullet YChar != YChar
        ldy bulletsYChar,X
        cpy bulletsYCharCol
        bne @yminus1
        lda #1
        sta bulletsYFlag
        jmp @doneYCheck

@yminus1
        ; skip if currentbullet YChar-1 != YChar
        ;dey
        ;cpy bulletsYCharCol
        ;bne @yplus1
        ;lda #1
        ;sta bulletsYFlag
        ;jmp @doneYCheck
@yplus1
        ; skip if currentbullet YChar+1 != YChar
        ;iny
        ;iny
        ;cpy bulletsYCharCol
        ;bne @doneYCheck
        ;lda #1
        ;sta bulletsYFlag

@doneYCheck
        lda bulletsYFlag
        beq @skip

        lda #0
        sta bulletsXFlag

        ; skip if currentbullet XChar != XChar
        ldy bulletsXChar,X
        cpy bulletsXCharCol
        bne @xminus1
        lda #1
        sta bulletsXFlag
        jmp @doneXCheck

@xminus1
        ; skip if currentbullet XChar-1 != XChar
        ;dey
        ;cpy bulletsXCharCol
        ;bne @xplus1
        ;lda #1
        ;sta bulletsXFlag
        ;jmp @doneXCheck
@xplus1
        ; skip if currentbullet XChar+1 != XChar
        ;iny
        ;iny
        ;cpy bulletsXCharCol
        ;bne @doneXCheck
        ;lda #1
        ;sta bulletsXFlag

@doneXCheck
        lda bulletsXFlag
        beq @skip

        ; collided
        lda #0
        sta bulletsActive,X ; disable bullet

        jsr gameBulletsGet

        ; why is this here?
        jsr gameBulletsRestore

        lda #1 ; set as collided
        jmp @collided
@skip
        ; loop for each bullet
        inx
        cpx #BulletsMax
        bne @loop

        ; set as not collided
        lda #0

@collided

        rts

