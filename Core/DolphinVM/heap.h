#pragma once
#include <vcruntime.h>

// Unfortunately we have to define the mimalloc functions because it does not specify a calling convention in the header
// and it's .lib is built with __cdecl calling convention. This means that if we include mimalloc.h into code built
// with a different calling convention, the declarations won't match the actual definitions in the .lib

#define mi_decl_restrict          __declspec(restrict)
#define mi_attr_alloc_size(s)
#define mi_attr_alloc_size2(s1,s2)
#define mi_attr_alloc_align(p)
#define mi_decl_export
#define mi_attr_malloc

#ifdef __cplusplus
#define mi_decl_nodiscard    _NODISCARD
#define mi_attr_noexcept throw()
extern "C"
{
#else
#define mi_attr_noexcept
#define mi_decl_nodiscard
#endif

// Same definitions as in mimalloc.h, except with explicit __cdecl to match what the library project will build

mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_malloc(size_t size)  mi_attr_noexcept mi_attr_malloc mi_attr_alloc_size(1);
mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_calloc(size_t count, size_t size)  mi_attr_noexcept mi_attr_malloc mi_attr_alloc_size2(1, 2);
mi_decl_nodiscard mi_decl_export void* __cdecl mi_realloc(void* p, size_t newsize)      mi_attr_noexcept mi_attr_alloc_size(2);

mi_decl_export void __cdecl mi_free(void* p) mi_attr_noexcept;

mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_malloc_aligned(size_t size, size_t alignment) mi_attr_noexcept mi_attr_malloc mi_attr_alloc_size(1) mi_attr_alloc_align(2);

mi_decl_nodiscard mi_decl_export void* __cdecl mi_recalloc(void* p, size_t newcount, size_t size)  mi_attr_noexcept mi_attr_alloc_size2(2, 3);

mi_decl_nodiscard mi_decl_export size_t __cdecl mi_usable_size(const void* p) mi_attr_noexcept;

mi_decl_nodiscard mi_decl_export mi_decl_restrict unsigned short* __cdecl mi_wcsdup(const unsigned short* s) mi_attr_noexcept mi_attr_malloc;

mi_decl_export void __cdecl mi_free_size(void* p, size_t size)                           mi_attr_noexcept;
mi_decl_export void __cdecl mi_free_size_aligned(void* p, size_t size, size_t alignment) mi_attr_noexcept;
mi_decl_export void __cdecl mi_free_aligned(void* p, size_t alignment)                   mi_attr_noexcept;
mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_new_aligned_nothrow(size_t size, size_t alignment) mi_attr_noexcept mi_attr_malloc mi_attr_alloc_size(1) mi_attr_alloc_align(2);

mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_new(size_t size)                   mi_attr_malloc mi_attr_alloc_size(1);
mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_new_aligned(size_t size, size_t alignment) mi_attr_malloc mi_attr_alloc_size(1) mi_attr_alloc_align(2);
mi_decl_nodiscard mi_decl_export mi_decl_restrict void* __cdecl mi_new_nothrow(size_t size)           mi_attr_noexcept mi_attr_malloc mi_attr_alloc_size(1);

#ifdef __cplusplus
}
#endif

#pragma push_macro("MIMALLOC_H")
#define MIMALLOC_H
#include "mimalloc-override.h"
#pragma pop_macro("MIMALLOC_H")

#pragma comment(lib, "mimalloc-static.lib")