
; Created: 18-Oct-23 10:10:54 PM
; Author : NELLY NDUNG'U
.include "m328pdef.inc"

.cseg
.org 0x0000

start: 
	ldi r16, 0xFF
	out DDRD, r16
loop:
	sbi PORTD, 0
	call delay_ms
	sbi PORTD, 1
	call delay_ms
	sbi PORTD, 2
	call delay_ms
	sbi PORTD, 3
	call delay_ms
	sbi PORTD, 4
	call delay_ms
	sbi PORTD, 5
	call delay_ms
	sbi PORTD, 6
	call delay_ms
	sbi PORTD, 7
	call delay_ms
	cbi PORTD, 0
	call delay_ms
	cbi PORTD, 1
	call delay_ms
	cbi PORTD, 2
	call delay_ms
	cbi PORTD, 3
	call delay_ms
	cbi PORTD, 4
	call delay_ms
	cbi PORTD, 5
	call delay_ms
	cbi PORTD, 6
	call delay_ms
	cbi PORTD, 7
	call delay_ms
	rjmp loop

delay_ms:
	ldi r17, 40
loop1:
	ldi r18, 30
loop2:
	ldi r19, 10
loop3: 
	dec r19
	brne loop3
	dec r18
	brne loop2
	dec r17
	brne loop1
	ret


