// Header include file for lib/cpu/cpu16.h
#ifndef CPU16H_H
#define CPU16H_H 1

#define ROMSIZE 16777216 // Maximum for a 16-bit adress line
#define MEMSIZE 16777216 // Maximum for a 16-bit adress line

union lcreg {
//  U8 byte;
//  U16 word;
  U32 word : 24;
//  U32 dword;
//  U64 fword : 48;
};
typedef union lcreg lcreg;

// Register cluster
struct lcrc {
  lcbyte x;
  lcbyte y;
};
typedef struct lcrc lcrc_t;

/*
 * 8 Bits:
*Al,bl,cl,dl
*Ah,bh,ch,dh
*r0,r1,r2,r3
*r4,r5,r6,r7
*b8h-b31h
*b8l-b31l
 * 16 Bits:
*ac,bs,cn,dc,si,di,sp,bp
*ad,bt,co,da,sj,dj,sq,bq
*w8h-w31h
*w8l-w31l
 * 24 Bits:
*hac,hbs,hcn,hdc,hsi,hdi,hsp,hbp
*had,hbt,hco,hda,hsj,hdj,hsq,hbq
*h8h-h31h
*h8l-h31l
 * 32 Bits:
*eac,ebs,ecn,edc,esi,edi,esp,ebp
*ead,ebt,eco,eda,esj,edj,esq,ebq
*e8h-e31h
*e8l-e31l
 * 48 Bits:
*fac,fbs,fcn,fdc,fsi,fdi,fsp,fbp
*fad,fbt,fco,fda,fsj,fdj,fsq,fbq
*f8h-f31h
*f8l-f31l
 * PTMR:
* PRG0-PRG8192
*/

struct LC24 {
  lcreg reg[16];

  lcbyte PS;   // -I---ZNC                 Unaddressable
  uint32_t PC; // Program counter          Unaddressable

  // Memory and ROM
  lcbyte mem[MEMSIZE];
  lcbyte rom[ROMSIZE];
  lcbyte pin;

  // GPU
  lc_gg16 gg;
  SDL_Renderer* renderer;
};
typedef struct LC24 LC;

#endif
