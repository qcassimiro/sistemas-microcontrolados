;============================================================
; definitions
;============================================================

; sfr
ledcon	equ	0xf1
; p51
lcd_db	equ	p0
lcd_bf	equ	p0.7
lcd_rs	equ	p2.5
lcd_rw	equ	p2.6
lcd_e	equ	p2.7
led1	equ	p3.6
led2	equ	p3.7
; pinos
semG	equ	p3.6
semR	equ	p3.7
keyA	equ	p3.0
keyB	equ	p3.1
sen1	equ	p3.2
sen2	equ	p3.3
sen3	equ	p3.4
; registradores
lcd_data	equ	0x41
lcd_inst	equ	0x42
lcd_curs	equ	0x43
boxS	equ	0x04
boxM	equ	0x05
boxB	equ	0x06
boxT	equ	0x07
boxX	equ	0x00


;============================================================
; interruptions
;============================================================

	org	0x0000
	jmp	begin


;============================================================
; main
;============================================================

	org	0x007b
begin:
	call	lcd_begin
	mov	dptr, #string0
	call	lcd_send_string
	mov	lcd_inst, #0xc0
	call	lcd_send_instruction
	mov	dptr, #string1
	call	lcd_send_string
	mov	lcd_inst, #0xcc
	call	lcd_send_instruction
	mov	lcd_data, #0x30
	call	lcd_write_data
	mov	lcd_inst, #0x8c
	call	lcd_send_instruction
	mov	lcd_data, #0x30
	call	lcd_write_data
	;
	mov	lcd_data, #0x47
	mov	lcd_inst, #0x8c
	call	lcd_send_instruction
	call	lcd_write_data
	mov	lcd_data, #0x3d
	mov	lcd_inst, #0x8d
	call	lcd_send_instruction
	call	lcd_write_data
	mov	lcd_data, #0x20
	mov	lcd_inst, #0xcc
	call	lcd_send_instruction
	call	lcd_write_data
	;
	mov	ledcon, #0xa0

action0:
	mov	boxS, #0x30
	mov	boxM, #0x30
	mov	boxB, #0x30
	mov	boxT, #0x30
	mov	boxX, #0x00
	clr	semG
	setb	semR
	setb	keyA
	setb	keyB
	setb	sen1
	setb	sen2
	setb	sen3
	call	updateLCD
stateQ0:
	jnb	sen3, stateQ1
	jmp	stateQ0

action1:
stateQ1:
	jb	sen3, stateQ2
	jnb	sen2, action3
	jmp	stateQ1

action2:
stateQ2:
	jnb	sen2, stateQ4
	jmp	stateQ2

action3:
	mov	boxX, #boxB
stateQ3:
	jnb	sen1, stateQ5
	jmp	stateQ3

action4:
stateQ4:
	jb	sen2, action6
	jnb	sen1, action7
	jmp	stateQ4

action5:
stateQ5:
	jb	sen3, stateQ7
	jmp	stateQ5

action6:
	mov	boxX, #boxS
stateQ6:
	jnb	sen1, stateQ8
	jmp	stateQ6

action7:
	mov	boxX, #boxM
stateQ7:
	jb	sen2, stateQ8
	jmp	stateQ7

action8:
stateQ8:
	jb	sen1, action9
	jmp	stateQ8

action9:
	inc	@r0;(boxX)
	inc	boxT
	call	updateLCD
stateQ9:
	mov	a, boxT
	clr	c
	subb	a, #0x39
	jz	actionA
	jnb	keyA, actionA
	jmp	stateQ0

actionA:
	dec	@r0;(boxX)
	dec	boxT
	setb	semG
	clr	semR
	call	updateLCD
stateQA:
	jnb	keyB, action0
	jmp	stateQA

updateLCD:
	mov	lcd_data, boxS
	mov	lcd_inst, #0x84
	call	lcd_send_instruction
	call	lcd_write_data
	mov	lcd_data, boxM
	mov	lcd_inst, #0x89
	call	lcd_send_instruction
	call	lcd_write_data
	mov	lcd_data, boxB
	mov	lcd_inst, #0x8e
	call	lcd_send_instruction
	call	lcd_write_data
	mov	lcd_data, boxT
	mov	lcd_inst, #0xcb
	call	lcd_send_instruction
	call	lcd_write_data
	ret


;===============================================================
; lcd
;===============================================================

lcd_busy:
	clr	c
	setb	lcd_bf
	clr	lcd_rs
	setb	lcd_rw
lcd_busy_check:
	setb	lcd_e
	mov	c, lcd_bf
	clr	lcd_e
	jc	lcd_busy_check
	clr	lcd_rw
	ret

lcd_send_instruction:
	call	lcd_busy
	clr	lcd_rs
	clr	lcd_rw
	setb	lcd_e
	mov	lcd_db, lcd_inst
	clr	lcd_e
	ret

lcd_write_data:
	call	lcd_busy
	setb	lcd_rs
	clr	lcd_rw
	setb	lcd_e
	mov	lcd_db, lcd_data
	clr	lcd_e
	ret

lcd_read_data:
	call	lcd_busy
	setb	lcd_rs
	setb	lcd_rw
	setb	lcd_e
	mov	lcd_data, lcd_db
	clr	lcd_e
	ret

lcd_begin:
	mov	lcd_inst, #0x38
	call	lcd_send_instruction
	mov	lcd_inst, #0x0e
	call	lcd_send_instruction
	mov	lcd_inst, #0x01
	call	lcd_send_instruction
	mov	lcd_inst, #0x80
	call	lcd_send_instruction
	ret

lcd_send_string:
	mov	a, #0x00
	movc	a, @a+dptr
	jz	lcd_send_string_
	mov	lcd_data, a
	call	lcd_write_data
	inc	dptr
	jmp	lcd_send_string
lcd_send_string_:
	ret


;===============================================================
; db
;===============================================================

string0:
	db	'  P=0  M=0  G=0 ', 0x00
string1:
	db	'     TOTAL=0    ', 0x00

	end