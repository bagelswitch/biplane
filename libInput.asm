;===============================================================================
; Constants

AKeyRow                 = %11111101
AKeyBit                 = %00000100

DKeyRow                 = %11111011
DKeyBit                 = %00000100

SKeyRow                 = %11111101
SKeyBit                 = %00100000

SpcKeyRow               = %01111111
SpcKeyBit               = %00010000

 ; use joystick 2, change to CIAPRB for joystick 1
JoystickRegister        = CIAPRA

GameportUpMask          = %00000001
GameportDownMask        = %00000010
GameportLeftMask        = %00000100
GameportRightMask       = %00001000
GameportFireMask        = %00010000

FireDelayMax            = 10

;===============================================================================
; Variables

gameportLastFrame       byte 0
gameportThisFrame       byte 0
gameportDiff            byte 0
fireDelay               byte 0
fireBlip                byte 1 ; reversed logic to match other input

;===============================================================================
; Macros/Subroutines

defm    LIBINPUT_GETKEYPRESSED 
                        ; /1 = row (see https://dustlayer.com/c64-coding-tutorials/2013/5/24/episode-3-5-taking-command-of-the-ship-controls)
                        ; /2 = bit/column

        lda #%11111111  ; CIA#1 Port A needs to be set to output 
        sta $dc02             

        lda #%00000000  ; CIA#1 Port B needs to be set to input
        sta $dc03             
    
        lda #/1         ; select row 
        sta CIAPRA      ; by storing into $dc00
        lda CIAPRB      ; load current column information
        ldx #0          ; CIA#1 Port A back to input
        stx $dc02       ; for joystick
        and #/2         ; isolate key Bit

        endm            ; test with beq on return

;===============================================================================

defm    LIBINPUT_GETHELD ; (buttonMask)

        lda gameportThisFrame
        and #/1
        endm ; test with bne on return

;===============================================================================

defm    LIBINPUT_GETFIREPRESSED
     
        lda #1
        sta fireBlip ; clear Fire flag

        ; is space held?
        lda #%11111111  ; CIA#1 Port A needs to be set to output 
        sta $dc02             

        lda #%00000000  ; CIA#1 Port B needs to be set to input
        sta $dc03             
    
        lda #SpcKeyRow  ; select eigth row
        sta CIAPRA      ; by storing $0b into $dc00
        lda CIAPRB      ; load current column information
        ldx #0
        stx $dc02
        and #SpcKeyBit  ; isolate 'Space' key Bit
        beq @held

        ; is fire held?
        lda gameportThisFrame
        and #GameportFireMask
        bne @notheld

@held
        ; is this 1st frame?
        lda gameportDiff
        and #GameportFireMask
        
        beq @notfirst
        lda #0
        sta fireBlip ; Fire

        ; reset delay
        lda #FireDelayMax
        sta fireDelay        
@notfirst

        ; is the delay zero?
        lda fireDelay
        bne @notheld
        lda #0
        sta fireBlip ; Fire
        ; reset delay
        lda #FireDelayMax
        sta fireDelay   
        
@notheld 
        lda fireBlip
        endm ; test with bne on return

;===============================================================================

libInputUpdate

        lda JoystickRegister
        sta GameportThisFrame

        eor GameportLastFrame
        sta GameportDiff

        
        lda FireDelay
        beq lIUDelayZero
        dec FireDelay
lIUDelayZero

        lda GameportThisFrame
        sta GameportLastFrame

        rts
