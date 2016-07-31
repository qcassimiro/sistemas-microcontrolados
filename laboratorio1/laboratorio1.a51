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
;hdw
key_a	equ	p3.0
key_b	equ	p3.1
sen_1	equ	p3.2
sen_2	equ	p3.3
buzzer	equ	p2.0
led_a1	equ	p3.4
led_a2	equ	p3.5
led_b1	equ	p3.6
led_b2	equ	p3.7
; var
large	equ	0x44
small	equ	0x45
lcd_data	equ	0x41
lcd_inst	equ	0x42
lcd_curs	equ	0x43


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
	mov	ledcon, #0xa0
	mov	large, #0x00
	mov	small, #0x00

system_reset:
	jnb	key_a, a2b_start
	setb	led_a1
	clr	led_a2
	clr	led_b1
	setb	led_b2
	setb	buzzer
	jmp	system_reset

system_idle:
	jnb	key_a, a2b_start
	jnb	key_b, b2a_start
	jmp	system_idle

a2b_start:
	setb	led_a1
	clr	led_a2
	clr	led_b1
	setb	led_b2
	jb	sen_1, $
	jmp	a2b_measure

a2b_measure:
	jb	sen_1, a2b_small
	jnb	sen_2, a2b_large
	jmp	a2b_measure

a2b_small:
	mov	a, small
	inc	a
	cjne	a, #0x0a, a2b_small_ok
	mov	a, #0x09
a2b_small_ok:
	mov	small, a
	add	a, #0x30
	mov	lcd_data, a
	mov	lcd_inst, #0xcc
	jb	sen_2, $
	jmp	a2d_wait_finish

a2b_large:
	mov	a, large
	inc	a
	cjne	a, #0x0a, a2b_large_ok
	mov	a, #0x09
a2b_large_ok:
	mov	large, a
	add	a, #0x30
	mov	lcd_data, a
	mov	lcd_inst, #0x8c
	jnb	sen_1, $
	jmp	a2d_wait_finish

a2d_wait_finish:
	jnb	sen_2, $
	call	lcd_send_instruction
	call	lcd_write_data
	setb	led_a1
	clr	led_a2
	setb	led_b1
	clr	led_b2
	setb	buzzer
	clr	c
	mov	a, small
	add	a, large
	add	a, #0xee
	cpl	c
	mov	buzzer, c
	jmp	system_idle

b2a_start:
	clr	led_a1
	setb	led_a2
	setb	led_b1
	clr	led_b2
	jb	sen_2, $
	jmp	b2a_measure

b2a_measure:
	jb	sen_2, b2a_small
	jnb	sen_1, b2a_large
	jmp	b2a_measure

b2a_small:
	mov	a, small
	dec	a
	cjne	a, #0xff, b2a_small_ok
	mov	a, #0x00
b2a_small_ok:
	mov	small, a
	add	a, #0x30
	mov	lcd_data, a
	mov	lcd_inst, #0xcc
	jb	sen_1, $
	jmp	b2a_wait_finish

b2a_large:
	mov	a, large
	dec	a
	cjne	a, #0xff, b2a_large_ok
	mov	a, #0x00
b2a_large_ok:
	mov	large, a
	add	a, #0x30
	mov	lcd_data, a
	mov	lcd_inst, #0x8c
	jnb	sen_2, $
	jmp	b2a_wait_finish

b2a_wait_finish:
	jnb	sen_1, $
	call	lcd_send_instruction
	call	lcd_write_data
	setb	led_a1
	clr	led_a2
	setb	led_b1
	clr	led_b2
	setb	buzzer
	jmp	system_idle


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
	db	'    GRA  :', 0x00
string1:
	db	'    PEQ  :', 0x00

	end