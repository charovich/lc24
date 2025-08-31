#include <NetBSD/main.h>
#include <NetBSD/init.c>

U8 buf[64];

U8 main() {
    init();

    while (1) {
        puts("# ");
        gets(buf);
        if (strcmp(buf, "help")) {
            puts("Wait.\n");
        } else if (strcmp(buf, "exit")) {
            exit();
        }
    }
}
