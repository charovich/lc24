#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define ptrlen(t) (sizeof(t)/sizeof(t[0]))

int32_t main(int argc, char** argv) {
  char* color = "\033[32m";
  char* rcolor = "\033[0m";

  char com[128];
  char* term = getenv("TERM");
  char* cc = getenv("CC");
  char* cflags = getenv("CFLAGS");
  if (!cc)     cc = "gcc";
  if (!cflags) cflags = "-Wall -std=gnu89 -g";

  if (strcmp(term, "xterm-256color") && strcmp(term, "xterm") && strcmp(term, "linux")) {
    color = "\0";
    rcolor = "\0";
  }
  char* targets[]         = {"lc24"};
  char* install_targets[] = {"lc24", "las"};
  char* build_commands[] = {
    "gcc core/main.c -I/usr/pkg/include/SDL2 -Ilib -L/usr/pkg/lib -lSDL2 -lm -g -o lc24",
  };
  char* install_commands[] = {
    "sudo install lc24 /usr/local/bin/",
    "sudo install asm/las /usr/local/bin/"
  };
  char* clean_commands[] = {
    "rm -f lc24",
  };

  if (argc == 1) {
    printf("rebuilding %sball%s\n", color, rcolor);
    system("gcc core/ball.c -o ball");
    for (uint16_t i = 0; i < ptrlen(targets); i++) {
      printf("building %s%s%s\n", color, targets[i], rcolor);
      fflush(stdout);
      sprintf(com, build_commands[i], cc, cflags);
      system(com);
    }
    return 0;
  }
  else if ((argc == 2) && (!strcmp(argv[1], "install"))) {
    for (uint16_t i = 0; i < ptrlen(install_targets); i++) {
      printf("installing %s%s%s\n", color, install_targets[i], rcolor);
      system(install_commands[i]);
    }
    puts("done!");
    return 0;
  }
  else if ((argc == 2) && (!strcmp(argv[1], "clean"))) {
    for (uint16_t i = 0; i < ptrlen(targets); i++) {
      printf("removing %s%s%s\n", color, targets[i], rcolor);
      system(clean_commands[i]);
    }
    puts("removing .bin files...");
    system("find . -name \"*.bin\" -type f  | xargs rm -f");
    puts("removing .exp files...");
    system("find . -name \"*.exp\" -type f | xargs rm -f");
    puts("done!");
    return 0;
  }
  else {
    printf("ball: unknown argument `%s`\n", argv[1]);
  }
  return 0;
}

