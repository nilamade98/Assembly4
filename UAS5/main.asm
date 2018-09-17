;
; UAS4.asm
;
; Created: 1/9/2018 12:05:28 AM
; Author : FX46
;


; a. dimulai dengan alamat 0x300 untuk prgram geser ke kiri 1 bit isi dari register r20
; b. dimulai dengan alamat 0x400 untuk prgram geser ke kanan 1 bit isi dari register r21

.org 0x00
	jmp main

.org 0x012
	jmp TIMER1_OVF

.org 0x100
main :	ldi r16, high(ramend)
		out SPH, r16
		ldi r16, low(ramend)
		out SPL, r16

		ldi r16, 0xFF
		out DDRA, r16
		out DDRB, r16
		
		ldi r18, (1<<TOIE1)
		out TIMSK, r20
		sei

		ldi r18, 0x01
		out TCNT1H, r18
		ldi r18, 0x1f
		out TCNT1L, r18
		ldi r18, 0x01
		out TCCR1B, r18
		ldi r18, 0x00
		out TCCR1A, r18

		ldi r20, 0b11111110
		ldi r21, 0b01111111

here : rjmp here

.org 0x150 ;.org 0x300
	sec 
	out DDRA, r20
	rol r20
	clc
	RETI
	swap r20
	RETI

.org 0x200 ;.org 0x400
	sec 
	out DDRA, r20
	ror r20
	clc
	RETI
	swap r20
	RETI

.org 0x600
TIMER1_OVF :	ldi r20, 0x01
				out TCNT1H, r20
				ldi r20, 0x1F
				out TCNT1L, r20

		cpi r25, 1
		breq progb
proga : inc r25
	    jmp 0x300
progb : ldi r25, 0x00
		jmp 0x400

