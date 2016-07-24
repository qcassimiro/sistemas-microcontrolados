	org	0x0000
	mov	r0, #0x12
	movx	a, @r0
	mov	r3, a
	mov	r1, #0x11
	movx	a, @r1
	mov	r2, a
	mov	r0, #0x10
	movx	a, @r0
	cjne	r3, #0x7f, cmp
sub:	subb	a, r2
	jmp	nxt
cmp:	jc	sub
sum:	add	a, r2
nxt:	movx	@r1, a
	movx	@r0, a
	end