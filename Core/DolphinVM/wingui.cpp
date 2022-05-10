/*
============
wingui.cpp
============
Interpreter/Windows GUI interface functions
*/
							
#include "Ist.h"

#ifndef _DEBUG
	//#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "Interprt.h"
#include "ObjMem.h"
#include "rc_vm.h"

#pragma code_seg()

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//

#ifdef _CONSOLE

__declspec(noreturn) void __stdcall DolphinFatalExit(int exitCode, const wchar_t* msg)
{
	int result = fwprintf(stderr, L"%s\n", msg);
	FatalExit(exitCode);
}

int __stdcall DolphinMessage(UINT flags, const wchar_t* msg)
{
	fwprintf(stderr, L"%s\n", msg);
	return 0;
}

Oop* PRIMCALL Interpreter::primitiveHookWindowCreate(Oop* const sp, primargcount_t)
{
	return primitiveFailure(_PrimitiveFailureCode::NotSupported);
}

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeImage()
{
	// Nothing to do
	return S_OK;
}

#pragma code_seg(TERM_SEG)
void Interpreter::GuiShutdown()
{
}

#else

static HHOOK hHookOldCbtFilter;

void Interpreter::windowCreated(HWND hWnd, LPVOID lpCreateParams)
{
	// As this is called from an external entry point, we must ensure that OT/stack overflows
	// are handled, and also that we catch the SE_VMCALLBACKUNWIND exceptions
	__try
	{
		Oop oopWndHandle = reinterpret_cast<Oop>(ExternalHandle::New(hWnd));
		Oop oopCreateParam = Integer::NewUIntPtr(reinterpret_cast<uintptr_t>(lpCreateParams));
		bool bDisabled = disableInterrupts(true);
		performWithWith(reinterpret_cast<Oop>(Pointers.Dispatcher), Pointers.windowCreatedSelector, oopWndHandle, oopCreateParam);
		ASSERT(m_bInterruptsDisabled);
		disableInterrupts(bDisabled);
	}
	__except (callbackExceptionFilter(GetExceptionInformation()))
	{
		trace(L"WARNING: Unwinding Interpreter::windowCreated(%#x, %#x)\n", hWnd, lpCreateParams);
	}
}


LRESULT CALLBACK Interpreter::CbtFilterHook(int code, WPARAM wParam, LPARAM lParam)
{
	// Looking for HCBT_CREATEWND, just pass others on...
	if (code == HCBT_CREATEWND)
	{
		LPCBT_CREATEWNDW pCbtCreateWnd = reinterpret_cast<LPCBT_CREATEWNDW>(lParam);
		LPCREATESTRUCT pCreateStruct = pCbtCreateWnd->lpcs;
		LPVOID createParam = pCreateStruct->lpCreateParams;

		// Aside from when creating dialogs, we always pass a non-zero integer index parameter to CreateWindowEx to identify the window being created
		// Ignore other windows that are being created, e.g. tooltips, the listview header control, etc
		if (createParam != nullptr || pCreateStruct->lpszClass == WC_DIALOG)
		{
			// Pass to Smalltalk for attach/subclassing (catch unwind failures so not thrown out)
			windowCreated(HWND(wParam), createParam);
		}
	}

	return ::CallNextHookEx(hHookOldCbtFilter, code, wParam, lParam);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//

inline LRESULT Interpreter::subclassProcResultFromOop(Oop objectPointer, HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	if (ObjectMemoryIsIntegerObject(objectPointer))
		// The result is a SmallInteger (the most common answer we hope)
		return ObjectMemoryIntegerValueOf(objectPointer);

	OTE* ote = reinterpret_cast<OTE*>(objectPointer);
	if (ote->isBytes())
	{
		ASSERT(ote->bytesSize() <= 8);
		LargeInteger* l32i = static_cast<LargeInteger*>(ote->m_location);
		LRESULT lResult = l32i->m_digits[0];
		ote->countDown();
		return lResult;
	}

	trace(L"DolphinSubclassProc: Non-LRESULT value returned for MSG(hwnd:%p, msg:%u, wParam:%x, lParam:%x)\n",
		hWnd, uMsg, wParam, lParam);

	ote->countDown();

	// Non-LRESULT returned, so do the only thing possible - call the default subclass procedure
	return ::DefSubclassProc(hWnd, uMsg, wParam, lParam);
}

// Common subclass procedure for all Dolphin control windows (dispatching handled in Smalltalk)
LRESULT CALLBACK Interpreter::DolphinSubclassProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, UINT_PTR uIdSubclass, DWORD_PTR dwRefData)
{
	//CHECKREFERENCES
#ifdef _DEBUG
	if (ObjectMemoryIntegerValueOf(m_registers.m_pActiveFrame->m_ip) > 1024)
		_asm int 3;
#endif

	ResetInputPollCounter();

	LRESULT lResult;

	__try
	{
		// N.B. All allocation and pushing must be performed within the try
		// block in case either stack or object table overflow occurs,
		// and we must not pass exceptions back over the window process
		// boundary as the originator could be a send message in non-Smalltalk
		// code.

		pushObject(Pointers.Dispatcher);
		pushUintPtr(reinterpret_cast<uintptr_t>(hWnd));
		pushUint32(uMsg);
		pushUintPtr(wParam);
		pushUintPtr(lParam);
		pushUintPtr(uIdSubclass);
		pushUint32(dwRefData);

		disableInterrupts(true);
		Oop lResultOop = callback(Pointers.subclassProcSelector, 6 TRACEARG(TRACEFLAG::TraceOff));

		// Decode result
		lResult = subclassProcResultFromOop(lResultOop, hWnd, uMsg, wParam, lParam);
	}
	__except (callbackExceptionFilter(GetExceptionInformation()))
	{
		// N.B. callbackExceptionFilter() catches SE_VMCALLBACKUNWIND exceptions
		// and passes them to this handler

		lResult = 0;

		// Answer some default return value appropriate for the window message
		switch (uMsg)
		{
		case WM_CREATE:
			// Fail creation
			lResult = -1;
			break;

		case WM_PAINT:
			// We don't want to get the paint again, so just validate it
			::ValidateRect(hWnd, NULL);
			break;

		default:
			break;
		}

#ifdef _DEBUG
		{
			trace(L"WARNING: Unwinding DolphinSubclassProc(%#x, %d, %d, %d) ret: %d\n",
				hWnd, uMsg, wParam, lParam, lResult);
		}
#endif
	}

	// On exit from SubclassProc, interrupts are always enabled
	disableInterrupts(false);
	return lResult;
}

// All messages are dispatched through DolphinWndProc. The purpose of this procedure is to act as a
// target for calls to default window processing
LRESULT CALLBACK Interpreter::DolphinDlgProc(HWND /*hWnd*/, UINT /*uMsg*/, WPARAM /*wParam*/, LPARAM /*lParam*/)
{
	return FALSE;
}

int __stdcall DolphinMessage(UINT flags, const wchar_t* msg)
{
	HMODULE hExe = GetModuleHandle(NULL);
	int length;
	LPCWSTR szAppTitle = GetResourceString(hExe, IDS_APP_TITLE, length);
	if (szAppTitle != nullptr)
	{
		std::wstring appTitle(szAppTitle, length);
		return ::MessageBoxW(NULL, msg, appTitle.c_str(), flags | MB_TASKMODAL);
	}
	else
	{
		WCHAR filename[_MAX_PATH + 1];
		GetModuleFileNameW(hExe, filename, _countof(filename));
		return  ::MessageBoxW(NULL, msg, filename, flags | MB_TASKMODAL);
	}
}

#ifdef DEBUG_HOOKS
static HHOOK oldDebugHook = nullptr;
static std::wstring codeNames[] = {
L"WH_JOURNALRECORD", L"WH_JOURNALPLAYBACK", L"WH_KEYBOARD", L"WH_GETMESSAGE", L"WH_CALLWNDPROC",
L"WH_CBT", L"WH_SYSMSGFILTER", L"WH_MOUSE", L"WH_HARDWARE", L"WH_DEBUG", L"WH_SHELL", L"WH_FOREGROUNDIDLE",
L"WH_CALLWNDPROCRET", L"WH_KEYBOARD_LL", L"WH_MOUSE_LL" };
static std::wstring hookCodes[] = { L"HC_ACTION", L"HC_GETNEXT", L"HC_SKIP", L"HC_NOREMOVE", L"HC_SYSMODALON", L"HC_SYSMODALOFF" };
static std::wstring cbtHookCodes[] = { L"HCBT_MOVESIZE", L"HCBT_MINMAX", L"HCBT_QS", L"HCBT_CREATEWND", L"HCBT_DESTROYWND", L"HCBT_ACTIVATE", L"HCBT_CLICKSKIPPED", L"HCBT_KEYSKIPPED", L"HCBT_SYSCOMMAND", L"HCBT_SETFOCUS" };

LRESULT CALLBACK DebugHookProc(int code, WPARAM wParam, LPARAM lParam)
{
	if (code >= 0)
	{
		auto pHookInfo = reinterpret_cast<DEBUGHOOKINFO*>(lParam);
		thinDump << L"DebugHookProc(code: " << hookCodes[code] << L", wParam: " << codeNames[wParam] << L", lParam: " 
			<< L"DEBUGHOOKINFO(idThread: " << std::dec << pHookInfo->idThread << L", idThreadInstaller: " << pHookInfo->idThreadInstaller
			<< L", lParam: " << std::hex << pHookInfo->lParam << L", wParam: " << pHookInfo->wParam << L", code: " 
			<< (wParam == WH_CBT ? cbtHookCodes[pHookInfo->code] : hookCodes[pHookInfo->code]) << L"))" << std::endl;
	}
	return ::CallNextHookEx(oldDebugHook, code, wParam, lParam);
}
#endif

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeImage()
{
	// Before starting the Smalltalk, install the Windows CBT hook for catching window creates
	// Note that we don't bother installing and deinstalling this as we forward most messages
	// in double quick time (see CbtFilterHook), and also the MFC doesn't!
	hHookOldCbtFilter = ::SetWindowsHookEx(WH_CBT, CbtFilterHook, NULL, ::GetCurrentThreadId());
	if (hHookOldCbtFilter == NULL)
		return ReportError(IDP_FAILTOHOOK, ::GetLastError());

#ifdef DEBUG_HOOKS
	oldDebugHook = ::SetWindowsHookEx(WH_DEBUG, DebugHookProc, NULL, ::GetCurrentThreadId());
#endif

	return S_OK;
}

#pragma code_seg(TERM_SEG)
void Interpreter::GuiShutdown()
{
	if (hHookOldCbtFilter != NULL)
		VERIFY(::UnhookWindowsHookEx(hHookOldCbtFilter));
	hHookOldCbtFilter = NULL;
}

__declspec(noreturn) void __stdcall DolphinFatalExit(int /*exitCode*/, const wchar_t* msg)
{
	FatalAppExitW(0, msg);
}

#endif