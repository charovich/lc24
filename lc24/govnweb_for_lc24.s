    pop %ac
    cmp %ac $00
    jmne .zov
    mov %ac halting_problems
.zov:
    psh %ac
loader:
    ; Clear console (GC4PC)
    psh $1B int $2
    psh $5B int $2
    psh $48 int $2
    psh $1B int $2
    psh $5B int $2
    psh $32 int $2
    psh $4A int $2

    lda 0
    jsr cls
    ; Title
    lda 15
    ldt 28330
    ldi os_name
    jsr puts
    ; Random
    int $21
    ldt %dc
    div %dt 4
    cmp %dc 0
    jmne not_0
    ldi msg0
not_0:
    cmp %dc 1
    jmne not_1
    ldi msg1
not_1:
    cmp %dc 2
    jmne not_2
    ldi msg2
not_2:
    cmp %dc 3
    jmne not_3
    ldi msg3
not_3:
    lda 8
    ldt 30954
    jsr puts

    lda 15
    ldt 56440
    ldi ld0
    jsr puts
    int $11
    ldd 500
    int $22

    lda 15
    ldt 59160
    ldi ld1
    jsr puts
    int $11
    ldd 500
    int $22

    lda 15
    ldt 61880
    ldi ld2
    jsr puts
    int $11
    ldd 500
    int $22

    ;pop %ac
main:
    jsr paint_desktop
read_loop:
    int $1
    pop %ac
    cmp %ac 'w'
    jme move_w
    cmp %ac 's'
    jme move_s
    cmp %ac 'a'
    jme move_a
    cmp %ac 'd'
    jme move_d
    cmp %ac ' '
    jme click
    cmp %ac '/'
    jme show_chat_rules
    cmp %ac 'T'
    jme show_chat_rules
    cmp %ac 'q'
    jme quit
    jmp read_loop
halting_problems:
    psh 0
    int $00
move_w:
    lda *cursor_y
    cmp %ac 0
    jme read_loop
    dex %ac
    ldt cursor_y
    storb %ac
    jmp main

move_s:
    lda *cursor_y
    cmp %ac 88
    jme read_loop
    inx %ac
    ldt cursor_y
    storb %ac
    jmp main

move_a:
    lda *cursor_x
    cmp %ac 0
    jme read_loop
    dex %ac
    ldt cursor_x
    storb %ac
    jmp main

move_d:
    lda *cursor_x
    cmp %ac 163
    jme read_loop
    inx %ac
    ldt cursor_x
    storb %ac
    jmp main
click:
    jsr getpage
    ; B = Hitbox
    ldi %bs
    jsr hitbox
    cmp %cn 255
    jme read_loop
    ldt cur_page
    storb %cn
    jmp main

show_chat_rules:
    ldt cur_page
    ldc 2 ; /rules.txt
    storb %cn
    jmp main

quit:
    rts ; to GovnOS

paint_desktop:
    lda 15
    jsr cls

    jsr status_bar

    ldi win_name
    jsr win

    ldt 5440
    lda 0
    ldi url_name
    jsr puts
    lda 8
    ldi close_btn
    jsr puts

    lda 7
    ldb 284
    ldd 8
    jsr box

    ldt 8160
    ldi *cur_page
    cmp %di 0
    jme is_main

    ldi back_btn
    lda 0
    jsr spr
    sub %dt 2704
is_main:

    lda 0
    ldi url_base
    jsr puts

    jsr getpage
    ldi %ac
    lda 8
    jsr puts
    inx %di
    ldt 10880
    jsr page_render

    ; Cursor painting
    jsr getpage
    ldi %bs
    jsr hitbox
    cmp %cn 255
    ldi cursor
    jme unclickable
    ldi hand
unclickable:
    ldt *cursor_x
    mul %dt 2
    ldc *cursor_y
    mul %cn 680
    add %dt %cn

    lda 15
    jsr spr
    jsr spr
    sub %dt 5432
    jsr spr
    jsr spr
    sub %dt 5448
    lda 0
    jsr spr
    jsr spr
    sub %dt 5432
    jsr spr
    jsr spr

    int $11
rts
getpage: ; RET: A=Page B=Hitboxes
    lda *cur_page
    ldi gmlpages
    mul %ac 9
    add %di %ac
    jmp %di

hitbox: ; G = hitbox map
    ldt %di lodsb
    cmp %dt 255 jme hitbox_end
    ldc %dt

    lda *cursor_x
    inx %di ldt %di lodsb sub %ac %dt
    inx %di ldt %di lodsb div %ac %dt
    cmp %ac 0 jmne hitbox_sk3

    lda *cursor_y
    inx %di ldt %di lodsb sub %ac %dt
    inx %di ldt %di lodsb div %ac %dt
    cmp %ac 0 jmne hitbox_sk1
    rts
hitbox_sk3:
    add %di 2
hitbox_sk1:
    inx %di
    jmp hitbox
hitbox_end:
    ldc 255
    rts

cursor_x: bytes $55
cursor_y: bytes $2F

page_render:
    psh %di
    lodgb
    cmp %di 'T'
    jme page_title
    cmp %di 'V'
    jme page_vlist
    cmp %di 'M'
    jme page_menu
    cmp %di 'S'
    jme page_sep
    cmp %di 'H'
    jme page_header
    cmp %di 'P'
    jme page_par
    cmp %di 'R'
    jme page_table
    cmp %di 'B'
    jme page_endtable
    pop %di
rts
page_title:
    psh %dt
    lda 4
    ldb 340
    ldd 8
    jsr box
    pop %dt
    pop %di
    inx %di
    lda 15
    jsr puts
    inx %di
    jmp page_render
page_vlist:
    psh %dt
    lda 7
    ldb 340
    ldd 8
    jsr box
    pop %dt
    pop %di
    inx %di
    lda 0
    jsr puts
    inx %di
    jmp page_render
page_menu:
    psh %dt
    lda 7
    ldb 340
    ldd 8
    jsr box
    pop %dt
    pop %di
    inx %di
    lda 0
    jsr puts
    inx %di
    jmp page_render
page_sep:
    lda 0
    ldb 340
    ldd 1
    jsr box
    add %dt 340
    pop %di
    inx %di
    jmp page_render
page_header:
    pop %di
    inx %di
    lda 9
    jsr puts
    inx %di
    jmp page_render
page_par:
    pop %di
    inx %di
    lda 0
    jsr puts
    inx %di
    jmp page_render
page_endtable:
    pop %di
    inx %di
    psh %di
    lodgb
    ldb %di
    inx %bs
    mul %bs 8
    add %dt 1024
    lda 0
    ldd 1
    jsr box
    add %dt 340
    sub %dt 4

    pop %di
    inx %di
    jmp page_render

page_table:
    ; Get table width
    pop %di
    inx %di
    psh %di
    lodgb
    ldb %di
    inx %bs
    mul %bs 8
    psh %bs

    add %dt 684
    lda 0
    ;ldb 160
    ldd 1
    jsr box

    ; Get first col width
    pop %bs
    pop %di
    inx %di
    psh %di
    lodgb
    ldd %di
    inx %dc
    mul %dc 8
    dex %bs ; Prevent bug

    ldc 11
page_table_lcl:
    lda 0
    int $C
    add %dt %dc
    int $C
    sub %dt %dc
    add %dt %bs
    int $C
    sub %dt %bs
    add %dt 340
    loop page_table_lcl
    sub %dt 4080
    add %dt 4
    jmp page_par
win_name: bytes "GovnWeb^@"
url_name: bytes "Xi816 ^@"
close_btn: bytes "x^@"
url_base: bytes "xi816.github.io^@"
cur_page: bytes "^@"

status_bar:
    lda 0
    ldt 0
    ldb 340
    ldd 8
    jsr box
; First one
    ldt 0
    ldb 8
    ldd 8
    lda 6
    jsr box
    ldt 0
    lda 15
    ldi des1
    jsr puts
; Second
    ldt 8
    ldb 8
    ldd 8
    lda 8
    jsr box
    ldt 8
    lda 7
    ldi des2
    jsr puts
; Used memory
    lda prog_end
    add %ac 512
    div %ac 1024
    ldb 1
    ldt status_text
    jsr puti
; Date
    jsr gen_date
    ldt 172
    lda 15
    ldi status_text
    jsr puts
rts
gen_date:
    int $3 ; DX = Date
    ldi %dc ; Save

    lda %dc
    div %ac 31
    div %ac 12
    lda %dc
    inx %ac
    ldb 10
    ldt date
    jsr puti

    lda %di
    div %ac 31
    lda %dc
    inx %ac
    ldb 10
    ldt date_day
    jsr puti

    lda %di
    div %ac 372
    add %ac 1970
    ldb 1000
    ldt date_year
    jsr puti

rts


des1: bytes "1^@"
des2: bytes "2^@"
status_text: bytes "3KiB/64KiB|"
date: bytes "00-"
date_day: bytes "00-"
date_year: bytes "0000^@"

win: ; G - name
    ldt 2720 ; Second row
    ldb 340
    ldd 8
    lda 12
    jsr box
    ldt 2720
    lda 15
    jsr puts
rts

puti:
  ; A = Data
  ; B = Length (10 = 2 didits)
  ; S = buffer
  ; C, D = internal use
puti_loop:
  ldc %ac
  div %ac %bs
  div %ac 10
  add %dc $30

  storb %dc
  inx %dt

  lda %cn
  cmp %bs 1
  re
  div %bs 10
jmp puti_loop

puts: ; G: char
    psh %di
    lodgb
    cmp %di 0
    jme puts_end
    cmp %di 10
    jme puts_ln
    cmp %di 27
    jme puts_undr
    mul %di 8
    ldd font
    add %di %dc
    jsr spr
    sub %dt 2712
    pop %di
    inx %di
jmp puts
puts_ln:
    div %dt 340
    mul %dt 340
    add %dt 2720
    pop %di
    inx %di
jmp puts
puts_undr:
    ldi underline
    jsr spr
    sub %dt 2720
    pop %di
    inx %di
jmp puts
puts_end:
    pop %di
rts

; Gravno Display Interface 16
cls: ; A: color
    ldt 0
    ldc 64599
cls_loop:
    int $C
    inx %dt
    loop cls_loop
rts
box: ; A: color, B: width, D: height, S: start
    ldc %bs
    dex %cn
box_pix:
    int $C
    inx %dt
    loop box_pix
    sub %dt %bs
    add %dt 340
    dex %dc
    cmp %dc 0
    jmne box
rts

spr: ; A: color, G: sprite data
    ldb 8
spr_line:
    psh %di
    lodgb
    ldc 7
spr_pix:
    div %di 2
    cmp %dc 0
    jme spr_pix_next
    int $C
spr_pix_next:
    inx %dt
    loop spr_pix

    pop %di
    inx %di

    add %dt 332

    dex %bs
    cmp %bs 0
    jmne spr_line
rts


os_name: bytes "Linux for LC24^@"
ld0: bytes "Hostname: autist$^@"
ld1: bytes "Username: lost$^@"
ld2: bytes "Starting i3wm...$^@"
; funny messages
msg0: bytes "    Totally not an interrupt demo^@"
msg1: bytes "      Still better than Luxi3^@"
msg2: bytes "We aint dragding #FreeDiscord into 2025^@"
msg3: bytes "       XI816 >> X11 >> Wayland^@"

cursor: bytes $03 $07 $0F $1F $3F $7F $FF $FF $FF $FF $7F $F7 $F3 $E0 $E0 $C0 $00 $00 $00 $00 $00 $00 $00 $01 $03 $03 $00 $00 $00 $01 $01 $00 $00 $02 $06 $0E $1E $3E $7E $FE $FE $3E $36 $62 $60 $C0 $C0 $00 $00 $00 $00 $00 $00 $00 $00 $00 $01 $00 $00 $00 $00 $00 $00 $00
hand: bytes $FE $FF $FE $F8 $F0 $F8 $F0 $F8 $F0 $C0 $C0 $80 $00 $00 $00 $00 $01 $03 $07 $0F $0F $0F $1F $3F $7F $3F $1F $0F $07 $02 $00 $00 $00 $FE $80 $F0 $80 $F0 $80 $F0 $C0 $00 $80 $00 $00 $00 $00 $00 $00 $01 $03 $07 $07 $07 $0B $1D $3E $1F $0D $07 $02 $00 $00 $00

back_btn: bytes $08 $04 $02 $7F $02 $04 $08 $00

underline: bytes $00 $00 $00 $00 $00 $00 $00 $FF

font: bytes $00 $00 $00 $00 $00 $00 $00 $00 $07 $01 $57 $54 $77 $50 $50 $00 $07 $01 $57 $54 $27 $50 $50 $00 $07 $01 $53 $51 $27 $50 $50 $00 $07 $01 $73 $21 $27 $20 $20 $00 $07 $01 $73 $51 $57 $70 $20 $00 $07 $05 $57 $55 $35 $50 $50 $00 $03 $05 $13 $15 $13 $10 $70 $00 $03 $05 $73 $15 $73 $40 $70 $00 $05 $05 $77 $25 $25 $20 $20 $00 $01 $01 $71 $11 $37 $10 $10 $00 $05 $05 $75 $25 $22 $20 $20 $00 $07 $01 $73 $11 $31 $10 $10 $00 $07 $01 $71 $51 $77 $30 $50 $00 $07 $01 $77 $54 $57 $50 $70 $00 $07 $01 $77 $24 $27 $20 $70 $00 $03 $05 $15 $15 $13 $10 $70 $00 $03 $05 $25 $35 $23 $20 $70 $00 $03 $05 $75 $45 $73 $10 $70 $00 $03 $05 $75 $45 $63 $40 $70 $00 $03 $05 $55 $55 $73 $40 $40 $00 $07 $05 $55 $55 $35 $50 $50 $00 $07 $01 $57 $54 $77 $20 $20 $00 $07 $01 $33 $51 $37 $50 $30 $00 $07 $01 $71 $51 $57 $50 $50 $00 $07 $01 $53 $71 $57 $50 $50 $00 $3C $66 $66 $0C $18 $00 $18 $00 $07 $01 $73 $11 $17 $10 $70 $00 $07 $01 $73 $11 $71 $40 $70 $00 $07 $01 $75 $15 $77 $40 $70 $00 $07 $05 $77 $13 $75 $40 $70 $00 $05 $05 $75 $15 $77 $40 $70 $00 $00 $00 $00 $00 $00 $00 $00 $00 $08 $08 $08 $08 $00 $00 $08 $00 $24 $24 $24 $00 $00 $00 $00 $00 $24 $24 $7E $24 $7E $24 $24 $00 $08 $3C $0A $1C $28 $1E $08 $00 $00 $46 $26 $10 $08 $64 $62 $00 $0C $12 $12 $0C $52 $22 $5C $00 $10 $08 $04 $00 $00 $00 $00 $00 $10 $08 $04 $04 $04 $08 $10 $00 $04 $08 $10 $10 $10 $08 $04 $00 $08 $2A $1C $08 $1C $2A $08 $00 $00 $08 $08 $3E $08 $08 $00 $00 $00 $00 $00 $00 $00 $10 $10 $08 $00 $00 $00 $00 $3E $00 $00 $00 $00 $00 $00 $00 $00 $00 $08 $00 $40 $20 $10 $08 $04 $02 $01 $00 $1C $22 $32 $2A $26 $22 $1C $00 $08 $0C $0A $08 $08 $08 $3E $00 $1C $22 $20 $10 $0C $02 $3E $00 $1C $22 $20 $18 $20 $22 $1C $00 $10 $18 $14 $12 $3E $10 $10 $00 $3E $02 $1E $20 $20 $22 $1C $00 $38 $04 $02 $1E $22 $22 $1C $00 $3E $20 $10 $08 $04 $04 $04 $00 $1C $22 $22 $1C $22 $22 $1C $00 $1C $22 $22 $3C $20 $10 $0E $00 $00 $00 $08 $00 $00 $08 $00 $00 $00 $00 $08 $00 $00 $08 $08 $04 $10 $08 $04 $02 $04 $08 $10 $00 $00 $00 $3E $00 $3E $00 $00 $00 $04 $08 $10 $20 $10 $08 $04 $00 $3C $42 $20 $10 $10 $00 $10 $00 $3C $42 $52 $6A $32 $02 $3C $00 $18 $24 $42 $7E $42 $42 $42 $00 $3E $42 $42 $3E $42 $42 $3E $00 $3C $42 $02 $02 $02 $42 $3C $00 $1E $22 $42 $42 $42 $22 $1E $00 $7E $02 $02 $1E $02 $02 $7E $00 $7E $02 $02 $1E $02 $02 $02 $00 $3C $42 $02 $72 $42 $42 $3C $00 $42 $42 $42 $7E $42 $42 $42 $00 $1C $08 $08 $08 $08 $08 $1C $00 $20 $20 $20 $20 $20 $22 $1C $00 $42 $22 $12 $0E $12 $22 $42 $00 $02 $02 $02 $02 $02 $02 $7E $00 $42 $66 $5A $42 $42 $42 $42 $00 $42 $46 $4A $52 $62 $42 $42 $00 $3C $42 $42 $42 $42 $42 $3C $00 $3E $42 $42 $3E $02 $02 $02 $00 $3C $42 $42 $42 $52 $22 $5C $00 $3E $42 $42 $3E $12 $22 $42 $00 $3C $42 $02 $3C $40 $42 $3C $00 $3E $08 $08 $08 $08 $08 $08 $00 $42 $42 $42 $42 $42 $42 $3C $00 $42 $42 $42 $42 $42 $24 $18 $00 $42 $42 $42 $42 $5A $66 $42 $00 $42 $42 $24 $18 $24 $42 $42 $00 $22 $22 $22 $1C $08 $08 $08 $00 $3E $20 $10 $08 $04 $02 $3E $00 $1C $04 $04 $04 $04 $04 $1C $00 $01 $02 $04 $08 $10 $20 $40 $00 $1C $10 $10 $10 $10 $10 $1C $00 $08 $14 $22 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $3E $04 $08 $10 $00 $00 $00 $00 $00 $00 $00 $1C $20 $3C $22 $3C $00 $02 $02 $1E $22 $22 $22 $1E $00 $00 $00 $1C $22 $02 $22 $1C $00 $20 $20 $3C $22 $22 $22 $3C $00 $00 $00 $1C $22 $3E $02 $1C $00 $30 $48 $08 $3E $08 $08 $08 $00 $00 $00 $3C $22 $22 $3C $20 $1C $02 $02 $1E $22 $22 $22 $22 $00 $08 $00 $0C $08 $08 $08 $1C $00 $20 $00 $30 $20 $20 $20 $24 $18 $02 $02 $22 $12 $0E $12 $22 $00 $0C $08 $08 $08 $08 $08 $1C $00 $00 $00 $16 $2A $2A $2A $2A $00 $00 $00 $1E $22 $22 $22 $22 $00 $00 $00 $1C $22 $22 $22 $1C $00 $00 $00 $1E $22 $22 $1E $02 $02 $00 $00 $3C $22 $22 $3C $20 $20 $00 $00 $3A $06 $02 $02 $02 $00 $00 $00 $3C $02 $1C $20 $1E $00 $04 $04 $1E $04 $04 $24 $18 $00 $00 $00 $22 $22 $22 $22 $1C $00 $00 $00 $22 $22 $22 $14 $08 $00 $00 $00 $22 $2A $2A $2A $14 $00 $00 $00 $22 $14 $08 $14 $22 $00 $00 $00 $22 $22 $22 $3C $20 $1C $00 $00 $3E $10 $08 $04 $3E $00 $18 $04 $04 $02 $04 $04 $18 $00 $08 $08 $08 $08 $08 $08 $08 $08 $0C $10 $10 $20 $10 $10 $0C $00 $04 $2A $10 $00 $00 $00 $00 $00 $03 $05 $75 $25 $23 $20 $20 $00 $72 $65 $74 $75 $72 $6E $20 $72 $65 $74 $75 $72 $6E $28 $29 $20 $7B $0A $20 $20 $72 $65 $74 $75 $72 $6E $20 $72 $65 $74 $75 $72 $6E $20 $3D $20 $30 $3B $0A $20 $20 $72 $65 $74 $75 $72 $6E $20 $72 $65 $74 $75 $72 $6E $20 $3D $20 $30 $3B $0A $20 $20 $72 $65 $74 $75 $72 $6E $20 $72 $65 $74 $75 $72 $6E $20 $3D $20 $2A $72 $65 $74 $75 $72 $6E $3B $0A $0A $20 $20 $72 $65 $74 $75 $72 $6E $20 $30 $3B $0A $7D $00

gmlpages:
    lda gml_.page ldb gml_.hit rts
    lda gml_govnocore_16x.html.page ldb gml_govnocore_16x.html.hit rts
    lda gml_rules.txt.page ldb gml_rules.txt.hit rts
    lda gml_govnweb_readme.gml.page ldb gml_govnweb_readme.gml.hit rts
gml_.page: bytes "/^@T Govno Core processor resource$^@MDocs ^[G^[C^[1^[6^[X$^@SP  This website is about the Govno Core pro$^@Pcessor family.$^@P$^@V Full documentation list$^@P  ^[G^[o^[v^[n^[o^[ ^[C^[o^[r^[e^[ ^[1^[6^[X$^@E$^@P  "
;   ^[G^[o^[v^[n^[o^[ ^[C^[o^[r^[e^[ ^[2^[4$^@P  ^[G^[o^[v^[n^[o^[ ^[C^[o^[r^[e^[ ^[3^[2$^@P  ^[G^[o^[v^[n^[o^[ ^[C^[o^[r^[e^[ ^[3^[2^[-^[2^[0^[0^[2^[0$^@E$^@
gml_.hit: bytes $03 $00 $1C $04 $04 $01 $14 $14 $14 $04 $01 $08 $38 $29 $04 $FF
gml_govnocore_16x.html.page: bytes "/govnocore/16x.html^@T GovnoCore 16X$^@M^[B^[a^[c^[k ^[R^[e^[g^[i^[s^[t^[e^[r^[s ^[I^[n^[s^[t^[r^[u^[c^[t^[i^[o^[n^[s ^[P^[r^[e^[f^[i^[x^[e^[s ^[E^[x^[a^[m^[p$^@M^[l^[e^[s$^@SHRegisters$^@P  This section shows all Govno Core 16X re$^@Pgisters.$^@H General purpose registers$^@P  ^[G^[e^[n^[e^[r^[a^[l^[ ^[p^[u^[r^[p^[o^[s^[e^[ ^[r^[e^[g^[i^[s^[t^[e^[r^[s are 16-bit reg$^@Pisters that can be used to save data for u$^@Pser program purposes.$^@P  Also see ^[R^[e^[g^[i^[s^[t^[e^[r^[ ^[c^[l^[u^[s^[t^[e^[r$^@R^R^FNibble GP redister$^@R^R^F^$0     A/AX$^@R^R^F^$1     B/BX$^@R^R^F^$2     C/CX$^@R^R^F^$3     D/DX$^@R^R^F^$4     S/SI$^@E"
gml_govnocore_16x.html.hit: bytes $00 $00 $04 $0C $04 $03 $00 $1C $04 $04 $00 $00 $10 $14 $04 $01 $14 $24 $14 $04 $01 $3C $30 $14 $04 $01 $70 $20 $14 $04 $01 $94 $14 $14 $04 $01 $00 $0C $18 $04 $01 $08 $64 $2D $04 $01 $2C $40 $39 $04 $FF
gml_rules.txt.page: bytes "/rules.txt.gml^@P  - General$^@P    1. Bez politiki.$^@P    2. Bez porna.$^@P$^@P  - Nuzhnoe$^@P    3. Linuks luchshe.$^@P    4. Esli vy ne dumaete, chto linuks luc$^@Phshe, znachit vy ne pravy.$^@P    5. Esli u vas shrindus - vas budut pre$^@Pzirat' (ja lichno)$^@P$^@P  - Brauzery i poiskovye dtstemy$^@P    6. Nel'zja upominat' hujandeks.$^@P    7. Firefox luchshij brauzer.$^@P    8. GovnWeb luchshij brauzer.$^@P    9. Nel'zja upominat' gugl hujrom.$^@P    10. Chromium dopuskaetsja.$^@P    11. FuckFuckGo (sumasshedshaja utka) d$^@Popuskaetsja.$^@P    12. Esli vy otpravite skrinshot, nesoo$^@P$^@E"
gml_rules.txt.hit: bytes $00 $00 $04 $0C $04 $03 $00 $1C $04 $04 $FF
gml_govnweb_readme.gml.page: bytes "/govnweb/readme.gml^@T GovnWeb: the best browser$^@SHHow to use$^@P  Mouse: WASD to move, space to click$^@P  q to quit, / or T to open ^[r^[u^[l^[e^[s^[.^[t^[x^[t$^@HFAQ$^@R^$^WDoes it use the Wi-Fi?  No$^@R^$^WHow do I scroll?        You can't$^@R^$^WSkuf-cli on GC16X when? Wtf bro stop$^@R^$^WDolDoc-like 3D objects? Not yet$^@B^$P  Btw I'm not xi816, I'm the govnos.efi (w$^@Pill release on 02-02-2025) creator.$^@HFiles$^@R#^LGravnoGen.py Cursor generator$^@R#^Lgovnldoc.py  Document line-wrapper$^@R#^Lxi816.*.gml  xi816.github.io as GML$^@B#E"
gml_govnweb_readme.gml.hit: bytes $00 $00 $04 $0C $04 $03 $00 $1C $04 $04 $02 $70 $24 $1D $04 $FF

prog_end:
