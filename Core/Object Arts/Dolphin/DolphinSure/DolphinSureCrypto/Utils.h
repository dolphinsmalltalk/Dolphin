#ifndef _UTILS_DEFINED

#define _UTILS_DEFINED

#include <windows.h>

#define MASK32(x) x

#define LITTLE_ENDIAN

/* Functions to convert the endianness from the canonical form to the
   internal form.  bigToLittle() convert from big-endian in-memory to
   little-endian in-CPU, littleToBig() convert from little-endian in-memory
   to big-endian in-CPU */

void longReverse( DWORD *buffer, DWORD count );
void wordReverse( WORD *buffer, DWORD count );

#ifdef LITTLE_ENDIAN
  #define bigToLittleLong( x, y )	longReverse(x,y)
  #define bigToLittleWord( x, y )	wordReverse(x,y)
  #define littleToBigLong( x, y )
  #define littleToBigWord( x, y )
#else
  #define bigToLittleLong( x, y )
  #define bigToLittleWord( x, y )
  #define littleToBigLong( x, y )	longReverse(x,y)
  #define littleToBigWord( x, y )	wordReverse(x,y)
#endif /* LITTLE_ENDIAN */

#endif