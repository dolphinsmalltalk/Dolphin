// stdafx.h : include file for standard system include files,
//      or project specific include files that are used frequently,
//      but are changed infrequently

#if !defined(AFX_STDAFX_H__5B368551_FF0C_4CB0_9CC9_6B922BE2F3A7__INCLUDED_)
#define AFX_STDAFX_H__5B368551_FF0C_4CB0_9CC9_6B922BE2F3A7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifdef _DEBUG
#define _ATL_DEBUG_INTERFACES
#endif

#define UMDF_USING_NTSTATUS
typedef long NTSTATUS;
#include <ntstatus.h>

#include <atlbase.h>
#include <atlcom.h>

#include <comdef.h>
#include <map>

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_STDAFX_H__5B368551_FF0C_4CB0_9CC9_6B922BE2F3A7__INCLUDED)
