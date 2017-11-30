; Devise Khodirev A.P. LAN-tester,for any AVR. Here is for ATtiny2313
; *****************************************************************************
; MPU proizvodit posledovatel'niy vikhodi v port D, gde vkluchen LAN-kabel.
; Tak mi mogem opredelit' podluchen kabel ili net
; Prosto nablyudayte za svecheniyem svetodiodov. Yesli pryamoy kabel' podklyuchen mezhdu
; raz"yemy A i B, togda svetodiody budut svetit'sya posledovatel'no.
; Yesli perekrestnyy kabel' podklyuchen, to poryadok svecheniya budet takim zhe, kak ukazano na plate,
; t.ye. 1,2,7,4,5,8,3,6. Yesli proiskhodit kakoy-libo drugoy poryadok svecheniya, eto oznachayet, chto kabel'
; nepravil'no podklyuchen. Yesli odno ili bol'she svetodiodov ne svetyatsya, to u nas yest' sootvetstvuyushchiye
; otsutstviye kontakta.
; Mozhno ispol'zovat' dopolnitel'nyy udalennyy blok s raz"yemom B (B2), v sluchaye, yesli oba
; kontsy kabelya ne mogut byt' ustanovleny dostatochno blizko, chtoby ikh mozhno bylo podklyuchit' na odnoy plate.


.NOLIST
.INCLUDE "tn2313def.inc"
.LIST

; Code starts here
.CSEG
.ORG $0000

.def	temp1 	= r16
.def	T1 		= r17
.def	T2 		= r18
.def	T3 		= r19
.def	cnt		= r29	; binary counter 0-7
.def	indexL	= r30	; eti registry prednaznacheny dlya komandy lpm
.def	indexH	= r31

.equ	Td		= 3		; delay time

rjmp RESET				; Reset Handler

; =============== podprogrammy ===============

delay:	ser		T1		; long delay
		ser		T2
		ldi		T3,Td
sdel1:	dec		T1
		brne	sdel1
		ser		T1
		dec		T2
		brne	sdel1
		ser		T2
		dec		T3
		brne	sdel1
		ret

; =============== Main program ===============

RESET:	ldi		r16,LOW(RAMEND)	;Initiate Stackpointer.
		out		SPL,r16
		ser		temp1
		out		ddrA,temp1
		out		ddrB,temp1
		out		ddrD,temp1
		out		portB,temp1
		clr		temp1
		out		portA,temp1
		out		portD,temp1
		rcall	delay		; test LEDs

start:	ldi		indexH,HIGH(2*leds)
		ldi		indexL,LOW(2*leds)
		clr		cnt
st1:	lpm		temp1,z+
		out		portB,temp1
		out		portD,cnt
		inc		cnt
		cpi		cnt,8
		brne	st2
		clr		cnt
st2:	rcall	delay
		cpi		temp1,128	; end of row?
		breq	start
		rjmp	st1			; take next data

leds:	
.db		1, 2, 4, 8, 16, 32, 64, 128




