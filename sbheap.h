#pragma once

#define __sbh_alloc_block __dsbh_alloc_block 
#define __sbh_alloc_new_group __dsbh_alloc_new_group
#define __sbh_alloc_new_region __dsbh_alloc_new_region
#define __sbh_find_block __dsbh_find_block
//#define __sbh_verify_block __dsbh_verify_block
#define __sbh_free_block __dsbh_free_block
#define __sbh_heap_init __dsbh_heap_init
#define __sbh_heapmin __dsbh_heapmin
#define __sbh_resize_block __dsbh_resize_block
#define _get_sbh_threshold _get_dsbh_threshold
#define _set_sbh_threshold _set_dsbh_threshold

#define _crtheap _dsbheap

#define __sbh_threshold __dsbh_threshold
#define __sbh_pHeaderList  __dsbh_pHeaderList 
#define __sbh_pHeaderScan   __dsbh_pHeaderScan  
#define __sbh_sizeHeaderList __dsbh_sizeHeaderList
#define __sbh_cntHeaderList __dsbh_cntHeaderList
#define __sbh_pHeaderDefer __dsbh_pHeaderDefer
#define __sbh_indGroupDefer __dsbh_indGroupDefer
