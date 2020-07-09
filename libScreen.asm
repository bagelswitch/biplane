;===============================================================================
; Constants

Black           = 0
White           = 1
Red             = 2
Cyan            = 3 
Purple          = 4
Green           = 5
Blue            = 6
Yellow          = 7
Orange          = 8
Brown           = 9
LightRed        = 10
DarkGray        = 11
MediumGray      = 12
LightGreen      = 13
LightBlue       = 14
LightGray       = 15
SpaceCharacter  = 12
OtherCharacter  = 24
FunnyCharacter  = 39

False           = 0
True            = 1

;===============================================================================
; Variables

Operator Calc

CharRAMLow ; increments are 1 character (8 bytes)
        byte <CHARRAM, <CHARRAM+8, <CHARRAM+16, <CHARRAM+24, <CHARRAM+32, <CHARRAM+40, <CHARRAM+48, <CHARRAM+56, <CHARRAM+64, <CHARRAM+72
        byte <CHARRAM+80, <CHARRAM+88, <CHARRAM+96, <CHARRAM+104, <CHARRAM+112, <CHARRAM+120, <CHARRAM+128, <CHARRAM+136, <CHARRAM+144, <CHARRAM+152
        byte <CHARRAM+160, <CHARRAM+168, <CHARRAM+176, <CHARRAM+184, <CHARRAM+192, <CHARRAM+200, <CHARRAM+208, <CHARRAM+216, <CHARRAM+224, <CHARRAM+232
        byte <CHARRAM+240, <CHARRAM+248, <CHARRAM+256, <CHARRAM+264, <CHARRAM+272, <CHARRAM+280, <CHARRAM+288, <CHARRAM+296, <CHARRAM+304, <CHARRAM+312
        byte <CHARRAM+320, <CHARRAM+328, <CHARRAM+336, <CHARRAM+344, <CHARRAM+352, <CHARRAM+360, <CHARRAM+368, <CHARRAM+376, <CHARRAM+384, <CHARRAM+392
        byte <CHARRAM+400, <CHARRAM+408, <CHARRAM+416, <CHARRAM+424, <CHARRAM+432, <CHARRAM+440, <CHARRAM+448, <CHARRAM+456, <CHARRAM+464, <CHARRAM+472
        byte <CHARRAM+480, <CHARRAM+488, <CHARRAM+496, <CHARRAM+504, <CHARRAM+512, <CHARRAM+520, <CHARRAM+528, <CHARRAM+536, <CHARRAM+544, <CHARRAM+552
        byte <CHARRAM+560, <CHARRAM+568, <CHARRAM+576, <CHARRAM+584, <CHARRAM+592, <CHARRAM+600, <CHARRAM+608, <CHARRAM+616, <CHARRAM+624, <CHARRAM+632
        byte <CHARRAM+640, <CHARRAM+648, <CHARRAM+656, <CHARRAM+664, <CHARRAM+672, <CHARRAM+680, <CHARRAM+688, <CHARRAM+696, <CHARRAM+704, <CHARRAM+712
        byte <CHARRAM+720, <CHARRAM+728, <CHARRAM+736, <CHARRAM+744, <CHARRAM+752, <CHARRAM+760, <CHARRAM+768, <CHARRAM+776, <CHARRAM+784, <CHARRAM+792
        byte <CHARRAM+800, <CHARRAM+808, <CHARRAM+816, <CHARRAM+824, <CHARRAM+832, <CHARRAM+840, <CHARRAM+848, <CHARRAM+856, <CHARRAM+864, <CHARRAM+872
        byte <CHARRAM+880, <CHARRAM+888, <CHARRAM+896, <CHARRAM+904, <CHARRAM+912, <CHARRAM+920, <CHARRAM+928, <CHARRAM+936, <CHARRAM+944, <CHARRAM+952
        byte <CHARRAM+960, <CHARRAM+968, <CHARRAM+976, <CHARRAM+984, <CHARRAM+992, <CHARRAM+1000, <CHARRAM+1008, <CHARRAM+1016, <CHARRAM+1024, <CHARRAM+1032
        byte <CHARRAM+1040, <CHARRAM+1048, <CHARRAM+1056, <CHARRAM+1064, <CHARRAM+1072, <CHARRAM+1080, <CHARRAM+1088, <CHARRAM+1096, <CHARRAM+1104, <CHARRAM+1112
        byte <CHARRAM+1120, <CHARRAM+1128, <CHARRAM+1136, <CHARRAM+1144, <CHARRAM+1152, <CHARRAM+1160, <CHARRAM+1168, <CHARRAM+1176, <CHARRAM+1184, <CHARRAM+1192
        byte <CHARRAM+1200, <CHARRAM+1208, <CHARRAM+1216, <CHARRAM+1224, <CHARRAM+1232, <CHARRAM+1240, <CHARRAM+1248, <CHARRAM+1256, <CHARRAM+1264, <CHARRAM+1272
        byte <CHARRAM+1280, <CHARRAM+1288, <CHARRAM+1296, <CHARRAM+1304, <CHARRAM+1312, <CHARRAM+1320, <CHARRAM+1328, <CHARRAM+1336, <CHARRAM+1344, <CHARRAM+1352
        byte <CHARRAM+1360, <CHARRAM+1368, <CHARRAM+1376, <CHARRAM+1384, <CHARRAM+1392, <CHARRAM+1400, <CHARRAM+1408, <CHARRAM+1416, <CHARRAM+1424, <CHARRAM+1432
        byte <CHARRAM+1440, <CHARRAM+1448, <CHARRAM+1456, <CHARRAM+1464, <CHARRAM+1472, <CHARRAM+1480, <CHARRAM+1488, <CHARRAM+1496, <CHARRAM+1504, <CHARRAM+1512
        byte <CHARRAM+1520, <CHARRAM+1528, <CHARRAM+1536, <CHARRAM+1544, <CHARRAM+1552, <CHARRAM+1560, <CHARRAM+1568, <CHARRAM+1576, <CHARRAM+1584, <CHARRAM+1592
        byte <CHARRAM+1600, <CHARRAM+1608, <CHARRAM+1616, <CHARRAM+1624, <CHARRAM+1632, <CHARRAM+1640, <CHARRAM+1648, <CHARRAM+1656, <CHARRAM+1664, <CHARRAM+1672
        byte <CHARRAM+1680, <CHARRAM+1688, <CHARRAM+1696, <CHARRAM+1704, <CHARRAM+1712, <CHARRAM+1720, <CHARRAM+1728, <CHARRAM+1736, <CHARRAM+1744, <CHARRAM+1752
        byte <CHARRAM+1760, <CHARRAM+1768, <CHARRAM+1776, <CHARRAM+1784, <CHARRAM+1792, <CHARRAM+1800, <CHARRAM+1808, <CHARRAM+1816, <CHARRAM+1824, <CHARRAM+1832
        byte <CHARRAM+1840, <CHARRAM+1848, <CHARRAM+1856, <CHARRAM+1864, <CHARRAM+1872, <CHARRAM+1880, <CHARRAM+1888, <CHARRAM+1896, <CHARRAM+1904, <CHARRAM+1912
        byte <CHARRAM+1920, <CHARRAM+1928, <CHARRAM+1936, <CHARRAM+1944, <CHARRAM+1952, <CHARRAM+1960, <CHARRAM+1968, <CHARRAM+1976, <CHARRAM+1984, <CHARRAM+1992
        byte <CHARRAM+2000, <CHARRAM+2008, <CHARRAM+2016, <CHARRAM+2024, <CHARRAM+2032

CharRAMHigh
        byte >CHARRAM, >CHARRAM+8, >CHARRAM+16, >CHARRAM+24, >CHARRAM+32, >CHARRAM+40, >CHARRAM+48, >CHARRAM+56, >CHARRAM+64, >CHARRAM+72
        byte >CHARRAM+80, >CHARRAM+88, >CHARRAM+96, >CHARRAM+104, >CHARRAM+112, >CHARRAM+120, >CHARRAM+128, >CHARRAM+136, >CHARRAM+144, >CHARRAM+152
        byte >CHARRAM+160, >CHARRAM+168, >CHARRAM+176, >CHARRAM+184, >CHARRAM+192, >CHARRAM+200, >CHARRAM+208, >CHARRAM+216, >CHARRAM+224, >CHARRAM+232
        byte >CHARRAM+240, >CHARRAM+248, >CHARRAM+256, >CHARRAM+264, >CHARRAM+272, >CHARRAM+280, >CHARRAM+288, >CHARRAM+296, >CHARRAM+304, >CHARRAM+312
        byte >CHARRAM+320, >CHARRAM+328, >CHARRAM+336, >CHARRAM+344, >CHARRAM+352, >CHARRAM+360, >CHARRAM+368, >CHARRAM+376, >CHARRAM+384, >CHARRAM+392
        byte >CHARRAM+400, >CHARRAM+408, >CHARRAM+416, >CHARRAM+424, >CHARRAM+432, >CHARRAM+440, >CHARRAM+448, >CHARRAM+456, >CHARRAM+464, >CHARRAM+472
        byte >CHARRAM+480, >CHARRAM+488, >CHARRAM+496, >CHARRAM+504, >CHARRAM+512, >CHARRAM+520, >CHARRAM+528, >CHARRAM+536, >CHARRAM+544, >CHARRAM+552
        byte >CHARRAM+560, >CHARRAM+568, >CHARRAM+576, >CHARRAM+584, >CHARRAM+592, >CHARRAM+600, >CHARRAM+608, >CHARRAM+616, >CHARRAM+624, >CHARRAM+632
        byte >CHARRAM+640, >CHARRAM+648, >CHARRAM+656, >CHARRAM+664, >CHARRAM+672, >CHARRAM+680, >CHARRAM+688, >CHARRAM+696, >CHARRAM+704, >CHARRAM+712
        byte >CHARRAM+720, >CHARRAM+728, >CHARRAM+736, >CHARRAM+744, >CHARRAM+752, >CHARRAM+760, >CHARRAM+768, >CHARRAM+776, >CHARRAM+784, >CHARRAM+792
        byte >CHARRAM+800, >CHARRAM+808, >CHARRAM+816, >CHARRAM+824, >CHARRAM+832, >CHARRAM+840, >CHARRAM+848, >CHARRAM+856, >CHARRAM+864, >CHARRAM+872
        byte >CHARRAM+880, >CHARRAM+888, >CHARRAM+896, >CHARRAM+904, >CHARRAM+912, >CHARRAM+920, >CHARRAM+928, >CHARRAM+936, >CHARRAM+944, >CHARRAM+952
        byte >CHARRAM+960, >CHARRAM+968, >CHARRAM+976, >CHARRAM+984, >CHARRAM+992, >CHARRAM+1000, >CHARRAM+1008, >CHARRAM+1016, >CHARRAM+1024, >CHARRAM+1032
        byte >CHARRAM+1040, >CHARRAM+1048, >CHARRAM+1056, >CHARRAM+1064, >CHARRAM+1072, >CHARRAM+1080, >CHARRAM+1088, >CHARRAM+1096, >CHARRAM+1104, >CHARRAM+1112
        byte >CHARRAM+1120, >CHARRAM+1128, >CHARRAM+1136, >CHARRAM+1144, >CHARRAM+1152, >CHARRAM+1160, >CHARRAM+1168, >CHARRAM+1176, >CHARRAM+1184, >CHARRAM+1192
        byte >CHARRAM+1200, >CHARRAM+1208, >CHARRAM+1216, >CHARRAM+1224, >CHARRAM+1232, >CHARRAM+1240, >CHARRAM+1248, >CHARRAM+1256, >CHARRAM+1264, >CHARRAM+1272
        byte >CHARRAM+1280, >CHARRAM+1288, >CHARRAM+1296, >CHARRAM+1304, >CHARRAM+1312, >CHARRAM+1320, >CHARRAM+1328, >CHARRAM+1336, >CHARRAM+1344, >CHARRAM+1352
        byte >CHARRAM+1360, >CHARRAM+1368, >CHARRAM+1376, >CHARRAM+1384, >CHARRAM+1392, >CHARRAM+1400, >CHARRAM+1408, >CHARRAM+1416, >CHARRAM+1424, >CHARRAM+1432
        byte >CHARRAM+1440, >CHARRAM+1448, >CHARRAM+1456, >CHARRAM+1464, >CHARRAM+1472, >CHARRAM+1480, >CHARRAM+1488, >CHARRAM+1496, >CHARRAM+1504, >CHARRAM+1512
        byte >CHARRAM+1520, >CHARRAM+1528, >CHARRAM+1536, >CHARRAM+1544, >CHARRAM+1552, >CHARRAM+1560, >CHARRAM+1568, >CHARRAM+1576, >CHARRAM+1584, >CHARRAM+1592
        byte >CHARRAM+1600, >CHARRAM+1608, >CHARRAM+1616, >CHARRAM+1624, >CHARRAM+1632, >CHARRAM+1640, >CHARRAM+1648, >CHARRAM+1656, >CHARRAM+1664, >CHARRAM+1672
        byte >CHARRAM+1680, >CHARRAM+1688, >CHARRAM+1696, >CHARRAM+1704, >CHARRAM+1712, >CHARRAM+1720, >CHARRAM+1728, >CHARRAM+1736, >CHARRAM+1744, >CHARRAM+1752
        byte >CHARRAM+1760, >CHARRAM+1768, >CHARRAM+1776, >CHARRAM+1784, >CHARRAM+1792, >CHARRAM+1800, >CHARRAM+1808, >CHARRAM+1816, >CHARRAM+1824, >CHARRAM+1832
        byte >CHARRAM+1840, >CHARRAM+1848, >CHARRAM+1856, >CHARRAM+1864, >CHARRAM+1872, >CHARRAM+1880, >CHARRAM+1888, >CHARRAM+1896, >CHARRAM+1904, >CHARRAM+1912
        byte >CHARRAM+1920, >CHARRAM+1928, >CHARRAM+1936, >CHARRAM+1944, >CHARRAM+1952, >CHARRAM+1960, >CHARRAM+1968, >CHARRAM+1976, >CHARRAM+1984, >CHARRAM+1992
        byte >CHARRAM+2000, >CHARRAM+2008, >CHARRAM+2016, >CHARRAM+2024, >CHARRAM+2032

ScreenRAMRowStartLow ;  SCREENRAM + 40*0, 40*1, 40*2 ... 40*24
        byte <SCREENRAMONE,     <SCREENRAMONE+40,  <SCREENRAMONE+80
        byte <SCREENRAMONE+120, <SCREENRAMONE+160, <SCREENRAMONE+200
        byte <SCREENRAMONE+240, <SCREENRAMONE+280, <SCREENRAMONE+320
        byte <SCREENRAMONE+360, <SCREENRAMONE+400, <SCREENRAMONE+440
        byte <SCREENRAMONE+480, <SCREENRAMONE+520, <SCREENRAMONE+560
        byte <SCREENRAMONE+600, <SCREENRAMONE+640, <SCREENRAMONE+680
        byte <SCREENRAMONE+720, <SCREENRAMONE+760, <SCREENRAMONE+800
        byte <SCREENRAMONE+840, <SCREENRAMONE+880, <SCREENRAMONE+920
        byte <SCREENRAMONE+960

ScreenRAMRowStartHigh ;  SCREENRAM + 40*0, 40*1, 40*2 ... 40*24
        byte >SCREENRAMONE,     >SCREENRAMONE+40,  >SCREENRAMONE+80
        byte >SCREENRAMONE+120, >SCREENRAMONE+160, >SCREENRAMONE+200
        byte >SCREENRAMONE+240, >SCREENRAMONE+280, >SCREENRAMONE+320
        byte >SCREENRAMONE+360, >SCREENRAMONE+400, >SCREENRAMONE+440
        byte >SCREENRAMONE+480, >SCREENRAMONE+520, >SCREENRAMONE+560
        byte >SCREENRAMONE+600, >SCREENRAMONE+640, >SCREENRAMONE+680
        byte >SCREENRAMONE+720, >SCREENRAMONE+760, >SCREENRAMONE+800
        byte >SCREENRAMONE+840, >SCREENRAMONE+880, >SCREENRAMONE+920
        byte >SCREENRAMONE+960

ScreenRAMTWORowStartLow ;  SCREENRAM + 40*0, 40*1, 40*2 ... 40*24
        byte <SCREENRAMTWO,     <SCREENRAMTWO+40,  <SCREENRAMTWO+80
        byte <SCREENRAMTWO+120, <SCREENRAMTWO+160, <SCREENRAMTWO+200
        byte <SCREENRAMTWO+240, <SCREENRAMTWO+280, <SCREENRAMTWO+320
        byte <SCREENRAMTWO+360, <SCREENRAMTWO+400, <SCREENRAMTWO+440
        byte <SCREENRAMTWO+480, <SCREENRAMTWO+520, <SCREENRAMTWO+560
        byte <SCREENRAMTWO+600, <SCREENRAMTWO+640, <SCREENRAMTWO+680
        byte <SCREENRAMTWO+720, <SCREENRAMTWO+760, <SCREENRAMTWO+800
        byte <SCREENRAMTWO+840, <SCREENRAMTWO+880, <SCREENRAMTWO+920
        byte <SCREENRAMTWO+960

ScreenRAMTWORowStartHigh ;  SCREENRAM + 40*0, 40*1, 40*2 ... 40*24
        byte >SCREENRAMTWO,     >SCREENRAMTWO+40,  >SCREENRAMTWO+80
        byte >SCREENRAMTWO+120, >SCREENRAMTWO+160, >SCREENRAMTWO+200
        byte >SCREENRAMTWO+240, >SCREENRAMTWO+280, >SCREENRAMTWO+320
        byte >SCREENRAMTWO+360, >SCREENRAMTWO+400, >SCREENRAMTWO+440
        byte >SCREENRAMTWO+480, >SCREENRAMTWO+520, >SCREENRAMTWO+560
        byte >SCREENRAMTWO+600, >SCREENRAMTWO+640, >SCREENRAMTWO+680
        byte >SCREENRAMTWO+720, >SCREENRAMTWO+760, >SCREENRAMTWO+800
        byte >SCREENRAMTWO+840, >SCREENRAMTWO+880, >SCREENRAMTWO+920
        byte >SCREENRAMTWO+960

ColorRAMRowStartLow ;  COLORRAM + 40*0, 40*1, 40*2 ... 40*24
        byte <COLORRAM,     <COLORRAM+40,  <COLORRAM+80
        byte <COLORRAM+120, <COLORRAM+160, <COLORRAM+200
        byte <COLORRAM+240, <COLORRAM+280, <COLORRAM+320
        byte <COLORRAM+360, <COLORRAM+400, <COLORRAM+440
        byte <COLORRAM+480, <COLORRAM+520, <COLORRAM+560
        byte <COLORRAM+600, <COLORRAM+640, <COLORRAM+680
        byte <COLORRAM+720, <COLORRAM+760, <COLORRAM+800
        byte <COLORRAM+840, <COLORRAM+880, <COLORRAM+920
        byte <COLORRAM+960

ColorRAMRowStartHigh ;  COLORRAM + 40*0, 40*1, 40*2 ... 40*24
        byte >COLORRAM,     >COLORRAM+40,  >COLORRAM+80
        byte >COLORRAM+120, >COLORRAM+160, >COLORRAM+200
        byte >COLORRAM+240, >COLORRAM+280, >COLORRAM+320
        byte >COLORRAM+360, >COLORRAM+400, >COLORRAM+440
        byte >COLORRAM+480, >COLORRAM+520, >COLORRAM+560
        byte >COLORRAM+600, >COLORRAM+640, >COLORRAM+680
        byte >COLORRAM+720, >COLORRAM+760, >COLORRAM+800
        byte >COLORRAM+840, >COLORRAM+880, >COLORRAM+920
        byte >COLORRAM+960

Operator HiLo

screenDebugZero         byte 0
screenDebugOne          byte 0

screenScrollXValue      byte 0
backgroundScrollXValue  byte 0

backgroundCheckXChar byte 0
backgroundCheckYChar byte 0

;===============================================================================
; Macros/Subroutines

;===============================================================================

defm LIBSCREEN_BACKGROUND_CHECK
        lda /1
        sta backgroundCheckXChar
        lda /2
        sta backgroundCheckYChar

        jsr libScreenBackgroundCheck

        endm

libScreenBackgroundCheck

        LIBSCREEN_SETCHARPOSITION_AA backgroundCheckXChar, backgroundCheckYChar
        lda (ZeroPageLow),Y
        cmp #12
        beq @noBackground
        cmp #245
        bcs @noBackground
        lda #1
        jmp @done

@noBackground
        lda #0

@done
        rts

;===============================================================================

defm    LIBSCREEN_COPYMAPROW_NEW_VVA
        ldy #0
        ldx /3

@lSCMRLoop

        cpx #MapLastColumn
        bne @doneWrap
        
        ldx #0

@doneWrap
        lda /1,x
        sta /2,y

        iny
        inx

        cpy #39
        bne @lSCMRLoop

        endm

;==============================================================================


defm    LIBSCREEN_COPYMAPROWCOLOR_NEW_VVA
        ldy #0
        ldx /3

@lSCMRLoop

        cpx #MapLastColumn
        bne @doneWrap
        
        ldx #0

@doneWrap
        lda /1,x
        ora #%00001000 ; set multicolor bit
        sta /2,y

        iny
        inx

        cpy #39
        bne @lSCMRLoop

        endm

;===============================================================================
; Macros/Subroutines

defm    LIBSCREEN_DEBUG8BIT_VVA
                        ; /1 = X Position Absolute
                        ; /2 = Y Position Absolute
                        ; /3 = 1st Number Low Byte Pointer
        
        lda #White
        sta $0286       ; set text color
        lda #$20        ; space
        jsr $ffd2       ; print 4 spaces
        jsr $ffd2
        jsr $ffd2
        jsr $ffd2
        ;jsr $E566      ; reset cursor
        ldx #/2         ; Select row 
        ldy #/1         ; Select column 
        jsr $E50C       ; Set cursor 

        lda #0
        ldx /3
        jsr $BDCD       ; print number
        endm

;===============================================================================

defm    LIBSCREEN_DEBUG16BIT_VVAA
                        ; /1 = X Position Absolute
                        ; /2 = Y Position Absolute
                        ; /3 = 1st Number High Byte Pointer
                        ; /4 = 1st Number Low Byte Pointer
        
        lda #White
        sta $0286       ; set text color
        lda #$20        ; space
        jsr $ffd2       ; print 4 spaces
        jsr $ffd2
        jsr $ffd2
        jsr $ffd2
        ;jsr $E566      ; reset cursor
        ldx #/2         ; Select row 
        ldy #/1         ; Select column 
        jsr $E50C       ; Set cursor 

        lda /3
        ldx /4
        jsr $BDCD       ; print number
        endm

;==============================================================================

defm    LIBSCREEN_DRAWTEXT_AAAV ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                                ; /3 = 0 terminated string (Address)
                                ; /4 = Text Color (Value)

        ldy /2 ; load y position as index into list
        
        lda ScreenRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        ldx #0
@loop   lda /3,X
        cmp #0
        beq @done
        sta (ZeroPageLow),Y
        inx
        iny
        jmp @loop
@done


        ldy /2 ; load y position as index into list
        
        lda ColorRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ColorRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        ldx #0
@loop2  lda /3,X
        cmp #0
        beq @done2
        lda #/4
        sta (ZeroPageLow),Y
        inx
        iny
        jmp @loop2
@done2

        endm

;===============================================================================

defm    LIBSCREEN_DRAWDECIMAL_AAAVV ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                                ; /3 = decimal number 2 nybbles (Address)
                                ; /4 = Text Color (Value)
                                ; /5 = secondary screen

        ldy /2 ; load y position as index into list

        lda #/5
        bne @flipSecondary
@flipPrimary
        lda ScreenRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh
        jmp @flipDone
@flipSecondary
        lda ScreenRAMTWORowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMTWORowStartHigh,Y ; load high address byte
        sta ZeroPageHigh
@flipDone

        ldy /1 ; load x position into Y register

        ; get high nybble
        lda /3
        and #$F0
        
        ; convert to ascii
        lsr
        lsr
        lsr
        lsr
        ora #$30

        sta (ZeroPageLow),Y

        ; move along to next screen position
        iny 

        ; get low nybble
        lda /3
        and #$0F

        ; convert to ascii
        ora #$30  

        sta (ZeroPageLow),Y
    

        ; now set the colors
        ldy /2 ; load y position as index into list
        
        lda ColorRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ColorRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        lda #/4
        sta (ZeroPageLow),Y

        ; move along to next screen position
        iny 
        
        sta (ZeroPageLow),Y

        endm

;==============================================================================

defm    LIBSCREEN_GETCHAR  ; /1 = Return character code (Address)
        lda (ZeroPageLow),Y
        sta /1
        endm

;===============================================================================

defm    LIBSCREEN_PIXELTOCHAR_AAVAVAA
                                ; /1 = XHighPixels      (Address)
                                ; /2 = XLowPixels       (Address)
                                ; /3 = XAdjust          (Value)
                                ; /4 = YPixels          (Address)
                                ; /5 = YAdjust          (Value)
                                ; /6 = XChar            (Address)
                                ; /7 = YChar            (Address)
                                

        lda /1
        sta ZeroPageParam1
        lda /2
        sta ZeroPageParam2
        lda #/3
        sta ZeroPageParam3
        lda /4
        sta ZeroPageParam4
        lda #/5
        sta ZeroPageParam5
        
        jsr libScreen_PixelToChar

        lda ZeroPageParam6
        sta /6
        lda ZeroPageParam8
        sta /7

        endm


defm    LIBSCREEN_PIXELTOCHAR_AAVAVAAAA
                                ; /1 = XHighPixels      (Address)
                                ; /2 = XLowPixels       (Address)
                                ; /3 = XAdjust          (Value)
                                ; /4 = YPixels          (Address)
                                ; /5 = YAdjust          (Value)
                                ; /6 = XChar            (Address)
                                ; /7 = XOffset          (Address)
                                ; /8 = YChar            (Address)
                                ; /9 = YOffset          (Address)
                                

        lda /1
        sta ZeroPageParam1
        lda /2
        sta ZeroPageParam2
        lda #/3
        sta ZeroPageParam3
        lda /4
        sta ZeroPageParam4
        lda #/5
        sta ZeroPageParam5
        
        jsr libScreen_PixelToChar

        lda ZeroPageParam6
        sta /6
        lda ZeroPageParam7
        sta /7
        lda ZeroPageParam8
        sta /8
        lda ZeroPageParam9
        sta /9

        endm

libScreen_PixelToChar

        ; subtract XAdjust pixels from XPixels as left of a sprite is first visible at x = 24
        LIBMATH_SUB16BIT_AAVAAA ZeroPageParam1, ZeroPageParam2, 0, ZeroPageParam3, ZeroPageParam6, ZeroPageParam7

        lda ZeroPageParam6
        sta ZeroPageTemp

        ; divide by 8 to get character X
        lda ZeroPageParam7
        lsr A ; divide by 2
        lsr A ; and again = /4
        lsr A ; and again = /8
        sta ZeroPageParam6

        ; AND 7 to get pixel offset X
        lda ZeroPageParam7
        and #7
        sta ZeroPageParam7

        ; Adjust for XHigh
        lda ZeroPageTemp
        beq @nothigh
        LIBMATH_ADD8BIT_AVA ZeroPageParam6, 32, ZeroPageParam6 ; shift across 32 chars

@nothigh
        ; subtract YAdjust pixels from YPixels as top of a sprite is first visible at y = 50
        LIBMATH_SUB8BIT_AAA ZeroPageParam4, ZeroPageParam5, ZeroPageParam9


        ; divide by 8 to get character Y
        lda ZeroPageParam9
        lsr A ; divide by 2
        lsr A ; and again = /4
        lsr A ; and again = /8
        sta ZeroPageParam8

        ; AND 7 to get pixel offset Y
        lda ZeroPageParam9
        and #7
        sta ZeroPageParam9

        rts

;==============================================================================

defm    LIBSCREEN_FOREGROUNDSCROLLLEFTONE

        dec screenScrollXValue
        lda screenScrollXValue
        and #%00000111
        sta screenScrollXValue

        endm

defm    LIBSCREEN_BACKGROUNDSCROLLLEFTONE

        dec backgroundScrollXValue
        lda backgroundScrollXValue
        and #%00000111
        sta backgroundScrollXValue

        endm

defm    LIBSCREEN_FOREGROUNDSCROLLLEFTTWO

        dec screenScrollXValue
        dec screenScrollXValue
        lda screenScrollXValue
        and #%00000111
        sta screenScrollXValue

        endm

defm    LIBSCREEN_BACKGROUNDSCROLLLEFTTWO

        dec backgroundScrollXValue
        dec backgroundScrollXValue
        lda backgroundScrollXValue
        and #%00000111
        sta backgroundScrollXValue

        endm

defm    LIBSCREEN_FOREGROUNDSCROLLRIGHTONE

        inc screenScrollXValue
        lda screenScrollXValue
        and #%00000111
        sta screenScrollXValue

        endm

defm    LIBSCREEN_BACKGROUNDSCROLLRIGHTONE

        inc backgroundScrollXValue
        lda backgroundScrollXValue
        and #%00000111
        sta backgroundScrollXValue

        endm

defm    LIBSCREEN_FOREGROUNDSCROLLRIGHTTWO

        inc screenScrollXValue
        inc screenScrollXValue
        lda screenScrollXValue
        and #%00000111
        sta screenScrollXValue

        endm

defm    LIBSCREEN_BACKGROUNDSCROLLRIGHTTWO

        inc backgroundScrollXValue
        inc backgroundScrollXValue
        lda backgroundScrollXValue
        and #%00000111
        sta backgroundScrollXValue

        endm

defm    LIBSCREEN_SCROLLTOSCOREBOARD

        lda SCROLX
        and #%11111000
        ora #0
        sta SCROLX

        endm

defm    LIBSCREEN_SCROLLTOFOREGROUND

        lda SCROLX
        and #%11111000
        ora screenScrollXValue
        sta SCROLX

        endm

defm    LIBSCREEN_SCROLLTOBACKGROUND

        lda SCROLX
        and #%11111000
        ora backgroundScrollXValue
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SCROLLXRESET_A         ; /1 = update subroutine (Address)

        lda #0
        sta screenColumn
        sta screenScrollXValue

        lda SCROLX
        and #%11111000
        ora screenScrollXValue
        sta SCROLX

        jsr /1 ; call the passed in function to update the screen rows

        endm

;==============================================================================

defm    LIBSCREEN_SETSCROLLXVALUE_A     ; /1 = ScrollX value (Address)

        lda SCROLX
        and #%11111000
        ora /1
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SETSCROLLXVALUE_V     ; /1 = ScrollX value (Value)

        lda SCROLX
        and #%11111000
        ora #/1
        sta SCROLX

        endm

;==============================================================================

; Sets 1000 bytes of memory from start address with a value
defm    LIBSCREEN_SET1000       ; /1 = Start  (Address)
                                ; /2 = Number (Value)

        lda #/2                 ; Get number to set
        ldx #250                ; Set loop value
@loop   dex                     ; Step -1
        sta /1,x                ; Set start + x
        sta /1+250,x            ; Set start + 250 + x
        sta /1+500,x            ; Set start + 500 + x
        sta /1+750,x            ; Set start + 750 + x
        bne @loop               ; If x<>0 loop

        endm

;==============================================================================

defm    LIBSCREEN_SET24ROWMODE

        lda SCROLY
        and #%11110111 ; clear bit 3
        sta SCROLY

        endm

;==============================================================================

defm    LIBSCREEN_SET25ROWMODE

        lda SCROLY
        ora #%00001000 ; set bit 3
        sta SCROLY

        endm

;==============================================================================

defm    LIBSCREEN_SET38COLUMNMODE

        lda SCROLX
        and #%11110111 ; clear bit 3
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SET40COLUMNMODE

        lda SCROLX
        ora #%00001000 ; set bit 3
        sta SCROLX

        endm

;==============================================================================

defm    LIBSCREEN_SETCHARMEMORY  ; /1 = Character Memory Slot (Value)
        ; point vic (lower 4 bits of $d018)to new character data
        lda VMCSB
        and #%11110000 ; keep higher 4 bits
        ; p208 M Jong book
        ora #/1;$0E ; maps to  $3800 memory address
        sta VMCSB
        endm

;==============================================================================

defm    LIBSCREEN_SETCHAR_V  ; /1 = Character Code (Value)
        lda #/1
        sta (ZeroPageLow),Y
        endm

;==============================================================================

defm    LIBSCREEN_SETCHAR_A  ; /1 = Character Code (Address)
        lda /1
        sta (ZeroPageLow),Y
        endm

;==============================================================================

defm    LIBSCREEN_SETCHARPOSITION_AA    ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
        
        ldy /2 ; load y position as index into list
        
        lda ScreenRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm

defm    LIBSCREEN_TWO_SETCHARPOSITION_AA    ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
        
        ldy /2 ; load y position as index into list
        
        lda ScreenRAMTWORowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ScreenRAMTWORowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm


defm    LIBSCREEN_SETMAPPOSITION_AA    ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
        
        ldy /2 ; load y position as index into list

        lda MapRAMRowStartLow,Y ; load low address byte
        adc screenColumn
        sta ZeroPageLow

        lda MapRAMRowStartHigh,Y ; load high address byte
        adc screenColumn
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm

;==============================================================================

defm    LIBSCREEN_SETCOLORPOSITION_AA   ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                               
        ldy /2 ; load y position as index into list
        
        lda ColorRAMRowStartLow,Y ; load low address byte
        sta ZeroPageLow

        lda ColorRAMRowStartHigh,Y ; load high address byte
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm

defm    LIBSCREEN_SETMAPCOLORPOSITION_AA   ; /1 = X Position 0-39 (Address)
                                ; /2 = Y Position 0-24 (Address)
                               
        ldy /2 ; load y position as index into list
        
        lda MapRAMCOLRowStartLow,Y ; load low address byte
        adc screenColumn
        sta ZeroPageLow

        lda MapRAMCOLRowStartHigh,Y ; load high address byte
        adc screenColumn
        sta ZeroPageHigh

        ldy /1 ; load x position into Y register

        endm

;===============================================================================

; Sets the border and background colors
defm    LIBSCREEN_SETCOLORS     ; /1 = Border Color       (Value)
                                ; /2 = Background Color 0 (Value)
                                ; /3 = Background Color 1 (Value)
                                ; /4 = Background Color 2 (Value)
                                ; /5 = Background Color 3 (Value)
                                
        lda #/1                 ; Color0 -> A
        sta EXTCOL              ; A -> EXTCOL
        lda #/2                 ; Color1 -> A
        sta BGCOL0              ; A -> BGCOL0
        lda #/3                 ; Color2 -> A
        sta BGCOL1              ; A -> BGCOL1
        lda #/4                 ; Color3 -> A
        sta BGCOL2              ; A -> BGCOL2
        lda #/5                 ; Color4 -> A
        sta BGCOL3              ; A -> BGCOL3

        endm

;==============================================================================

defm    LIBSCREEN_SETMULTICOLORMODE

        lda SCROLX
        ora #%00010000 ; set bit 5
        sta SCROLX

        endm

;===============================================================================

; Waits for a given scanline 
defm    LIBSCREEN_WAIT_V        ; /1 = Scanline (Value)

@loop   lda #/1                 ; Scanline -> A
        cmp RASTER              ; Compare A to current raster line
        bne @loop               ; Loop if raster line not reached 255

        endm


