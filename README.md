# lc24
\n\n
Lc24 is a emulator for Lost Core 24 cpu.\n
lib/ - C Libs for lc24 code.\n
core/ - Main file and Build script\n
lusl/ - The lost universal script language.\n
lusl/run.sh - Script for fast run programms. Example: ./run.sh run -g -v 2 lost95\n
govnweb_for_lc24.s - Assembly code of GovnWeb for LC24\n
asm/las - Assembly, Suppots flags -xi(changes reg names to ax bx cx dx si gi and lda ldb ldc ldd lds ldg) and -ilas(eax,ebx,ecx,edx,esi,egi)\n
lusl/progs - Just lusl programms\n
lusl/compiler2.py - Compiler for lusl\n
core/ball.c - Build script, supports flags install(installs to $PATH) and clean\n
rcc2/ - The rcc2 compiler ported for lc24\n
\n
Compile:\n
./ball\n
./ball install\n
./ball clean\n
las govnweb_for_lc24.s govnweb_for_lc24.b\n
lc24 govnweb_for_lc24.b\n

Lc24 - Is fork GC16X but remaked.\n

