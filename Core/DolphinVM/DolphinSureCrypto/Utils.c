#include "Utils.h"

/* Byte-reverse an array of 16- and 32-bit words to/from network byte order
   to account for processor endianness.  These routines assume the given
   count is a multiple of 16 or 32 bits.  They are safe even for CPU's with
   a word size > 32 bits since on a little-endian CPU the important 32 bits
   are stored first, so that by zeroizing the first 32 bits and oring the
   reversed value back in we don't need to rely on the processor only writing
   32 bits into memory */

void longReverse( DWORD *buffer, DWORD count )
	{
#if defined( _BIG_WORDS )
	BYTE *bufPtr = ( BYTE * ) buffer, temp;

	count /= 4;		/* sizeof( DWORD ) != 4 */
	while( count-- )
		{
  #if 0
		DWORD temp;

		/* This code is cursed */
		temp = value = *buffer & 0xFFFFFFFFUL;
		value = ( ( value & 0xFF00FF00UL ) >> 8  ) | \
				( ( value & 0x00FF00FFUL ) << 8 );
		value = ( ( value << 16 ) | ( value >> 16 ) ) ^ temp;
		*buffer ^= value;
		buffer = ( DWORD * ) ( ( BYTE * ) buffer + 4 );
  #endif /* 0 */
		/* There's really no nice way to do this - the above code generates
		   misaligned accesses on processors with a word size > 32 bits, so
		   we have to work at the byte level (either that or turn misaligned
		   access warnings off by trapping the signal the access corresponds
		   to.  However a context switch per memory access is probably
		   somewhat slower than the current byte-twiddling mess) */
		temp = bufPtr[ 3 ];
		bufPtr[ 3 ] = bufPtr[ 0 ];
		bufPtr[ 0 ] = temp;
		temp = bufPtr[ 2 ];
		bufPtr[ 2 ] = bufPtr[ 1 ];
		bufPtr[ 1 ] = temp;
		bufPtr += 4;
		}
#elif defined( __WIN32__ )
	/* The following code which makes use of bswap is significantly faster
	   than what the compiler would otherwise generate.  This code is used
	   such a lot that it's worth the effort */
__asm {
	mov ecx, count
	mov edx, buffer
	shr ecx, 2
swapLoop:
	mov eax, [edx]
	bswap eax
	mov [edx], eax
	add edx, 4
	dec ecx
	jnz swapLoop
	}
#else
	DWORD value;

	count /= sizeof( DWORD );
	while( count-- )
		{
		value = *buffer;
		value = ( ( value & 0xFF00FF00UL ) >> 8  ) | \
				( ( value & 0x00FF00FFUL ) << 8 );
		*buffer++ = ( value << 16 ) | ( value >> 16 );
		}
#endif /* _BIG_WORDS */
	}

void wordReverse( WORD *buffer, DWORD count )
	{
	WORD value;

	count /= sizeof( WORD );
	while( count-- )
		{
		value = *buffer;
		*buffer++ = ( value << 8 ) | ( value >> 8 );
		}
	}
