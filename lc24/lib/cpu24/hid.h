#define HID_ADDR 0x480000
// todo: cpu24h?
U0 WriteWord(LC* lc, U32 addr, U16 val);
U0 move_mouse(LC* lc, U16 x, U16 y) {
  WriteWord(lc, HID_ADDR, x);
  WriteWord(lc, HID_ADDR + 2, y);
}
U0 mouse_btn(LC* lc, U8 id, U8 val) {
  U8 flag = lc->mem[HID_ADDR + 4];
  if (val) {
    flag |= 1 << id;
  } else {
    flag &= ~(1 << id);
  }
  lc->mem[HID_ADDR + 4] = flag;
}
// Keyboard is basically an api for USB-HID
// https://wiki.libsdl.org/SDL2/SDL_Scancode
#define MAX_KEYS 6
U0 kbd_btn(LC* lc, U16 id, U8 val) {
  if (val) {
    for (U8 i = 0; i < MAX_KEYS; i++) {
      if (lc->mem[HID_ADDR + 5 + i] == 0) {
        lc->mem[HID_ADDR + 5 + i] = id;
        return;
      }
    }
  } else {
    for (U8 i = 0; i < MAX_KEYS; i++) {
      if (lc->mem[HID_ADDR + 5 + i] == id) {
        lc->mem[HID_ADDR + 5 + i] = 0;
        return;
      }
    }
  }
}
U8 hid_events(LC* lc) {
  SDL_Event event;
  while (SDL_PollEvent(&event)) {
    switch(event.type) {
      case SDL_QUIT:
        return 1;
      case SDL_MOUSEMOTION:
        move_mouse(lc, event.motion.x / lc->gg.scale, event.motion.y / lc->gg.scale);
        break;
      case SDL_MOUSEBUTTONDOWN:
      case SDL_MOUSEBUTTONUP:
        mouse_btn(lc, event.button.button, event.type == SDL_MOUSEBUTTONDOWN);
        break;
      case SDL_KEYDOWN:
      case SDL_KEYUP:
        if (!event.key.repeat)
          kbd_btn(lc, event.key.keysym.scancode, event.type == SDL_KEYDOWN);
      break;
    }
  }
  return 0;
}
