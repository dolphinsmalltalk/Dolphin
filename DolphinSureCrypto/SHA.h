#ifndef _SHA_DEFINED

#define _SHA_DEFINED

/* The SHS block size and message digest sizes, in bytes */

#include "Utils.h"

#define SHA_DATASIZE	64
#define SHA_DIGESTSIZE	20

/* The structure for storing SHA info */

typedef struct {
			   DWORD digest[ 5 ];			/* Message digest */
			   DWORD countLo, countHi;		/* 64-bit bit count */
			   DWORD data[ 16 ];				/* SHS data buffer */
#ifdef _BIG_WORDS
			   BYTE dataBuffer[ SHA_DATASIZE ];	/* Byte buffer for data */
#endif /* _BIG_WORDS */
			   BOOLEAN done;				/* Whether final digest present */
			   BOOLEAN isSHA;				/* Whether to use SHA */
			   } SHA_INFO;

/* Message digest functions */

void shaInitial( SHA_INFO *shaInfo );
void shaUpdate( SHA_INFO *shaInfo, BYTE *buffer, DWORD count );
void shaFinal( SHA_INFO *shaInfo );
void sha1Initial( SHA_INFO *shaInfo );
void sha1Update( SHA_INFO *shaInfo, BYTE *buffer, DWORD count );
void sha1Final( SHA_INFO *shaInfo );

#endif /* _SHA_DEFINED */
