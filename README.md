# lc24

Lc24 is a emulator for Lost Core 24 cpu.
lib/ - C Libs for lc24 code.
core/ - Main file and Build script
lusl/ - The lost universal script language.
lusl/run.sh - Script for fast run programms. Example: ./run.sh run -g -v 2 lost95
govnweb_for_lc24.s - Assembly code of GovnWeb for LC24
asm/las - Assembly, Suppots flags -xi(changes reg names to ax bx cx dx si gi and lda ldb ldc ldd lds ldg) and -ilas(eax,ebx,ecx,edx,esi,egi)
lusl/progs - Just lusl programms
lusl/compiler2.py - Compiler for lusl
core/ball.c - Build script, supports flags install(installs to $PATH) and clean
rcc2/ - The rcc2 compiler ported for lc24

Compile:
./ball
./ball install
./ball clean
las govnweb_for_lc24.s govnweb_for_lc24.b
lc24 govnweb_for_lc24.b

Lc24 - Is fork GC16X but remaked.

