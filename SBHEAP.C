// This is the Small Block heap from VC6
// The reason for linking it in statically is to avoid the overhead
// of the critical section locks (Dolphin is not multi-threaded at this level)

/***
*sbheap.c -  Small-block heap code
*
*       Copyright (c) Microsoft Corporation. All rights reserved.
*
*Purpose:
*       Core code for small-block heap.
*
*******************************************************************************/

#include "segdefs.h"
#pragma code_seg(MEM_SEG)

#undef _CRTBLD
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "sbheap.h"

#define _CRTBLD
#include "winheap.h"
#include <windows.h>
/*
#include <internal.h>
#include <malloc.h>
*/
#include <errno.h>
#include <limits.h>

size_t       __sbh_threshold;

PHEADER      __sbh_pHeaderList;        //  pointer to list start
PHEADER      __sbh_pHeaderScan;        //  pointer to list rover
int          __sbh_sizeHeaderList;     //  allocated size of list
int          __sbh_cntHeaderList;      //  count of entries defined

PHEADER      __sbh_pHeaderDefer=NULL;
int          __sbh_indGroupDefer;

/************************ BEGIN BSM MODIFICATION ******************************/
// BSM wants to use stdcall rather than cdecl because it is typically faster
#define __cdecl __stdcall
/************************ END BSM MODIFICATION ********************************/

/* Prototypes for user functions */
size_t __cdecl _get_sbh_threshold(void);
int    __cdecl _set_sbh_threshold(size_t);

void DumpEntry(char *, int *);

/***
*size_t _get_sbh_threshold() - return small-block threshold
*
*Purpose:
*       Return the current value of __sbh_threshold
*
*Entry:
*       None.
*
*Exit:
*       See above.
*
*Exceptions:
*
*******************************************************************************/

size_t __cdecl _get_sbh_threshold (void)
{
    /* Ensure already initialised */
    if(!_crtheap)
    {
        return 0;
    }
	return __sbh_threshold;
}

/***
*int _set_sbh_threshold(threshold) - set small-block heap threshold
*
*Purpose:
*       Set the upper limit for the size of an allocation which will be
*       supported from the small-block heap.
*
*Entry:
*       size_t threshold - proposed new value for __sbh_theshold
*
*Exit:
*       Returns 1 if successful. Returns 0 if threshold was invalid.
*
*Exceptions:
*       Input parameters are validated. Refer to the validation section of the function.
*
*******************************************************************************/

int __cdecl _set_sbh_threshold (size_t threshold)
{
	if(!_crtheap)
	{
		return 0;
	}

	//  test against maximum value - if too large, return error
	if (threshold > MAX_ALLOC_DATA_SIZE)
	{
		errno = EINVAL;
		return 0;
	}
	__sbh_threshold = threshold;
	return 1;
}

/***
*int __sbh_heap_init() - set small-block heap threshold
*
*Purpose:
*       Allocate space for initial header list and init variables.
*
*Entry:
*       None.
*
*Exit:
*       Returns 1 if successful. Returns 0 if initialization failed.
*
*Exceptions:
*
*******************************************************************************/
int __cdecl __sbh_heap_init (size_t threshold)
{
    if (!(__sbh_pHeaderList = HeapAlloc(_crtheap, 0, 16 * sizeof(HEADER))))
        return FALSE;

	__sbh_threshold = threshold;
    __sbh_pHeaderScan = __sbh_pHeaderList;
    __sbh_pHeaderDefer = NULL;
    __sbh_cntHeaderList = 0;
    __sbh_sizeHeaderList = 16;

    return TRUE;
}

/***
*PHEADER *__sbh_find_block(pvAlloc) - find block in small-block heap
*
*Purpose:
*       Determine if the specified allocation block lies in the small-block
*       heap and, if so, return the header to be used for the block.
*
*Entry:
*       void * pvBlock - pointer to block to be freed
*
*Exit:
*       If successful, a pointer to the header to use is returned.
*       If unsuccessful, NULL is returned.
*
*Exceptions:
*
*******************************************************************************/

PHEADER __cdecl __sbh_find_block (void * pvAlloc)
{
    PHEADER         pHeaderLast = __sbh_pHeaderList + __sbh_cntHeaderList;
    PHEADER         pHeader;
    unsigned int    offRegion;

    //  scan through the header list to determine if entry
    //  is in the region heap data reserved address space
    pHeader = __sbh_pHeaderList;
    while (pHeader < pHeaderLast)
    {
        offRegion = (unsigned int)((uintptr_t)pvAlloc - (uintptr_t)pHeader->pHeapData);
        if (offRegion < BYTES_PER_REGION)
            return pHeader;
        pHeader++;
    }
    return NULL;
}

#ifdef _DEBUG

/***
*int __sbh_verify_block(pHeader, pvAlloc) - verify pointer in sbh
*
*Purpose:
*       Test if pointer is valid within the heap header given.
*
*Entry:
*       pHeader - pointer to HEADER where entry should be
*       pvAlloc - pointer to test validity of
*
*Exit:
*       Returns 1 if pointer is valid, else 0.
*
*Exceptions:
*
*******************************************************************************/

int __cdecl __sbh_verify_block (PHEADER pHeader, void * pvAlloc)
{
    unsigned int    indGroup;
    unsigned int    offRegion;

    //  calculate region offset to determine the group index
    offRegion = (unsigned int)((uintptr_t)pvAlloc - (uintptr_t)pHeader->pHeapData);
    indGroup = offRegion / BYTES_PER_GROUP;

    //  return TRUE if:
    //      group is committed (bit in vector cleared) AND
    //      pointer is at paragraph boundary AND
    //      pointer is not at start of page
    return (!(pHeader->bitvCommit & (0x80000000UL >> indGroup))) &&
           (!(offRegion & 0xf)) &&
           (offRegion & (BYTES_PER_PAGE - 1));
}

#endif  /* _DEBUG */

/***
*void __sbh_free_block(preg, ppage, pmap) - free block
*
*Purpose:
*       Free the specified block from the small-block heap.
*
*Entry:
*       pHeader - pointer to HEADER of region to free memory
*       pvAlloc - pointer to memory to free
*
*Exit:
*       No return value.
*
*Exceptions:
*
*******************************************************************************/

void __cdecl __sbh_free_block (PHEADER pHeader, void * pvAlloc)
{
    PREGION         pRegion;
    PGROUP          pGroup;
    PENTRY          pHead;
    PENTRY          pEntry;
    PENTRY          pNext;
    PENTRY          pPrev;
    void *          pHeapDecommit;
    int             sizeEntry;
    int             sizeNext;
    int             sizePrev;
    unsigned int    indGroup;
    unsigned int    indEntry;
    unsigned int    indNext;
    unsigned int    indPrev;
    unsigned int    offRegion;

    //  region is determined by the header
    pRegion = pHeader->pRegion;

    //  use the region offset to determine the group index
    offRegion = (unsigned int)(((uintptr_t)pvAlloc - (uintptr_t)pHeader->pHeapData));
    indGroup = offRegion / BYTES_PER_GROUP;
    pGroup = &pRegion->grpHeadList[indGroup];

    //  get size of entry - decrement value since entry is allocated
    pEntry = (PENTRY)((char *)pvAlloc - sizeof(int));
    sizeEntry = pEntry->sizeFront - 1;

    //  check if the entry is already free. note the size has already been
    // decremented
    if ( (sizeEntry & 1 ) != 0 )
        return;

    //  point to next entry to get its size
    pNext = (PENTRY)((char *)pEntry + sizeEntry);
    sizeNext = pNext->sizeFront;

    //  get size from end of previous entry
    sizePrev = ((PENTRYEND)((char *)pEntry - sizeof(int)))->sizeBack;

    //  test if next entry is free by an even size value

    if ((sizeNext & 1) == 0)
    {
        //  free next entry - disconnect and add its size to sizeEntry

        //  determine index of next entry
        indNext = (sizeNext >> 4) - 1;
        if (indNext > 63)
            indNext = 63;

        //  test entry is sole member of bucket (next == prev),
        if (pNext->pEntryNext == pNext->pEntryPrev)
        {
            //  clear bit in group vector, decrement region count
            //  if region count is now zero, clear bit in header
            //  entry vector
            if (indNext < 32)
            {
                pRegion->bitvGroupHi[indGroup] &= ~(0x80000000L >> indNext);
                if (--pRegion->cntRegionSize[indNext] == 0)
                    pHeader->bitvEntryHi &= ~(0x80000000L >> indNext);
            }
            else
            {
                pRegion->bitvGroupLo[indGroup] &=
                                            ~(0x80000000L >> (indNext - 32));
                if (--pRegion->cntRegionSize[indNext] == 0)
                    pHeader->bitvEntryLo &= ~(0x80000000L >> (indNext - 32));
            }
        }

        //  unlink entry from list
        pNext->pEntryPrev->pEntryNext = pNext->pEntryNext;
        pNext->pEntryNext->pEntryPrev = pNext->pEntryPrev;

        //  add next entry size to freed entry size
        sizeEntry += sizeNext;
    }

    //  compute index of free entry (plus next entry if it was free)
    indEntry = (sizeEntry >> 4) - 1;
    if (indEntry > 63)
        indEntry = 63;

    //  test if previous entry is free by an even size value
    if ((sizePrev & 1) == 0)
    {
        //  free previous entry - add size to sizeEntry and
        //  disconnect if index changes

        //  get pointer to previous entry
        pPrev = (PENTRY)((char *)pEntry - sizePrev);

        //  determine index of previous entry
        indPrev = (sizePrev >> 4) - 1;
        if (indPrev > 63)
            indPrev = 63;

        //  add previous entry size to sizeEntry and determine
        //  its new index
        sizeEntry += sizePrev;
        indEntry = (sizeEntry >> 4) - 1;
        if (indEntry > 63)
            indEntry = 63;

        //  if index changed due to coalesing, reconnect to new size
        if (indPrev != indEntry)
        {
            //  disconnect entry from indPrev
            //  test entry is sole member of bucket (next == prev),
            if (pPrev->pEntryNext == pPrev->pEntryPrev)
            {
                //  clear bit in group vector, decrement region count
                //  if region count is now zero, clear bit in header
                //  entry vector
                if (indPrev < 32)
                {
                    pRegion->bitvGroupHi[indGroup] &=
                                                ~(0x80000000L >> indPrev);
                    if (--pRegion->cntRegionSize[indPrev] == 0)
                        pHeader->bitvEntryHi &= ~(0x80000000L >> indPrev);
                }
                else
                {
                    pRegion->bitvGroupLo[indGroup] &=
                                            ~(0x80000000L >> (indPrev - 32));
                    if (--pRegion->cntRegionSize[indPrev] == 0)
                        pHeader->bitvEntryLo &=
                                            ~(0x80000000L >> (indPrev - 32));
                }
            }

            //  unlink entry from list
            pPrev->pEntryPrev->pEntryNext = pPrev->pEntryNext;
            pPrev->pEntryNext->pEntryPrev = pPrev->pEntryPrev;
        }
        //  set pointer to connect it instead of the free entry
        pEntry = pPrev;
    }

    //  test if previous entry was free with an index change or allocated
    if (!((sizePrev & 1) == 0 && indPrev == indEntry))
    {
        //  connect pEntry entry to indEntry
        //  add entry to the start of the bucket list
        pHead = (PENTRY)((char *)&pGroup->listHead[indEntry] - sizeof(int));
        pEntry->pEntryNext = pHead->pEntryNext;
        pEntry->pEntryPrev = pHead;
        pHead->pEntryNext = pEntry;
        pEntry->pEntryNext->pEntryPrev = pEntry;

        //  test entry is sole member of bucket (next == prev),
        if (pEntry->pEntryNext == pEntry->pEntryPrev)
        {
            //  if region count was zero, set bit in region vector
            //  set bit in header entry vector, increment region count
            if (indEntry < 32)
            {
                if (pRegion->cntRegionSize[indEntry]++ == 0)
                    pHeader->bitvEntryHi |= 0x80000000L >> indEntry;
                pRegion->bitvGroupHi[indGroup] |= 0x80000000L >> indEntry;
            }
            else
            {
                if (pRegion->cntRegionSize[indEntry]++ == 0)
                    pHeader->bitvEntryLo |= 0x80000000L >> (indEntry - 32);
                pRegion->bitvGroupLo[indGroup] |= 0x80000000L >>
                                                           (indEntry - 32);
            }
        }
    }

    //  adjust the entry size front and back
    pEntry->sizeFront = sizeEntry;
    ((PENTRYEND)((char *)pEntry + sizeEntry -
                        sizeof(ENTRYEND)))->sizeBack = sizeEntry;

        //  one less allocation in group - test if empty
    if (--pGroup->cntEntries == 0)
    {
        //  if a group has been deferred, free that group
        if (__sbh_pHeaderDefer)
        {
            //  if now zero, decommit the group data heap
            pHeapDecommit = (void *)((char *)__sbh_pHeaderDefer->pHeapData +
                                    __sbh_indGroupDefer * BYTES_PER_GROUP);
            VirtualFree(pHeapDecommit, BYTES_PER_GROUP, MEM_DECOMMIT);

            //  set bit in commit vector
            __sbh_pHeaderDefer->bitvCommit |=
                                          0x80000000 >> __sbh_indGroupDefer;

            //  clear entry vector for the group and header vector bit
            //  if needed
            __sbh_pHeaderDefer->pRegion->bitvGroupLo[__sbh_indGroupDefer] = 0;
            if (--__sbh_pHeaderDefer->pRegion->cntRegionSize[63] == 0)
                __sbh_pHeaderDefer->bitvEntryLo &= ~0x00000001L;

            //  if commit vector is the initial value,
            //  remove the region if it is not the last
            if (__sbh_pHeaderDefer->bitvCommit == BITV_COMMIT_INIT)
            {
                //  release the address space for heap data
                VirtualFree(__sbh_pHeaderDefer->pHeapData, 0, MEM_RELEASE);

                //  free the region memory area
                HeapFree(_crtheap, 0, __sbh_pHeaderDefer->pRegion);

                //  remove entry from header list by copying over
                memmove((void *)__sbh_pHeaderDefer,
                            (void *)(__sbh_pHeaderDefer + 1),
                            (int)((intptr_t)(__sbh_pHeaderList + __sbh_cntHeaderList) -
                            (intptr_t)(__sbh_pHeaderDefer + 1)));
				__sbh_cntHeaderList--;

                //  if pHeader was after the one just removed, adjust it
                if (pHeader > __sbh_pHeaderDefer)
                    pHeader--;

                //  initialize scan pointer to start of list
                __sbh_pHeaderScan = __sbh_pHeaderList;
            }
        }

        //  defer the group just freed
        __sbh_pHeaderDefer = pHeader;
        __sbh_indGroupDefer = indGroup;
    }
}

/***
*void * __sbh_alloc_block(intSize) - allocate a block
*
*Purpose:
*       Allocate a block from the small-block heap, the specified number of
*       bytes in size.
*
*Entry:
*       intSize - size of the allocation request in bytes
*
*Exit:
*       Returns a pointer to the newly allocated block, if successful.
*       Returns NULL, if failure.
*
*Exceptions:
*
*******************************************************************************/

void * __cdecl __sbh_alloc_block (int intSize)
{
    PHEADER     pHeaderLast = __sbh_pHeaderList + __sbh_cntHeaderList;
    PHEADER     pHeader;
    PREGION     pRegion;
    PGROUP      pGroup;
    PENTRY      pEntry;
    PENTRY      pHead;
    BITVEC      bitvEntryLo;
    BITVEC      bitvEntryHi;
    BITVEC      bitvTest;
    int         sizeEntry;
    int         indEntry;
    int         indGroupUse;
    int         sizeNewFree;
    int         indNewFree;

    //  add 8 bytes entry overhead and round up to next para size
    sizeEntry = (intSize + 2 * (int)sizeof(int) + (BYTES_PER_PARA - 1))
                & ~(BYTES_PER_PARA - 1);

    //  determine index and mask from entry size
    //  Hi MSB: bit 0      size: 1 paragraph
    //          bit 1            2 paragraphs
    //          ...              ...
    //          bit 30           31 paragraphs
    //          bit 31           32 paragraphs
    //  Lo MSB: bit 0      size: 33 paragraph
    //          bit 1            34 paragraphs
    //          ...              ...
    //          bit 30           63 paragraphs
    //          bit 31           64+ paragraphs
    indEntry = (sizeEntry >> 4) - 1;
    if (indEntry < 32)
    {
        bitvEntryHi = 0xffffffffUL >> indEntry;
        bitvEntryLo = 0xffffffffUL;
    }
    else
    {
        bitvEntryHi = 0;
        bitvEntryLo = 0xffffffffUL >> (indEntry - 32);
    }

    //  scan header list from rover to end for region with a free
    //  entry with an adequate size
    pHeader = __sbh_pHeaderScan;
    while (pHeader < pHeaderLast)
    {
        if ((bitvEntryHi & pHeader->bitvEntryHi) |
            (bitvEntryLo & pHeader->bitvEntryLo))
            break;
        pHeader++;
    }

    //  if no entry, scan from list start up to the rover
    if (pHeader == pHeaderLast)
    {
        pHeader = __sbh_pHeaderList;
        while (pHeader < __sbh_pHeaderScan)
        {
            if ((bitvEntryHi & pHeader->bitvEntryHi) |
                (bitvEntryLo & pHeader->bitvEntryLo))
                break;
            pHeader++;
        }

        //  no free entry exists, scan list from rover to end
        //  for available groups to commit
        if (pHeader == __sbh_pHeaderScan)
        {
            while (pHeader < pHeaderLast)
            {
                if (pHeader->bitvCommit)
                    break;
                pHeader++;
            }

            //  if no available groups, scan from start to rover
            if (pHeader == pHeaderLast)
            {
                pHeader = __sbh_pHeaderList;
                while (pHeader < __sbh_pHeaderScan)
                {
                    if (pHeader->bitvCommit)
                        break;
                    pHeader++;
                }

                //  if no available groups, create a new region
                if (pHeader == __sbh_pHeaderScan)
                    if (!(pHeader = __sbh_alloc_new_region()))
                        return NULL;
            }

            //  commit a new group in region associated with pHeader
            if ((pHeader->pRegion->indGroupUse =
                                    __sbh_alloc_new_group(pHeader)) == -1)
                return NULL;
        }
    }
    __sbh_pHeaderScan = pHeader;

    pRegion = pHeader->pRegion;
    indGroupUse = pRegion->indGroupUse;

    //  determine the group to allocate from
    if (indGroupUse == -1 ||
                    !((bitvEntryHi & pRegion->bitvGroupHi[indGroupUse]) |
                      (bitvEntryLo & pRegion->bitvGroupLo[indGroupUse])))
    {
        //  preferred group could not allocate entry, so
        //  scan through all defined vectors
        indGroupUse = 0;
        while (!((bitvEntryHi & pRegion->bitvGroupHi[indGroupUse]) |
                 (bitvEntryLo & pRegion->bitvGroupLo[indGroupUse])))
            indGroupUse++;
    }
    pGroup = &pRegion->grpHeadList[indGroupUse];

    //  determine bucket index
    indEntry = 0;

    //  get high entry intersection - if zero, use the lower one
    if (!(bitvTest = bitvEntryHi & pRegion->bitvGroupHi[indGroupUse]))
    {
        indEntry = 32;
        bitvTest = bitvEntryLo & pRegion->bitvGroupLo[indGroupUse];
    }
       while ((int)bitvTest >= 0)
    {
           bitvTest <<= 1;
           indEntry++;
    }
    pEntry = pGroup->listHead[indEntry].pEntryNext;

    //  compute size and bucket index of new free entry

    //  for zero-sized entry, the index is -1
    sizeNewFree = pEntry->sizeFront - sizeEntry;
    indNewFree = (sizeNewFree >> 4) - 1;
    if (indNewFree > 63)
        indNewFree = 63;

    //  only modify entry pointers if bucket index changed
    if (indNewFree != indEntry)
    {
        //  test entry is sole member of bucket (next == prev),
        if (pEntry->pEntryNext == pEntry->pEntryPrev)
        {
            //  clear bit in group vector, decrement region count
            //  if region count is now zero, clear bit in region vector
            if (indEntry < 32)
            {
                pRegion->bitvGroupHi[indGroupUse] &=
                                            ~(0x80000000L >> indEntry);
                if (--pRegion->cntRegionSize[indEntry] == 0)
                    pHeader->bitvEntryHi &= ~(0x80000000L >> indEntry);
            }
            else
            {
                pRegion->bitvGroupLo[indGroupUse] &=
                                            ~(0x80000000L >> (indEntry - 32));
                if (--pRegion->cntRegionSize[indEntry] == 0)
                    pHeader->bitvEntryLo &= ~(0x80000000L >> (indEntry - 32));
            }
        }

        //  unlink entry from list
        pEntry->pEntryPrev->pEntryNext = pEntry->pEntryNext;
        pEntry->pEntryNext->pEntryPrev = pEntry->pEntryPrev;

        //  if free entry size is still nonzero, reconnect it
        if (sizeNewFree != 0)
        {
            //  add entry to the start of the bucket list
            pHead = (PENTRY)((char *)&pGroup->listHead[indNewFree] -
                                                           sizeof(int));
            pEntry->pEntryNext = pHead->pEntryNext;
            pEntry->pEntryPrev = pHead;
            pHead->pEntryNext = pEntry;
            pEntry->pEntryNext->pEntryPrev = pEntry;

            //  test entry is sole member of bucket (next == prev),
            if (pEntry->pEntryNext == pEntry->pEntryPrev)
            {
                //  if region count was zero, set bit in region vector
                //  set bit in group vector, increment region count
                if (indNewFree < 32)
                {
                    if (pRegion->cntRegionSize[indNewFree]++ == 0)
                        pHeader->bitvEntryHi |= 0x80000000L >> indNewFree;
                    pRegion->bitvGroupHi[indGroupUse] |=
                                                0x80000000L >> indNewFree;
                }
                else
                {
                    if (pRegion->cntRegionSize[indNewFree]++ == 0)
                        pHeader->bitvEntryLo |=
                                        0x80000000L >> (indNewFree - 32);
                    pRegion->bitvGroupLo[indGroupUse] |=
                                        0x80000000L >> (indNewFree - 32);
                }
            }
        }
    }

    //  change size of free entry (front and back)
    if (sizeNewFree != 0)
    {
        pEntry->sizeFront = sizeNewFree;
        ((PENTRYEND)((char *)pEntry + sizeNewFree -
                    sizeof(ENTRYEND)))->sizeBack = sizeNewFree;
    }

    //  mark the allocated entry
    pEntry = (PENTRY)((char *)pEntry + sizeNewFree);
    pEntry->sizeFront = sizeEntry + 1;
    ((PENTRYEND)((char *)pEntry + sizeEntry -
                    sizeof(ENTRYEND)))->sizeBack = sizeEntry + 1;

    //  one more allocation in group - test if group was empty
    if (pGroup->cntEntries++ == 0)
    {
        //  if allocating into deferred group, cancel deferral
        if (pHeader == __sbh_pHeaderDefer &&
                                  indGroupUse == __sbh_indGroupDefer)
            __sbh_pHeaderDefer = NULL;
    }

    pRegion->indGroupUse = indGroupUse;

    return (void *)((char *)pEntry + sizeof(int));
}

/***
*PHEADER __sbh_alloc_new_region()
*
*Purpose:
*       Add a new HEADER structure in the header list.  Allocate a new
*       REGION structure and initialize.  Reserve memory for future
*       group commitments.
*
*Entry:
*       None.
*
*Exit:
*       Returns a pointer to newly created HEADER entry, if successful.
*       Returns NULL, if failure.
*
*Exceptions:
*
*******************************************************************************/

PHEADER __cdecl __sbh_alloc_new_region (void)
{
    PHEADER     pHeader;

    //  create a new entry in the header list

    //  if list if full, realloc to extend its size
    if (__sbh_cntHeaderList == __sbh_sizeHeaderList)
    {
        if (!(pHeader = (PHEADER)HeapReAlloc(_crtheap, 0, __sbh_pHeaderList,
                            (__sbh_sizeHeaderList + 16) * sizeof(HEADER))))
            return NULL;

        //  update pointer and counter values
        __sbh_pHeaderList = pHeader;
        __sbh_sizeHeaderList += 16;
    }

    //  point to new header in list
    pHeader = __sbh_pHeaderList + __sbh_cntHeaderList;

    //  allocate a new region associated with the new header
    if (!(pHeader->pRegion = (PREGION)HeapAlloc(_crtheap, HEAP_ZERO_MEMORY,
                                    sizeof(REGION))))
        return NULL;

    //  reserve address space for heap data in the region
    if ((pHeader->pHeapData = VirtualAlloc(0, BYTES_PER_REGION,
                                     MEM_RESERVE, PAGE_READWRITE)) == NULL)
    {
        HeapFree(_crtheap, 0, pHeader->pRegion);
        return NULL;
    }

    //  initialize alloc and commit group vectors
    pHeader->bitvEntryHi = 0;
    pHeader->bitvEntryLo = 0;
    pHeader->bitvCommit = BITV_COMMIT_INIT;

    //  complete entry by incrementing list count
    __sbh_cntHeaderList++;

    //  initialize index of group to try first (none defined yet)
    pHeader->pRegion->indGroupUse = -1;

    return pHeader;
}

/***
*int __sbh_alloc_new_group(pHeader)
*
*Purpose:
*       Initializes a GROUP structure within HEADER pointed by pHeader.
*       Commits and initializes the memory in the memory reserved by the
*       REGION.
*
*Entry:
*       pHeader - pointer to HEADER from which the GROUP is defined.
*
*Exit:
*       Returns an index to newly created GROUP, if successful.
*       Returns -1, if failure.
*
*Exceptions:
*
*******************************************************************************/

int __cdecl __sbh_alloc_new_group (PHEADER pHeader)
{
    PREGION     pRegion = pHeader->pRegion;
    PGROUP      pGroup;
    PENTRY      pEntry;
    PENTRY      pHead;
    PENTRYEND   pEntryEnd;
    BITVEC      bitvCommit;
    int         indCommit;
    int         index;
    void *      pHeapPage;
    void *      pHeapStartPage;
    void *      pHeapEndPage;

    //  determine next group to use by first bit set in commit vector
    bitvCommit = pHeader->bitvCommit;
    indCommit = 0;
    while ((int)bitvCommit >= 0)
    {
        bitvCommit <<= 1;
        indCommit++;
    }

    //  allocate and initialize a new group
    pGroup = &pRegion->grpHeadList[indCommit];

    for (index = 0; index < 63; index++)
    {
        pEntry = (PENTRY)((char *)&pGroup->listHead[index] - sizeof(int));
        pEntry->pEntryNext = pEntry->pEntryPrev = pEntry;
    }

    //  commit heap memory for new group
    pHeapStartPage = (void *)((char *)pHeader->pHeapData +
                                       indCommit * BYTES_PER_GROUP);
    if ((VirtualAlloc(pHeapStartPage, BYTES_PER_GROUP, MEM_COMMIT,
                                      PAGE_READWRITE)) == NULL)
        return -1;

    //  initialize heap data with empty page entries
    pHeapEndPage = (void *)((char *)pHeapStartPage +
                        (PAGES_PER_GROUP - 1) * BYTES_PER_PAGE);

    for (pHeapPage = pHeapStartPage; pHeapPage <= pHeapEndPage;
            pHeapPage = (void *)((char *)pHeapPage + BYTES_PER_PAGE))
    {
        //  set sentinel values at start and end of the page
        *(int *)((char *)pHeapPage + 8) = -1;
        *(int *)((char *)pHeapPage + BYTES_PER_PAGE - 4) = -1;

        //  set size and pointer info for one empty entry
        pEntry = (PENTRY)((char *)pHeapPage + ENTRY_OFFSET);
        pEntry->sizeFront = MAX_FREE_ENTRY_SIZE;
        pEntry->pEntryNext = (PENTRY)((char *)pEntry +
                                            BYTES_PER_PAGE);
        pEntry->pEntryPrev = (PENTRY)((char *)pEntry -
                                            BYTES_PER_PAGE);
        pEntryEnd = (PENTRYEND)((char *)pEntry + MAX_FREE_ENTRY_SIZE -
                                            sizeof(ENTRYEND));
        pEntryEnd->sizeBack = MAX_FREE_ENTRY_SIZE;
    }

    //  initialize group entry pointer for maximum size
    //  and set terminate list entries
    pHead = (PENTRY)((char *)&pGroup->listHead[63] - sizeof(int));
    pEntry = pHead->pEntryNext =
                        (PENTRY)((char *)pHeapStartPage + ENTRY_OFFSET);
    pEntry->pEntryPrev = pHead;

    pEntry = pHead->pEntryPrev =
                        (PENTRY)((char *)pHeapEndPage + ENTRY_OFFSET);
    pEntry->pEntryNext = pHead;

    pRegion->bitvGroupHi[indCommit] = 0x00000000L;
    pRegion->bitvGroupLo[indCommit] = 0x00000001L;
    if (pRegion->cntRegionSize[63]++ == 0)
        pHeader->bitvEntryLo |= 0x00000001L;

    //  clear bit in commit vector
    pHeader->bitvCommit &= ~(0x80000000L >> indCommit);

    return indCommit;
}

/***
*int __sbh_resize_block(pHeader, pvAlloc, intNew) - resize block
*
*Purpose:
*       Resize the specified block from the small-block heap.
*       The allocation block is not moved.
*
*Entry:
*       pHeader - pointer to HEADER containing block
*       pvAlloc - pointer to block to resize
*       intNew  - new size of block in bytes
*
*Exit:
*       Returns 1, if successful. Otherwise, 0 is returned.
*
*Exceptions:
*
*******************************************************************************/

int __cdecl __sbh_resize_block (PHEADER pHeader, void * pvAlloc, int intNew)
{
    PREGION         pRegion;
    PGROUP          pGroup;
    PENTRY          pHead;
    PENTRY          pEntry;
    PENTRY          pNext;
    int             sizeEntry;
    int             sizeNext;
    int             sizeNew;
    unsigned int    indGroup;
    unsigned int    indEntry;
    unsigned int    indNext;
    unsigned int    offRegion;

    //  add 8 bytes entry overhead and round up to next para size
    sizeNew = (intNew + 2 * (int)sizeof(int) + (BYTES_PER_PARA - 1))
              & ~(BYTES_PER_PARA - 1);

    //  region is determined by the header
    pRegion = pHeader->pRegion;

    //  use the region offset to determine the group index
    offRegion = (unsigned int)((uintptr_t)pvAlloc - (uintptr_t)pHeader->pHeapData);
    indGroup = offRegion / BYTES_PER_GROUP;
    pGroup = &pRegion->grpHeadList[indGroup];

    //  get size of entry - decrement value since entry is allocated
    pEntry = (PENTRY)((char *)pvAlloc - sizeof(int));
    sizeEntry = pEntry->sizeFront - 1;

    //  point to next entry to get its size
    pNext = (PENTRY)((char *)pEntry + sizeEntry);
    sizeNext = pNext->sizeFront;

    //  test if new size is larger than the current one
    if (sizeNew > sizeEntry)
    {
        //  if next entry not free, or not large enough, fail
        if ((sizeNext & 1) || (sizeNew > sizeEntry + sizeNext))
            return FALSE;

        //  disconnect next entry

        //  determine index of next entry
        indNext = (sizeNext >> 4) - 1;
        if (indNext > 63)
            indNext = 63;

        //  test entry is sole member of bucket (next == prev),
        if (pNext->pEntryNext == pNext->pEntryPrev)
        {
            //  clear bit in group vector, decrement region count
            //  if region count is now zero, clear bit in header
            //  entry vector
            if (indNext < 32)
            {
                pRegion->bitvGroupHi[indGroup] &= ~(0x80000000L >> indNext);
                if (--pRegion->cntRegionSize[indNext] == 0)
                    pHeader->bitvEntryHi &= ~(0x80000000L >> indNext);
            }
            else
            {
                pRegion->bitvGroupLo[indGroup] &=
                                            ~(0x80000000L >> (indNext - 32));
                if (--pRegion->cntRegionSize[indNext] == 0)
                    pHeader->bitvEntryLo &= ~(0x80000000L >> (indNext - 32));
            }
        }

        //  unlink entry from list
        pNext->pEntryPrev->pEntryNext = pNext->pEntryNext;
        pNext->pEntryNext->pEntryPrev = pNext->pEntryPrev;

        //  compute new size of the next entry, test if nonzero
        if ((sizeNext = sizeEntry + sizeNext - sizeNew) > 0)
        {
            //  compute start of next entry and connect it
            pNext = (PENTRY)((char *)pEntry + sizeNew);

            //  determine index of next entry
            indNext = (sizeNext >> 4) - 1;
            if (indNext > 63)
                indNext = 63;

            //  add next entry to the start of the bucket list
            pHead = (PENTRY)((char *)&pGroup->listHead[indNext] -
                                                           sizeof(int));
            pNext->pEntryNext = pHead->pEntryNext;
            pNext->pEntryPrev = pHead;
            pHead->pEntryNext = pNext;
            pNext->pEntryNext->pEntryPrev = pNext;

            //  test entry is sole member of bucket (next == prev),
            if (pNext->pEntryNext == pNext->pEntryPrev)
            {
                //  if region count was zero, set bit in region vector
                //  set bit in header entry vector, increment region count
                if (indNext < 32)
                {
                    if (pRegion->cntRegionSize[indNext]++ == 0)
                        pHeader->bitvEntryHi |= 0x80000000L >> indNext;
                    pRegion->bitvGroupHi[indGroup] |= 0x80000000L >> indNext;
                }
                else
                {
                    if (pRegion->cntRegionSize[indNext]++ == 0)
                        pHeader->bitvEntryLo |= 0x80000000L >> (indNext - 32);
                    pRegion->bitvGroupLo[indGroup] |=
                                                0x80000000L >> (indNext - 32);
                }
            }

            //  adjust size fields of next entry
            pNext->sizeFront = sizeNext;
            ((PENTRYEND)((char *)pNext + sizeNext -
                                sizeof(ENTRYEND)))->sizeBack = sizeNext;
        }

        //  adjust pEntry to its new size (plus one since allocated)
        pEntry->sizeFront = sizeNew + 1;
        ((PENTRYEND)((char *)pEntry + sizeNew -
                            sizeof(ENTRYEND)))->sizeBack = sizeNew + 1;
    }

    //  not larger, test if smaller
    else if (sizeNew < sizeEntry)
    {
        //  adjust pEntry to new smaller size
        pEntry->sizeFront = sizeNew + 1;
        ((PENTRYEND)((char *)pEntry + sizeNew -
                            sizeof(ENTRYEND)))->sizeBack = sizeNew + 1;

        //  set pEntry and sizeEntry to leftover space
        pEntry = (PENTRY)((char *)pEntry + sizeNew);
        sizeEntry -= sizeNew;

        //  determine index of entry
        indEntry = (sizeEntry >> 4) - 1;
        if (indEntry > 63)
            indEntry = 63;

        //  test if next entry is free
        if ((sizeNext & 1) == 0)
        {
            //  if so, disconnect it

            //  determine index of next entry
            indNext = (sizeNext >> 4) - 1;
            if (indNext > 63)
                indNext = 63;

            //  test entry is sole member of bucket (next == prev),
            if (pNext->pEntryNext == pNext->pEntryPrev)
            {
                //  clear bit in group vector, decrement region count
                //  if region count is now zero, clear bit in header
                //  entry vector
                if (indNext < 32)
                {
                    pRegion->bitvGroupHi[indGroup] &=
                                                ~(0x80000000L >> indNext);
                    if (--pRegion->cntRegionSize[indNext] == 0)
                        pHeader->bitvEntryHi &= ~(0x80000000L >> indNext);
                }
                else
                {
                    pRegion->bitvGroupLo[indGroup] &=
                                            ~(0x80000000L >> (indNext - 32));
                    if (--pRegion->cntRegionSize[indNext] == 0)
                        pHeader->bitvEntryLo &=
                                            ~(0x80000000L >> (indNext - 32));
                }
            }

            //  unlink entry from list
            pNext->pEntryPrev->pEntryNext = pNext->pEntryNext;
            pNext->pEntryNext->pEntryPrev = pNext->pEntryPrev;

            //  add next entry size to present
            sizeEntry += sizeNext;
            indEntry = (sizeEntry >> 4) - 1;
            if (indEntry > 63)
                indEntry = 63;
        }

        //  connect leftover space with any free next entry

        //  add next entry to the start of the bucket list
        pHead = (PENTRY)((char *)&pGroup->listHead[indEntry] - sizeof(int));
        pEntry->pEntryNext = pHead->pEntryNext;
        pEntry->pEntryPrev = pHead;
        pHead->pEntryNext = pEntry;
        pEntry->pEntryNext->pEntryPrev = pEntry;

        //  test entry is sole member of bucket (next == prev),
        if (pEntry->pEntryNext == pEntry->pEntryPrev)
        {
            //  if region count was zero, set bit in region vector
            //  set bit in header entry vector, increment region count
            if (indEntry < 32)
            {
                if (pRegion->cntRegionSize[indEntry]++ == 0)
                    pHeader->bitvEntryHi |= 0x80000000L >> indEntry;
                pRegion->bitvGroupHi[indGroup] |= 0x80000000L >> indEntry;
            }
            else
            {
                if (pRegion->cntRegionSize[indEntry]++ == 0)
                    pHeader->bitvEntryLo |= 0x80000000L >> (indEntry - 32);
                pRegion->bitvGroupLo[indGroup] |= 0x80000000L >>
                                                           (indEntry - 32);
            }
        }

        //  adjust size fields of entry
        pEntry->sizeFront = sizeEntry;
        ((PENTRYEND)((char *)pEntry + sizeEntry -
                            sizeof(ENTRYEND)))->sizeBack = sizeEntry;
    }

    return TRUE;
}

/***
*int __sbh_heapmin() - minimize heap
*
*Purpose:
*       Minimize the heap by freeing any deferred group.
*
*Entry:
*       __sbh_pHeaderDefer  - pointer to HEADER of deferred group
*       __sbh_indGroupDefer - index of GROUP to defer
*
*Exit:
*       None.
*
*Exceptions:
*
*******************************************************************************/

void __cdecl __sbh_heapmin (void)
{
    void *      pHeapDecommit;

    //  if a group has been deferred, free that group
    if (__sbh_pHeaderDefer)
    {
        //  if now zero, decommit the group data heap
        pHeapDecommit = (void *)((char *)__sbh_pHeaderDefer->pHeapData +
                                    __sbh_indGroupDefer * BYTES_PER_GROUP);
        VirtualFree(pHeapDecommit, BYTES_PER_GROUP, MEM_DECOMMIT);

        //  set bit in commit vector
        __sbh_pHeaderDefer->bitvCommit |= 0x80000000 >> __sbh_indGroupDefer;

        //  clear entry vector for the group and header vector bit
        //  if needed
        __sbh_pHeaderDefer->pRegion->bitvGroupLo[__sbh_indGroupDefer] = 0;
        if (--__sbh_pHeaderDefer->pRegion->cntRegionSize[63] == 0)
            __sbh_pHeaderDefer->bitvEntryLo &= ~0x00000001L;

        //  if commit vector is the initial value,
        //  remove the region if it is not the last
        if (__sbh_pHeaderDefer->bitvCommit == BITV_COMMIT_INIT &&
                                                __sbh_cntHeaderList > 1)
        {
            //  free the region memory area
            HeapFree(_crtheap, 0, __sbh_pHeaderDefer->pRegion);

            //  remove entry from header list by copying over
            memmove((void *)__sbh_pHeaderDefer, (void *)(__sbh_pHeaderDefer + 1),
                            (int)((intptr_t)(__sbh_pHeaderList + __sbh_cntHeaderList) -
                            (intptr_t)(__sbh_pHeaderDefer + 1)));
            __sbh_cntHeaderList--;
        }

        //  clear deferred condition
        __sbh_pHeaderDefer = NULL;
    }

#ifdef _DEBUG
	if (__sbh_heap_check() != 0)
		_asm int 3;
#endif
}

#ifdef _DEBUG

/***
*int __sbh_heap_check() - check small-block heap
*
*Purpose:
*       Perform validity checks on the small-block heap.
*
*Entry:
*       There are no arguments.
*
*Exit:
*       Returns 0 if the small-block is okay.
*       Returns < 0 if the small-block heap has an error. The exact value
*       identifies where, in the source code below, the error was detected.
*
*Exceptions:
*
*******************************************************************************/

int __cdecl __sbh_heap_check (void)
{
    PHEADER     pHeader;
    PREGION     pRegion;
    PGROUP      pGroup;
    PENTRY      pEntry;
    PENTRY      pNext;
    PENTRY      pEntryLast;
    PENTRY      pEntryHead;
    PENTRY      pEntryPage;
    PENTRY      pEntryPageLast;
    int         indHeader;
    int         indGroup;
    int         indPage;
    int         indEntry;
    int         indHead;
    int         sizeEntry;
    int         sizeTrue;
    int         cntAllocated;
    int         cntFree[64];
    int         cntEntries;
    void *      pHeapGroup;
    void *      pHeapPage;
    void *      pPageStart;
    BITVEC      bitvCommit;
    BITVEC      bitvGroupHi;
    BITVEC      bitvGroupLo;
    BITVEC      bitvEntryHi;
    BITVEC      bitvEntryLo;

    //  check validity of header list
    if (IsBadWritePtr(__sbh_pHeaderList,
                      __sbh_cntHeaderList * sizeof(HEADER)))
        return -1;

    //  scan for all headers in list
    pHeader = __sbh_pHeaderList;
    for (indHeader = 0; indHeader < __sbh_cntHeaderList; indHeader++)
    {
        //  define region and test if valid
        pRegion = pHeader->pRegion;
        if (IsBadWritePtr(pRegion, sizeof(REGION)))
            return -2;

        //  scan for all groups in region
        pHeapGroup = pHeader->pHeapData;
        pGroup = &pRegion->grpHeadList[0];
        bitvCommit = pHeader->bitvCommit;
        bitvEntryHi = 0;
        bitvEntryLo = 0;
        for (indGroup = 0; indGroup < GROUPS_PER_REGION; indGroup++)
        {
            //  initialize entry vector and entry counts for group
            bitvGroupHi = 0;
            bitvGroupLo = 0;
            cntAllocated = 0;
            for (indEntry = 0; indEntry < 64; indEntry++)
                cntFree[indEntry] = 0;

            //  test if group is committed
            if ((int)bitvCommit >= 0)
            {
                //  committed, ensure addresses are accessable
                if (IsBadWritePtr(pHeapGroup, BYTES_PER_GROUP))
                    return -4;

                //  for each page in group, check validity of entries
                pHeapPage = pHeapGroup;
                for (indPage = 0; indPage < PAGES_PER_GROUP; indPage++)
                {
                    //  define pointers to first and past last entry
                    pEntry = (PENTRY)((char *)pHeapPage + ENTRY_OFFSET);
                    pEntryLast = (PENTRY)((char *)pEntry
                                                 + MAX_FREE_ENTRY_SIZE);

                    //  check front and back page sentinel values
                    if (*(int *)((char *)pEntry - sizeof(int)) != -1 ||
                                 *(int *)pEntryLast != -1)
                        return -5;

                    //  loop through each entry in page
                    do
                    {
                        //  get entry size and test if allocated
                        sizeEntry = sizeTrue = pEntry->sizeFront;
                        if (sizeEntry & 1)
                        {
                            //  allocated entry - set true size
                            sizeTrue--;

                            //  test against maximum allocated entry size
                            if (sizeTrue > MAX_ALLOC_ENTRY_SIZE)
                                return -6;

                            //  increment allocated count for group
                            cntAllocated++;
                        }
                        else
                        {
                            //  free entry - determine index and increment
                            //  count for list head checking
                            indEntry = (sizeTrue >> 4) - 1;
                            if (indEntry > 63)
                                indEntry = 63;
                            cntFree[indEntry]++;
                        }

                        //  check size validity
                        if (sizeTrue < 0x10 || sizeTrue & 0xf
                                        || sizeTrue > MAX_FREE_ENTRY_SIZE)
                            return -7;

                        //  check if back entry size same as front
                        if (((PENTRYEND)((char *)pEntry + sizeTrue
                                    - sizeof(int)))->sizeBack != sizeEntry)
                            return -8;

                        //  move to next entry in page
                        pEntry = (PENTRY)((char *)pEntry + sizeTrue);
                    }
                    while (pEntry < pEntryLast);

                    //  test if last entry did not overrun page end
                    if (pEntry != pEntryLast)
                        return -8;

                    //  point to next page in data heap
                    pHeapPage = (void *)((char *)pHeapPage + BYTES_PER_PAGE);
                }

                //  check if allocated entry count is correct
                if (pGroup->cntEntries != cntAllocated)
                    return -9;

                //  check validity of linked-lists of free entries
                pEntryHead = (PENTRY)((char *)&pGroup->listHead[0] -
                                                           sizeof(int));
                for (indHead = 0; indHead < 64; indHead++)
                {
                    //  scan through list until head is reached or expected
                    //  number of entries traversed
                    cntEntries = 0;
                    pEntry = pEntryHead;
                    while ((pNext = pEntry->pEntryNext) != pEntryHead &&
                                        cntEntries != cntFree[indHead])
                    {
                        //  test if next pointer is in group data area
                        if ((void *)pNext < pHeapGroup || (void *)pNext >=
                            (void *)((char *)pHeapGroup + BYTES_PER_GROUP))
                            return -10;

                        //  determine page address of next entry
                        pPageStart = (void *)((uintptr_t)pNext &
                                        ~(uintptr_t)(BYTES_PER_PAGE - 1));

                        //  point to first entry and past last in the page
                        pEntryPage = (PENTRY)((char *)pPageStart +
                                                        ENTRY_OFFSET);
                        pEntryPageLast = (PENTRY)((char *)pEntryPage +
                                                        MAX_FREE_ENTRY_SIZE);

                        //  do scan from start of page
                        //  no error checking since it was already scanned
                        while (pEntryPage != pEntryPageLast)
                        {
                            //  if entry matches, exit loop
                            if (pEntryPage == pNext)
                                break;

                            //  point to next entry
                            pEntryPage = (PENTRY)((char *)pEntryPage +
                                            (pEntryPage->sizeFront & ~1));
                        }

                        //  if page end reached, pNext was not valid
                        if (pEntryPage == pEntryPageLast)
                            return -11;

                        //  entry valid, but check if entry index matches
                        //  the header
                        indEntry = (pNext->sizeFront >> 4) - 1;
                        if (indEntry > 63)
                            indEntry = 63;
                        if (indEntry != indHead)
                            return -12;

                        //  check if previous pointer in pNext points
                        //  back to pEntry
                        if (pNext->pEntryPrev != pEntry)
                            return -13;

                        //  update scan pointer and counter
                        pEntry = pNext;
                        cntEntries++;
                    }

                    //  if nonzero number of entries, set bit in group
                    //  and region vectors
                    if (cntEntries)
                    {
                        if (indHead < 32)
                        {
                            bitvGroupHi |= 0x80000000L >> indHead;
                            bitvEntryHi |= 0x80000000L >> indHead;
                        }
                        else
                        {
                            bitvGroupLo |= 0x80000000L >> (indHead - 32);
                            bitvEntryLo |= 0x80000000L >> (indHead - 32);
                        }
                    }

                    //  check if list is exactly the expected size
                    if (pEntry->pEntryNext != pEntryHead ||
                                        cntEntries != cntFree[indHead])
                        return -14;

                    //  check if previous pointer in header points to
                    //  last entry processed
                    if (pEntryHead->pEntryPrev != pEntry)
                        return -15;

                    //  point to next linked-list header - note size
                    pEntryHead = (PENTRY)((char *)pEntryHead +
                                                      sizeof(LISTHEAD));
                }
            }

            //  test if group vector is valid
            if (bitvGroupHi != pRegion->bitvGroupHi[indGroup] ||
                bitvGroupLo != pRegion->bitvGroupLo[indGroup])
                return -16;

            //  adjust for next group in region
            pHeapGroup = (void *)((char *)pHeapGroup + BYTES_PER_GROUP);
            pGroup++;
            bitvCommit <<= 1;
        }

        //  test if group vector is valid
        if (bitvEntryHi != pHeader->bitvEntryHi ||
            bitvEntryLo != pHeader->bitvEntryLo)
            return -17;

        //  adjust for next header in list
        pHeader++;
    }
    return 0;
}

#endif