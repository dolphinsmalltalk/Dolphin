/******************************************************************************

	File: STBlockInfo.h

	Description:

******************************************************************************/

typedef struct BlockInfo
{
	// Bottom bit of flags must be 1
	uint8_t isInteger;
	methodargcount_t argumentCount;		// Number of arguments expected
	stacktempcount_t stackTempsCount;	// Number of extra temp slots to allocate in the stack when activated
	envtempcount_t envTempsCount;		// Number of shared temps slots to allocate in heap context when activated
} BlockInfo;