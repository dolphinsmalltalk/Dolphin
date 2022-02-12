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

Oop* PRIMCALL Interpreter::primitiveHookWindowCreate(Oop* const sp, primargcount_t)
{
	Oop argPointer = *sp;
	OTE* underConstruction = m_oteUnderConstruction;
	OTE* receiverPointer = reinterpret_cast<OTE*>(*(sp - 1));

	if (!isNil(underConstruction) && underConstruction != receiverPointer)
	{
		if (argPointer == reinterpret_cast<Oop>(Pointers.Nil))
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM << L"WARNING: Forcibly unhooking create for " << std::hex << underConstruction << std::endl;
			ObjectMemory::nilOutPointer(m_oteUnderConstruction);
		}
		else
		{
			// Hooked by another window - fail the primitive
			return primitiveFailure(_PrimitiveFailureCode::IllegalStateChange);
		}
	}
	else
	{
		if (argPointer == Oop(Pointers.True))
		{
			// Hooking

			if (underConstruction != receiverPointer)
			{
				ASSERT(isNil(underConstruction));
				m_oteUnderConstruction = receiverPointer;
				receiverPointer->countUp();
			}
		}
		else
		{
			if (argPointer == Oop(Pointers.False))
			{
				// Unhooking
				if (underConstruction == receiverPointer)
				{
					tracelock lock(TRACESTREAM);
					TRACESTREAM << L"WARNING: Unhooking create for " << std::hex << underConstruction << L" before HCBT_CREATEWND" << std::endl;
					ObjectMemory::nilOutPointer(m_oteUnderConstruction);
				}
				else
					ASSERT(isNil(underConstruction));
			}
			else
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Invalid argument
		}
	}
	return sp - 1;
}

inline void Interpreter::subclassWindow(OTE* window, HWND hWnd)
{
	ASSERT(!ObjectMemoryIsIntegerObject(window));
	// As this is called from an external entry point, we must ensure that OT/stack overflows
	// are handled, and also that we catch the SE_VMCALLBACKUNWIND exceptions
	__try
	{
		bool bDisabled = disableInterrupts(true);
		Oop retVal = performWith(Oop(window), Pointers.subclassWindowSymbol, Oop(ExternalHandle::New(hWnd)));
		ObjectMemory::countDown(retVal);
		ASSERT(m_bInterruptsDisabled);
		disableInterrupts(bDisabled);
	}
	__except (callbackExceptionFilter(GetExceptionInformation()))
	{
		trace(L"WARNING: Unwinding Interpreter::subclassWindow(%#x, %#x)\n", window, hWnd);
	}
}


LRESULT CALLBACK Interpreter::CbtFilterHook(int code, WPARAM wParam, LPARAM lParam)
{
	// Looking for HCBT_CREATEWND, just pass others on...
	if (code == HCBT_CREATEWND)
	{
		//ASSERT(lParam != NULL);
		//LPCREATESTRUCT lpcs = ((LPCBT_CREATEWND)lParam)->lpcs;
		//ASSERT(lpcs != NULL);

		OTE* underConstruction = m_oteUnderConstruction;

		if (!isNil(underConstruction))
		{
			// Nil this out as soon as possible
			m_oteUnderConstruction = Pointers.Nil;
			underConstruction->countDown();

			ASSERT(wParam != NULL); // should be non-NULL HWND

									// set m_bDlgCreate to TRUE if it is a dialog box
									//  (this controls what kind of subclassing is done later)
									//pThreadState->m_bDlgCreate = (lpcs->lpszClass == WC_DIALOG);

									// Pass to Smalltalk for subclassing (catch unwind failures so not thrown out)
			subclassWindow(underConstruction, HWND(wParam));
		}
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

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeImage()
{
	// Before starting the Smalltalk, install the Windows CBT hook for catching window creates
	// Note that we don't bother installing and deinstalling this as we forward most messages
	// in double quick time (see CbtFilterHook), and also the MFC doesn't!
	hHookOldCbtFilter = ::SetWindowsHookEx(WH_CBT, CbtFilterHook, NULL, ::GetCurrentThreadId());
	if (hHookOldCbtFilter == NULL)
		return ReportError(IDP_FAILTOHOOK, ::GetLastError());

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