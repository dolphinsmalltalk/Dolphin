/****************************************************************************
*																			*
*						  SHA Message Digest Algorithm 						*
*						Copyright Peter Gutmann 1992-1996					*
*																			*
****************************************************************************/

#include <string.h>
#include <windows.h>
#include "sha.h"

/* Bring in the SHA core code */

#define USE_SHA1
#include "shacore.c"

/****************************************************************************
*																			*
*								SHA Self-test Routines						*
*																			*
****************************************************************************/

/* Test the SHA output against the test vectors given in FIPS 180-1 and FIPS
   180 (the first three values are the SHA-1 results, the second three are
   the SHA results).

   We skip the third test since this takes several seconds to execute, which
   leads to an unacceptable delay in the library startup time */

static struct {
	char *data;						/* Data to hash */
	int length;						/* Length of data */
	BYTE digest[ SHA_DIGESTSIZE ];	/* Digest of data */
	} digestValues[] = {
	{ "abc", 3,
	  { 0xA9, 0x99, 0x3E, 0x36, 0x47, 0x06, 0x81, 0x6A,
		0xBA, 0x3E, 0x25, 0x71, 0x78, 0x50, 0xC2, 0x6C,
		0x9C, 0xD0, 0xD8, 0x9D } },
	{ "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 56,
	  { 0x84, 0x98, 0x3E, 0x44, 0x1C, 0x3B, 0xD2, 0x6E,
		0xBA, 0xAE, 0x4A, 0xA1, 0xF9, 0x51, 0x29, 0xE5,
		0xE5, 0x46, 0x70, 0xF1 } },
/*	{ "aaaaa...", 1000000L,
	  { 0x34, 0xAA, 0x97, 0x3C, 0xD4, 0xC4, 0xDA, 0xA4,
		0xF6, 0x1E, 0xEB, 0x2B, 0xDB, 0xAD, 0x27, 0x31,
		0x65, 0x34, 0x01, 0x6F } }, */
	{ "abc", 3,
	  { 0x01, 0x64, 0xB8, 0xA9, 0x14, 0xCD, 0x2A, 0x5E,
		0x74, 0xC4, 0xF7, 0xFF, 0x08, 0x2C, 0x4D, 0x97,
		0xF1, 0xED, 0xF8, 0x80 } },
	{ "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 56,
	  { 0xD2, 0x51, 0x6E, 0xE1, 0xAC, 0xFA, 0x5B, 0xAF,
		0x33, 0xDF, 0xC1, 0xC4, 0x71, 0xE4, 0x38, 0x44,
		0x9E, 0xF1, 0x34, 0xC8 } },
/*	{ "aaaaa...", 1000000L,
	  { 0x32, 0x32, 0xAF, 0xFA, 0x48, 0x62, 0x8A, 0x26,
		0x65, 0x3B, 0x5A, 0xAA, 0x44, 0x54, 0x1F, 0xD9,
		0x0D, 0x69, 0x06, 0x03 } }, */
	{ NULL, 0, { 0 } }
	};

#define mputBLong(memPtr,data)	\
		memPtr[ 0 ] = ( BYTE ) ( ( ( data ) >> 24 ) & 0xFF ); \
		memPtr[ 1 ] = ( BYTE ) ( ( ( data ) >> 16 ) & 0xFF ); \
		memPtr[ 2 ] = ( BYTE ) ( ( ( data ) >> 8 ) & 0xFF ); \
		memPtr[ 3 ] = ( BYTE ) ( ( data ) & 0xFF ); \
		memPtr += 4

int shaSelfTest( void )
	{
	SHA_INFO shaInfo;
	BYTE digest[ SHA_DIGESTSIZE ], *digestPtr;
	int i;

	/* Test SHA against the test vectors given in FIPS 181.*/
	shaInitial( &shaInfo );
	shaUpdate( &shaInfo, ( BYTE * ) digestValues[ 0 ].data,
			   digestValues[ 0 ].length );
	shaFinal( &shaInfo );
	digestPtr = digest;
	for( i = 0; i < SHA_DIGESTSIZE / 4; i++ )
		{
		mputBLong( digestPtr, shaInfo.digest[ i ] );
		}
	if( memcmp( digest, digestValues[ 0 ].digest, SHA_DIGESTSIZE ) )
		return( 0 );
	shaInitial( &shaInfo );
	shaUpdate( &shaInfo, ( BYTE * ) digestValues[ 1 ].data,
			   digestValues[ 1 ].length );
	shaFinal( &shaInfo );
	digestPtr = digest;
	for( i = 0; i < SHA_DIGESTSIZE / 4; i++ )
		{
		mputBLong( digestPtr, shaInfo.digest[ i ] );
		}
	if( memcmp( digest, digestValues[ 1 ].digest, SHA_DIGESTSIZE ) )
		return( 0 );

	return( 1 );
	}

__declspec( dllexport ) SHA_INFO* __cdecl SHACreate()
{
	SHA_INFO* handle=(SHA_INFO*)malloc(sizeof(SHA_INFO));
	shaInitial(handle);
	return handle;
}

__declspec( dllexport ) void __cdecl SHAHashBuffer(SHA_INFO* handle, BYTE* buffer, int count)
{
	shaUpdate(handle, buffer, count);
}

__declspec( dllexport ) void __cdecl SHAGetHash(SHA_INFO* handle, DWORD* digest)
{
	int i;
	shaFinal(handle);
	for (i=0; i<SHA_DIGESTSIZE/4; i++)
		digest[i]=handle->digest[i];
}

__declspec( dllexport ) void __cdecl SHADestroy(SHA_INFO* handle)
{
	free(handle);
}



