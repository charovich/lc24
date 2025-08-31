U8 init_devices() {
    puts("init: devices:     [0xDEADBEEF] Initializating devices....\n");
    puts("init: devices:     [0xDEADD000] Device 1: PS/2 Mouse initializated!\n");
    puts("init: devices:     [0xDEADEEEF] Device 2: PS/2 Keyboard initializated\n");
    puts("init: devices:     [0xDEADFFFF] Error! Drivers is not installed. Exiting...\n\n");
}

U8 init_datetime() {
    puts("init: datetime:    [0x80000000] Unixtime v1.0\n");
    puts("init: datetime:    [0x80000001] Date: 2038-01-19\n");
    puts("init: datetime:    [0x80000001] Time: 00:00:01\n");
    puts("init: datetime:    [0x80000003] Init datetime done.\n\n");
}

U8 init_syscalls() {
    puts("init: syscalls:    [0x70000430] Setting up syscalls.\n");
    puts("init: syscalls:    [0x70000430] $80:$0 - Syscall.\n");
    puts("init: syscalls:    [0x70000431] $80:$1 - Exit.\n");
    puts("init: syscalls:    [0x70000432] $80:$2 - UNK.\n");
    puts("init: syscalls:    [0x70000433] $80:$3 - UNK.\n");
    puts("init: syscalls:    [0x70000434] $80:$4 - Write.\n");
    puts("init: syscalls:    [0x700004EF] Syscalls setted up!\n\n");
}

U8 init() {
    puts("\x1b[32minit:              [0x00000000] NetBSD 0.8 Rewrite for LC24.\n");
    puts("init: WARNING      [0x00000000] This is test LIVEcd version! this is not official port!!\n\n");
    init_devices();
    init_datetime();
    init_syscalls();
    puts("init:              [0x00000000] Init done! Going to livecd...\x1b[0m\n");
}
