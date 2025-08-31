#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define ptrlen(t) (sizeof(t)/sizeof(t[0]))

int32_t main(void) {
  char* color = "\033[32m";
  char* rcolor = "\033[0m";
  if (strcmp(getenv("TERM"), "xterm-256color")) {
    color = "\0";
    rcolor = "\0";
  }
  char* targets[] = {"lc24"};
  char* commands[] = {
    "gcc core/main.c -I/usr/pkg/include/SDL2 -Ilib -L/usr/pkg/lib -lSDL2 -lm -g -o lc24",
    // todo: ulostfs
  };

  printf("rebuilding %sball%s\n", color, rcolor);
  system("gcc core/ball.c -o ball");
  for (uint16_t i = 0; i < ptrlen(targets); i++) {
    printf("building %s%s%s\n", color, targets[i], rcolor);
    system(commands[i]);
  }
  return 0;
}
