;***INC*********************************************************
;** NAME:
;** at89c5131.inc
;** ------------------------------------------------------------
;** PURPOSE:
;** This file defines SFR and BIT registers for AT89C5131
;***************************************************************


$SAVE
$NOLIST


;** _____ C 5 1   C O R E ______________________________________

ACC DATA 0xE0 ;** ACC is bit addressable ;**
B DATA 0xF0 ;** B is bit addressable ;**
PSW DATA 0xD0 ;** PSW is bit addressable ;**
SP DATA 0x81
DPL DATA 0x82
DPH DATA 0x83


;** _____  I / O    P O R T ____________________________________

P0 DATA 0x80 ;** P0 is bit addressable ;**
P1 DATA 0x90 ;** P1 is bit addressable ;**
P2 DATA 0xA0 ;** P2 is bit addressable ;**
P3 DATA 0xB0 ;** P3 is bit addressable ;**
P4 DATA 0xC0
P5 DATA 0xE8

;** P3 bits ;**
RD BIT 0xB7
WR BIT 0xB6
T1 BIT 0xB5
T0 BIT 0xB4
INT1 BIT 0xB3
INT0 BIT 0xB2
TXD BIT 0xB1
RXD BIT 0xB0


;** _____ T I M E R S __________________________________________

TH0 DATA 0x8C
TL0 DATA 0x8A
TH1 DATA 0x8D
TL1 DATA 0x8B
TH2 DATA 0xCD
TL2 DATA 0xCC
TCON DATA 0x88 ;** TCON is bit addressable ;**
TMOD DATA 0x89
T2CON DATA 0xC8 ;** T2CON is bit addressable ;**
T2MOD DATA 0xC9
RCAP2H DATA 0xCB
RCAP2L DATA 0xCA
WDTRST DATA 0xA6
WDTPRG DATA 0xA7

;** TCON bits ;**
TF1 BIT 0x8F
TR1 BIT 0x8E
TF0 BIT 0x8D
TR0 BIT 0x8C
IE1 BIT 0x8B
IT1 BIT 0x8A
IE0 BIT 0x89
IT0 BIT 0x88

;** T2CON bits ;**
TF2 BIT 0xCF
EXF2 BIT 0xCE
RCLK BIT 0xCD
TCLK BIT 0xCC
EXEN2 BIT 0xCB
TR2 BIT 0xCA
C_T2 BIT 0xC9
CP_RL2 BIT 0xC8


;** _____ S E R I A L    I / O _________________________________

SCON DATA 0x98
SBUF DATA 0x99
SADEN DATA 0xB9
SADDR DATA 0xA9

;** SCON bits ;**
SM0 BIT 0x9F
SM1 BIT 0x9E
SM2 BIT 0x9D
REN BIT 0x9C
TB8 BIT 0x9B
RB8 BIT 0x9A
TI BIT 0x99
RI BIT 0x98


;** _____ B A U D    R A T E    G E N E R A T O R ______________

BRL DATA 0x9A
BDRCON DATA 0x9B


;** _____ P C A ________________________________________________

CCON DATA 0xD8 ;** CCON is bit addressable ;**
CMOD DATA 0xD9
CL DATA 0xE9
CH DATA 0xF9
CCAPM0 DATA 0xDA
CCAPM1 DATA 0xDB
CCAPM2 DATA 0xDC
CCAPM3 DATA 0xDD
CCAPM4 DATA 0xDE
CCAP0H DATA 0xFA
CCAP1H DATA 0xFB
CCAP2H DATA 0xFC
CCAP3H DATA 0xFD
CCAP4H DATA 0xFE
CCAP0L DATA 0xEA
CCAP1L DATA 0xEB
CCAP2L DATA 0xEC
CCAP3L DATA 0xED
CCAP4L DATA 0xEE

 ;** CCON bits ;** 
CF BIT 0xDF
CR BIT 0xDE
CCF4 BIT 0xDC
CCF3 BIT 0xDB
CCF2 BIT 0xDA
CCF1 BIT 0xD9
CCF0 BIT 0xD8


;** _____ I N T E R R U P T ____________________________________

IEN0 DATA 0xA8 ;** IEN0 is bit addressable ;**
IEN1 DATA 0xB1
IPL0 DATA 0xB8 ;** IPL0 is bit addressable ;**
IPH0 DATA 0xB7
IPL1 DATA 0xB2
IPH1 DATA 0xB3

;** IEN0 bits ;**
EA BIT 0xAF
EC BIT 0xAE
ET2 BIT 0xAD
ES BIT 0xAC
ET1 BIT 0xAB
EX1 BIT 0xAA
ET0 BIT 0xA9
EX0 BIT 0xA8

;** IPL0 bits ;**
PPCL BIT 0xBE
PT2L BIT 0xBD
PSL BIT 0xBC
PT1L BIT 0xBB
PX1L BIT 0xBA
PT0L BIT 0xB9
PX0L BIT 0xB8


;** _____ P L L ________________________________________________

PLLCON DATA 0xA3
PLLDIV DATA 0xA4


;** _____ K E Y B O A R D ______________________________________

KBF DATA 0x9E
KBE DATA 0x9D
KBLS DATA 0x9C


;** _____ T W I ________________________________________________

SSCON DATA 0x93
SSCS DATA 0x94
SSDAT DATA 0x95
SSADR DATA 0x96


;** _____ S P I ________________________________________________

SPCON DATA 0xC3
SPSTA DATA 0xC4
SPDAT DATA 0xC5


;** _____ U S B ________________________________________________

USBCON DATA 0xBC
USBADDR DATA 0xC6
USBINT DATA 0xBD
USBIEN DATA 0xBE
UEPNUM DATA 0xC7
UEPCONX DATA 0xD4
UEPSTAX DATA 0xCE
UEPRST DATA 0xD5
UEPINT DATA 0xF8 ;** UEPINT is bit addressable ;**
UEPIEN DATA 0xC2
UEPDATX DATA 0xCF
UBYCTLX DATA 0xE2
UBYCTHX DATA 0xE3
UDPADDL DATA 0xD6
UDPADDH DATA 0xD7
UFNUML DATA 0xBA
UFNUMH DATA 0xBB

;** UEPINT bits ;**
EP6INT BIT 0xFF
EP5INT BIT 0xFD
EP4INT BIT 0xFC
EP3INT BIT 0xFB
EP2INT BIT 0xFA
EP1INT BIT 0xF9
EP0INT BIT 0xF8


;** _____ F L A S H  C O N T R O L _____________________________

FCON DATA 0xD1


;** _____ E E  D A T A _________________________________________

EECON DATA 0xD2


;** _____ M I S C . ____________________________________________

PCON DATA 0x87
AUXR DATA 0x8E
AUXR1 DATA 0xA2
CKCON0 DATA 0x8F
CKCON1 DATA 0xAF
CKSEL DATA 0x85
LEDCON DATA 0xF1


$RESTORE
