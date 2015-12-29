/***
*winheap.h - Private include file for winheap directory.
*
*       Copyright (c) Microsoft Corporation. All rights reserved.
*
*Purpose:
*       Contains information needed by the C library heap code.
*
*       [Internal]
*
****/

#if _MSC_VER > 1000
#pragma once
#endif  /* _MSC_VER > 1000 */

#ifndef _INC_WINHEAP
#define _INC_WINHEAP

#include <crtdefs.h>

#ifdef _MSC_VER
#pragma pack(push,_CRT_PACKING)
#endif  /* _MSC_VER */

#ifndef _CRTBLD
/*
 * This is an internal C runtime header file. It is used when building
 * the C runtimes only. It is not to be used as a public header file.
 */
#error ERROR: Use of C runtime library internal header file.
#endif  /* _CRTBLD */

#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */

#include <windows.h>

#define BYTES_PER_PARA      16
#define DWORDS_PER_PARA     4

#define PARAS_PER_PAGE      256     /*  tunable value */
#define PAGES_PER_GROUP     8       /*  tunable value */
#define GROUPS_PER_REGION   32      /*  tunable value (max 32) */

#define BYTES_PER_PAGE      (BYTES_PER_PARA * PARAS_PER_PAGE)
#define BYTES_PER_GROUP     (BYTES_PER_PAGE * PAGES_PER_GROUP)
#define BYTES_PER_REGION    (BYTES_PER_GROUP * GROUPS_PER_REGION)

#define ENTRY_OFFSET        0x0000000cL     /*  offset of entry in para */
#define OVERHEAD_PER_PAGE   0x00000010L     /*  sixteen bytes of overhead */
#define MAX_FREE_ENTRY_SIZE (BYTES_PER_PAGE - OVERHEAD_PER_PAGE)
#if GROUPS_PER_REGION > 0 && GROUPS_PER_REGION < 32  
#define BITV_COMMIT_INIT    (((1 << GROUPS_PER_REGION) - 1) << \
                                            (32 - GROUPS_PER_REGION))
#elif GROUPS_PER_REGION == 32  
    #define BITV_COMMIT_INIT    (((0) - 1) << \
                                            (32 - GROUPS_PER_REGION))
#else  /* GROUPS_PER_REGION == 32   */
    #error GROUPS_PER_REGION must be between 1 and 32 inclusive
#endif  /* GROUPS_PER_REGION == 32   */

#define MAX_ALLOC_DATA_SIZE     0x3f8
#define MAX_ALLOC_ENTRY_SIZE    (MAX_ALLOC_DATA_SIZE + 0x8)

typedef unsigned int    BITVEC;

typedef struct tagListHead
{
    struct tagEntry *   pEntryNext;
    struct tagEntry *   pEntryPrev;
}
LISTHEAD, *PLISTHEAD;

typedef struct tagEntry
{
    int                 sizeFront;
    struct tagEntry *   pEntryNext;
    struct tagEntry *   pEntryPrev;
}
ENTRY, *PENTRY;

typedef struct tagEntryEnd
{
    int                 sizeBack;
}
ENTRYEND, *PENTRYEND;

typedef struct tagGroup
{
    int                 cntEntries;
    struct tagListHead  listHead[64];
}
/*GROUP, */*PGROUP;

typedef struct tagRegion
{
    int                 indGroupUse;
    char                cntRegionSize[64];
    BITVEC              bitvGroupHi[GROUPS_PER_REGION];
    BITVEC              bitvGroupLo[GROUPS_PER_REGION];
    struct tagGroup     grpHeadList[GROUPS_PER_REGION];
}
REGION, *PREGION;

typedef struct tagHeader
{
    BITVEC              bitvEntryHi;
    BITVEC              bitvEntryLo;
    BITVEC              bitvCommit;
    void *              pHeapData;
    struct tagRegion *  pRegion;
}
HEADER, *PHEADER;

extern  HANDLE _crtheap;

/*
 * Global variable declarations for the small-block heap.
 */
extern size_t       __sbh_threshold;

/************************ BEGIN BSM MODIFICATION ******************************/
// BSM wants to use stdcall rather than cdecl because it is typically faster
#define __cdecl __stdcall
/************************ END BSM MODIFICATION ********************************/


_Check_return_  _Ret_opt_bytecap_(_Size) void * __cdecl _nh_malloc(_In_ size_t _Size, _In_ int _NhFlag);
_Check_return_  _Ret_opt_bytecap_(_Size) void * __cdecl _heap_alloc(_In_ size_t _Size);

extern PHEADER  __sbh_pHeaderList;        /*  pointer to list start */
extern PHEADER  __sbh_pHeaderScan;        /*  pointer to list rover */
extern int      __sbh_sizeHeaderList;     /*  allocated size of list */
extern int      __sbh_cntHeaderList;      /*  count of entries defined */

extern PHEADER      __sbh_pHeaderDefer;
extern int          __sbh_indGroupDefer;

_Check_return_ extern size_t  __cdecl _get_sb_threshold(void);
extern int     __cdecl _set_sb_threshold(_In_ size_t _Size);

extern int     __cdecl _heap_init(_In_ int _Mtflag);

extern void    __cdecl _heap_term(void);

_Check_return_ _Ret_opt_bytecap_(_Size) extern _CRTIMP void *  __cdecl _malloc_base(_In_ size_t _Size);

extern _CRTIMP void    __cdecl _free_base(_Inout_opt_ void * _Memory);
_Check_return_ _Ret_opt_bytecap_(_NewSize) extern void *  __cdecl _realloc_base(_In_opt_ void * _Memory, _In_ size_t _NewSize);
_Check_return_ _Ret_opt_bytecap_x_(_Count*_Size) extern void *  __cdecl _recalloc_base(_In_opt_ void * _Memory, _In_ size_t _Count, _In_ size_t _Size);

_Check_return_ _Ret_opt_bytecap_(_NewSize) extern void *  __cdecl _expand_base(_In_opt_ void * _Memory, _In_ size_t _NewSize);
_Check_return_ _Ret_opt_bytecap_x_(_Count*_Size) extern void *  __cdecl _calloc_base(_In_ size_t _Count, _In_ size_t _Size);

_Check_return_ extern size_t  __cdecl _msize_base(_In_ void * _Memory);
_Check_return_ extern size_t  __cdecl _aligned_msize_base(_In_ void * _Memory, _In_ size_t _Alignment, _In_ size_t _Offset);

_Check_return_ extern int     __cdecl __sbh_heap_init(_In_ size_t _Threshold);

_Check_return_ _Ret_opt_bytecap_(_Size) extern void *  __cdecl __sbh_alloc_block(_In_ int _Size);
_Check_return_ _Ret_opt_ extern PHEADER __cdecl __sbh_alloc_new_region(void);
_Check_return_ extern int     __cdecl __sbh_alloc_new_group(_In_ PHEADER _Header);

_Check_return_ extern PHEADER __cdecl __sbh_find_block(_In_ void * _Block);

#ifdef _DEBUG
_Check_return_ extern int     __cdecl __sbh_verify_block(_In_ PHEADER _Header, _In_ void * _Block);
#endif  /* _DEBUG */

extern void    __cdecl __sbh_free_block(_In_ PHEADER _Header, _Inout_ void * _Block);
_Check_return_ extern int     __cdecl __sbh_resize_block(_In_ PHEADER _Header, _Inout_ void * _Block, _In_ int _Size);

extern void    __cdecl __sbh_heapmin(void);

extern int     __cdecl __sbh_heap_check(void);


/************************ BEGIN BSM MODIFICATION ******************************/
// BSM wants to use stdcall rather than cdecl because it is typically faster
#undef __cdecl
/************************ END BSM MODIFICATION ********************************/

#ifdef __cplusplus
}
#endif  /* __cplusplus */

#ifdef _MSC_VER
#pragma pack(pop)
#endif  /* _MSC_VER */

#endif  /* _INC_WINHEAP */
