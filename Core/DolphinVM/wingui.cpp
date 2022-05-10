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

		// Pass to Smalltalk for attach/subclassing (catch unwind failures so not thrown out)
		windowCreated(HWND(wParam), createParam);
	}

	return ::CallNextHookEx(hHookOldCbtFilter, code, wParam, lParam);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//

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