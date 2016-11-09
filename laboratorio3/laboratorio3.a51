;============================================================
; definitions
;============================================================

; hdw
key_a	bit	p3.0
key_b	bit	p3.1
step	bit	p3.5
accl	equ	0x40
decl	equ	0x41
half_step	equ	0x42
clockwise	equ	0x43
; var
tx0	data	0x50
tx0_max	data	0x10
tx0_min	data	0x04
tx0_reload	equ	0x04
th0_reload	equ	0xd8
tl0_reload	equ	0xf0


;============================================================
; interruptions
;============================================================

	org	0x0000
	jmp	it_reset

	org	0x0003
	jmp	it_external0

	org	0x000b
	jmp	it_timer0

	org	0x0013
	jmp	it_external1


;============================================================
; main
;============================================================

	org	0x007b
it_reset:
	mov	a, #tx0_reload
	mov	tx0, a
	mov	th0, #th0_reload
	mov	tl0, #tl0_reload
	anl	tmod, #0x00
	orl	tmod, #0x01
	setb	it0
	setb	it1
	setb	ex0
	setb	et0
	setb	ex1
	setb	ea
	setb	tr0
	mov	p0, #0xff
	setb	step
	clr	decl
	clr	accl
	setb	half_step
	setb	clockwise
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_0001:
	mov	p0, #0x01
	jb	step, $
	setb	step
	jnb	clockwise, state_0001_cw
state_0001_ac:
	jnb	half_step, state_1001
	jmp	state_1000
state_0001_cw:
	jnb	half_step, state_0011
	jmp	state_0010
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_0011:
	mov	p0, #0x03
	jb	step, $
	setb	step
	jnb	clockwise, state_0011_cw
state_0011_ac:
	jmp	state_0001
state_0011_cw:
	jmp	state_0010
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_0010:
	mov	p0, #0x02
	jb	step, $
	setb	step
	jnb	clockwise, state_0010_cw
state_0010_ac:
	jnb	half_step, state_0011
	jmp	state_0001
state_0010_cw:
	jnb	half_step, state_0110
	jmp	state_0100
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_0110:
	mov	p0, #0x06
	jb	step, $
	setb	step
	jnb	clockwise, state_0110_cw
state_0110_ac:
	jmp	state_0010
state_0110_cw:
	jmp	state_0100
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_0100:
	mov	p0, #0x04
	jb	step, $
	setb	step
	jnb	clockwise, state_0100_cw
state_0100_ac:
	jnb	half_step, state_0110
	jmp	state_0010
state_0100_cw:
	jnb	half_step, state_1100
	jmp	state_1000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_1100:
	mov	p0, #0x0c
	jb	step, $
	setb	step
	jnb	clockwise, state_1100_cw
state_1100_ac:
	jmp	state_0100
state_1100_cw:
	jmp	state_1000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_1000:
	mov	p0, #0x08
	jb	step, $
	setb	step
	jnb	clockwise, state_1000_cw
state_1000_ac:
	jnb	half_step, state_1100
	jmp	state_0100
state_1000_cw:
	jnb	half_step, state_1001
	jmp	state_0001
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state_1001:
	mov	p0, #0x09
	jb	step, $
	setb	step
	jnb	clockwise, state_1001_cw
state_1001_ac:
	jmp	state_1000
state_1001_cw:
	jmp	state_0001


;===============================================================
; interrupts
;===============================================================

it_external0:
	cpl	half_step
	cpl	p3.6
	reti

it_timer0:
	djnz	tx0, it_timer0_
	mov	tx0, a
	clr	step
	cpl        p3.4
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jb	decl, it_timer0_decl
	jb	accl, it_timer0_accl
	jmp	it_timer0_
it_timer0_decl:
	cjne	a, #tx0_max, it_timer0_nmax
	clr	decl
	cpl	clockwise
	jmp	it_timer0_
it_timer0_nmax:
	;rl	a
	inc	a
	jmp	it_timer0_
it_timer0_accl:
	cjne	a, #tx0_min, it_timer0_nmin
	clr	accl
	jmp	it_timer0_
it_timer0_nmin:
	;rr	a
	dec	a
	jmp	it_timer0_
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
it_timer0_:
	mov	th0, #th0_reload
	mov	tl0, #tl0_reload
	reti

it_external1:
	setb	decl
	setb	accl
	cpl	p3.7
	reti

	end
