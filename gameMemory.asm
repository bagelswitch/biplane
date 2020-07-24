;===============================================================================
; $00-$FF  PAGE ZERO (256 bytes)
 
; $00-$01   Reserved for IO
ZeroPageTemp    = $02
; $03-$8F   Reserved for BASIC
ZeroPageTemp2   = $03

baronDelayCounter  = $04
playerDelayCounter = $05
playerFireCounter  = $0D
bombDelayCounter   = $09
baronIsFiring      = $06

screenColumn       = $07
backgroundColumn   = $08

screenOneActive    = $0A
screenTwoActive    = $0B

backgroundWriteColumn = $0C

;===============================================================================
; use zero page for player variables to improve speed

playerActive = $5D
playerFrame = $5E
playerSpriteFrame = $5F
playerSprite = $60
playerXHigh = $61
playerXLow = $62
playerY = $63
playerXChar = $64
playerXOffset = $65
playerYChar = $66
playerYOffset = $67
playerHorizontalSpeed = $68
playerVerticalSpeed = $69
playerHorizontalBombSpeed = $6A
playerVerticalBombSpeed = $6B
playerHorizontalBulletSpeed = $6C
playerVerticalBulletSpeed = $6D


; using $73-$8A CHRGET as BASIC not used for our game
ZeroPageParam1  = $73
ZeroPageParam2  = $74
ZeroPageParam3  = $75
ZeroPageParam4  = $76
ZeroPageParam5  = $77
ZeroPageParam6  = $78
ZeroPageParam7  = $79
ZeroPageParam8  = $7A
ZeroPageParam9  = $7B

ScreenScrollingLeft  = $7C
ScreenScrollingRight = $7D

ZeroPageLow3    = $8B
ZeroPageHigh3   = $8C

ScreenScrolling = $8E
; $90-$FA   Reserved for Kernal

ZeroPageLow     = $FB
ZeroPageHigh    = $FC
ZeroPageLow2    = $FD
ZeroPageHigh2   = $FE
; $FF       Reserved for Kernal

;===============================================================================
; $0100-$01FF  STACK (256 bytes)


;===============================================================================
; $0200-$9FFF  RAM (40K)

SCREENRAMONE    = $0400
SPRITEONE0      = $07F8

; $0801
; Game code is placed here by using the *=$0801 directive 
; in gameMain.asm 

SCREENRAMTWO    = $2000
SPRITETWO0      = $23F8

; 152 decimal * 64(sprite size) = 9728(hex $2600)
PLAYERRAM       = 152

* = $2600
        incbin sopwith.bin

; 160 decimal * 64(sprite size) = 10240(hex $2800)
BARONRAM        = 160

* = $2800
        incbin baron.bin

; 168 decimal * 64(sprite size) = 10752(hex $2A00)
BOMBRAM        = 168

* = $2A00
        incbin bomb.bin

; 176 decimal * 64(sprite size) = 11264(hex $2C00)
EXPLOSION1RAM   = 176

* = $2C00
        incbin explosion1.bin

* = $3800
CHARRAM
incbin background.bin

CHARRAMTEMP = $47B0

; $5000 background data
* = $5000
MAPRAM
incbin farmland.out

; $8000
; Game code is placed here by using the *=$8000 directive 
; in gameMain.asm 


;===============================================================================
; $A000-$BFFF  BASIC ROM (8K)

;* = $9FFE
;incbin finalcountdown.dat

* = MusicBaseAddress ; $B000
incbin gbluesn.dat


;===============================================================================
; $C000-$CFFF  RAM (4K)


;===============================================================================
; $D000-$DFFF  IO (4K)

; These are some of the C64 registers that are mapped into
; IO memory space
; Names taken from 'Mapping the Commodore 64' book

SP0X            = $D000
SP0Y            = $D001
MSIGX           = $D010
SCROLY          = $D011
RASTER          = $D012
SPENA           = $D015
SCROLX          = $D016
VMCSB           = $D018
SPBGPR          = $D01B
SPMC            = $D01C
SPSPCL          = $D01E
SPBPCL          = $D01F
EXTCOL          = $D020
BGCOL0          = $D021
BGCOL1          = $D022
BGCOL2          = $D023
BGCOL3          = $D024
SPMC0           = $D025
SPMC1           = $D026
SP0COL          = $D027
FRELO1          = $D400 ;(54272)
FREHI1          = $D401 ;(54273)
PWLO1           = $D402 ;(54274)
PWHI1           = $D403 ;(54275)
VCREG1          = $D404 ;(54276)
ATDCY1          = $D405 ;(54277)
SUREL1          = $D406 ;(54278)
FRELO2          = $D407 ;(54279)
FREHI2          = $D408 ;(54280)
PWLO2           = $D409 ;(54281)
PWHI2           = $D40A ;(54282)
VCREG2          = $D40B ;(54283)
ATDCY2          = $D40C ;(54284)
SUREL2          = $D40D ;(54285)
FRELO3          = $D40E ;(54286)
FREHI3          = $D40F ;(54287)
PWLO3           = $D410 ;(54288)
PWHI3           = $D411 ;(54289)
VCREG3          = $D412 ;(54290)
ATDCY3          = $D413 ;(54291)
SUREL3          = $D414 ;(54292)
SIGVOL          = $D418 ;(54296)      
COLORRAM        = $D800
CIAPRA          = $DC00
CIAPRB          = $DC01

;===============================================================================
; $E000-$FFFF  KERNAL ROM (8K) 


;===============================================================================
