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
; var
lcd_data	equ	0x41
lcd_inst	equ	0x42


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
	mov	ledcon, #0xa0
	clr	led1
	clr	led2
	jmp	$


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
	db	'    GRA :       ', 0x00
string1:
	db	'    PEQ :       ', 0x00

	end