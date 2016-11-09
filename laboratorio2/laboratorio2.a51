;============================================================
; definitions
;============================================================

; sfr
ledcon	data	0xf1
; p51
lcd_db	data	p0
lcd_bf	bit	p0.7
lcd_rs	bit	p2.5
lcd_rw	bit	p2.6
lcd_e	bit	p2.7
led1	bit	p3.6
led2	bit	p3.7
; hdw
key_a	bit	p3.0
key_b	bit	p3.1
motor	bit	p2.0
; var
lcd_data	data	0x41
lcd_inst	data	0x42
lcd_curs	data	0x43
tx0	data	0x44
tx0_reload	equ	0x05
th0_reload	equ	0x3c
tl0_reload	equ	0xb0
tx1	data	0x45
tx1_reload	equ	0x0a
th1_reload	equ	0xfe
tl1_reload	equ	0x70
duty_cycle	data	0x46
dc_counter	data	0x47
slot_count	equ	0x48
revo_count	equ	0x49
updt_disp	bit	p2.1


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

	org	0x001b
	jmp	it_timer1


;============================================================
; main
;============================================================

	org	0x007b
it_reset:
	mov	duty_cycle, #0x03
	mov	dc_counter, duty_cycle
	mov	slot_count, #0x08
	mov	revo_count, #0x30
	mov	tmod, #0x11
	mov	tx1, #tx1_reload
	mov	th1, #th1_reload
	mov	tl1, #tl1_reload
	mov	th0, #th0_reload
	mov	tl0, #tl0_reload
	setb	it0
	setb	ex0
	setb	et0
	setb	et1
	setb	ea
	setb	tr1
	setb	tr0
	call	lcd_begin
	mov	lcd_inst, #0x80
	call	lcd_send_instruction
	mov	dptr, #string_0
	call	lcd_send_string
	mov	lcd_inst, #0xc0
	call	lcd_send_instruction
	mov	dptr, #string_1
	call	lcd_send_string
	mov	lcd_inst, #0x85
	call	lcd_send_instruction
	mov	lcd_data, #0x30
	call	lcd_write_data
	setb	key_a
	setb	key_b
	setb	updt_disp
loop:
	jnb	key_a, key_a_action
	jnb	key_b, key_b_action
	jnb	updt_disp, updt_disp_action
	jmp	loop

key_a_action:
	mov	a, duty_cycle
	cjne	a, #0x03, key_a_action_dec
	jnb	key_a, $
	jmp	loop
key_a_action_dec:
	dec	duty_cycle
	jnb	key_a, $
	jmp	loop

key_b_action:
	mov	a, duty_cycle
	cjne	a, #0x0a, key_b_action_inc
	jnb	key_b, $
	jmp	loop
key_b_action_inc:
	inc	duty_cycle
	jnb	key_b, $
	jmp	loop

updt_disp_action:
	mov	lcd_inst, #0x8f
	call	lcd_send_instruction
	mov	lcd_data, revo_count
	call	lcd_write_data
	setb	updt_disp
	mov	revo_count, #0x30
	jmp	loop


;===============================================================
; interrupts
;===============================================================

it_external0:
	djnz	slot_count, it_external0_
	inc	revo_count
	mov	slot_count, #0x08
it_external0_:
	reti

it_timer0:
	djnz	tx0, it_timer1_end
	clr	updt_disp
	mov	tx0, #tx0_reload
it_timer0_end:
	mov	th0, #th0_reload
	mov	tl0, #tl0_reload
	reti

it_external1:
	reti

it_timer1:
	djnz	dc_counter, it_timer1_continue
	cpl	motor
it_timer1_continue:
	djnz	tx1, it_timer1_end
	cpl	motor
	mov	dc_counter, duty_cycle
	mov	tx1, #tx1_reload
it_timer1_end:
	mov	th1, #th1_reload
	mov	tl1, #tl1_reload
	reti


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

string_0:
	db	'Rotacoes/45ms:  ', 0x00
string_1:
	db	'                ', 0x00

	end