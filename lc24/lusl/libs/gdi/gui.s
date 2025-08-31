vputs: ; (x,y,c,t)
    pop %bp
    pop %di
    pop %ac
    pop %dc
    pop %dt
    mul %dc 340
    add %dt %dc
    jsr vputs-
    psh %dc
    psh %bp
ret

cls: ; (c)
    pop %bp
    pop %ac
    jsr cls-
    psh 0
    psh %bp
ret

box: ; (x,y,w,h,c)
    pop %bp
    pop %ac
    pop %dc
    pop %bs
    pop %cn
    pop %dt
    mul %cn 340
    add %dt %cn
    jsr box-
    psh 0
    psh %bp
ret
vflush:
    pop %bp
    int $11
    psh 0
    psh %bp
ret

spr: ; (x, y, c, data)
    pop %bp
    pop %di
    pop %ac
    pop %dt
    pop %dc
    mul %dt 340
    add %dt %dc
    jsr spr-
    psh 0
    psh %bp
ret

vputs-: ; G: char
    psh %dt
.line:
    psh %di
    lodgb
    cmp %di 0
    jme .end
    cmp %di 10
    jme .ln
    cmp %di 27
    jme .undr
    cmp %di $D0
    jme .gu8_d0
    cmp %di $D1
    jme .gu8_d1
    sub %di $20
.pchar:
    mul %di 9
    ldd res.font
    add %di %dc
    jsr spr-
    ldd *%di
    sub %dt 2720
    ;add %dt %dc
    add %dt 6
    pop %di
    inx %di
jmp .line
.gu8_d0:
    pop %di
    inx %di
    psh %di
    lodgb
    sub %di $20
jmp .pchar
.gu8_d1:
    pop %di
    inx %di
    psh %di
    lodgb
    add %di $20 ; $40 - $20
jmp .pchar
.ln:
    pop %di
    pop %dt
    add %dt 2720
    inx %di
jmp vputs-
.undr:
    ldi res.underline
    jsr spr-
    sub %dt 2720
    pop %di
    inx %di
jmp .line
.end:
    pop %di
    ldd %dt
    pop %dt
ret

; Gravno Display Interface 16
cls-: ; A: color
    ldt 0
    ldc 64599
.loop:
    int $C
    inx %dt
    loop .loop
ret
box-: ; A: color, B: width, D: height, S: start
    ldc %bs
    dex %cn
.pix:
    int $C
    inx %dt
    loop .pix
    sub %dt %bs
    add %dt 340
    dex %dc
    cmp %dc 0
    jmne box-
ret

spr-: ; A: color, G: sprite data
    ldb 8
.line:
    psh %di
    lodgb
    ldc 7
.pix:
    div %di 2
    cmp %dc 0
    jme .pix_next
    int $C
    ;inx %dt
    ;int $C
    ;dex %dt
.pix_next:
    inx %dt
    loop .pix

    pop %di
    inx %di

    add %dt 332

    dex %bs
    cmp %bs 0
    jmne .line
ret
