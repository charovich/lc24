import lusl.std

buf = bytes(255)

def load():
    puts("Booting from LiveCD...\n"
         "Seek error 128, req = 0, at = -1\n"
         "unit 0, type 0, sectrac 18, blknum 17\n"
         "\x1b[33m386BSD Release 0.1 by Charloststovich.\x1b[0m [0.1.24  07/14/92 19:07]\n"
         "Copyright (c) 1989,1990,1991,1992 William F. Jolitz All rights reserved.\n"
         "Copyright (c) 2025 Charloststovich All rights reserved.\n"
         "Based in part on fork 386BSD User Community and the\n"
         "BSD Networking Software, Release 2 by UCN EECS Departament.\n"
         "pc0<color> at 0x60 irq 1 on isa\n"
         "com1 fifo at 0x3f8 irq 4 on isa\n"
         "com2 fifo at 0x2f8 irq 3 on isa\n"
         "wd0 <ST1102AT> at 0x1f0 irq 14 on isa\n"
         "fd0 drives 0: 1.2M at 0x3f0 irq 6 drq 2 on isa\n"
         "ne0 ethernet address fe:fd:de:ad:be:ef at 0x300 irq 9 on isa\n"
         "npx0 at 0xf0 irq 13 on isa\n"
         "changing root device to fd0a\n\n"
         "warning: no swap space present (yet)\n"
         "386BSD Distribution Installation Floppy (Tiny 386BSD) Release 0.1\n\n"
         "Please read the installation notes (type 'zmore INSTALL.NOTES')\n"
         "and registration information (type 'more REGISTRATION') before use.\n"
         "To install on hard disk drive, type 'install'.\n\n"
         "erase (ctrl)?, werase (ctrl)H, kill (ctrl)U, intr (ctrl)C\n")

def main():
    flag = 1
    load()
    date = "2038-01-19"
    time = 00
    minute = 00
    hour = 00
    while flag:
        prompt = "localhost\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
        time = time + 1
        puts(prompt)
        puts("# ")
        gets(buf)
        if time == 60:
            minute = minute + 1
            time = 0
        if minute == 60:
            minute = 0
            hour = hour + 1
        # if time == 07:
        #     puts("rm -rf / --no-preserve-root: removing /*\n"
        #          "rm -rf /dev --no-preserve-root: removing /dev... success\n"
        #          "rm -rf /usr --no-preserve-root: removing /usr... success\n"
        #          "rm -rf /bin --no-preserve-root: removing /bin... success\n"
        #          "rm -rf /etc --no-preserve-root: removing /etc... success\n"
        #          "rm -rf /root --no-preserve-root: removing /root... success\n")
        #     puts("Goodbye! system: breaked.\n")
        #     exit(0)
        if scmp(buf, "install"):
            puts("Sorry, but installing LC24BSD is not implemented now\nbecause fs driver is not done. You can try first sys ver in LiveCD\n")
        elif scmp(buf, "ps aux"):
            puts("root        0000 00 00 000000  0000 /dev/tty0  R 2038-01-19 00:00:00 ps aux\n")
            puts("root        0000 00 00 000000  0000 /dev/tty0  R 2038-01-19 03:14:07 rm -rf / --no-preserve-root\n")
        elif scmp(buf, "timedatectl"):
            puts("2038-01-19 ")
            puti(hour)
            puts(":")
            puti(minute)
            puts(":")
            puti(time)
            puts("\n")
        elif scmp(buf, "drive"):
            puts("Disk connected as # because fs is not done.\n")
        elif scmp(buf, "exit"):
            puts("Exiting with code 0...\n")
            exit(0)
        elif scmp(buf, "prompt"):
            puts("Write new prompt: ")
            gets(prompt)
        else:
            puts("ksh: ")
            puts(buf)
            puts(": command not found...\n")
            msleep(1000)
