  jsr init
  pop %ac
rtloop:
  jsr frame
  pop %ac
  cmp %ac $0
  jmne .end
  inx *cur_frame
  lda *cur_frame
  cmp %ac 30
  jmne .in_second
  ldt cur_frame
  lda 0
  storb %ac
.in_second:
  ldt magic
  psh %dt
  jsr puts
  pop %ac
  ldd 32
  int $22
.iloop:
  int 1
  pop %ac
  cmp %ac $1B
  jme .eloop
  psh %ac
  jsr on_key
  pop %ac
  cmp %ac $0
  jme .iloop
.end:
  psh %ac
  int 0
.eloop:
  int 1
  pop %ac
  cmp %ac 'R'
  jmne .eloop
  jmp rtloop

puts:
  pop %bp
  pop %dt
.loop:
  cmp *%dt 0
  jme .end
  psh *%dt
  int 2
  inx %dt
  jmp .loop
.end:
  psh %dt
  psh %bp
  ret

rand:
  pop %bp
  int $21
  psh %dc
  psh %bp
ret

magic: bytes "^[[6n^@"
cur_frame: bytes $00
