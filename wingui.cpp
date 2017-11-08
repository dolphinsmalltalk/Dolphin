/*
============
wingui.cpp
============
Interpreter/Windows GUI interface functions
*/
							
#include "Ist.h"

#ifdef _CONSOLE
	#error Not for use in console VM
#endif

#ifndef _DEBUG
	//#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "Interprt.h"
#include "ObjMem.h"
#include <stdarg.h>
#include <wtypes.h>
#include "rc_vm.h"

static HHOOK hHookOldCbtFilter;

#pragma code_seg()

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//

Oop* __fastcall Interpreter::primitiveHookWindowCreate(Oop* const sp)
{
	Oop argPointer = *sp;
	OTE* underConstruction = m_oteUnderConstruction;
	OTE* receiverPointer = reinterpret_cast<OTE*>(*(sp-1));

	if (!underConstruction->isNil() && underConstruction != receiverPointer)
	{
		// Hooked by another window - fail the primitive
		return primitiveFailureWith(1, underConstruction);
	}


	if (argPointer == Oop(Pointers.True))
	{
		// Hooking

		if (underConstruction != receiverPointer)
		{
			ASSERT(underConstruction->isNil());
			m_oteUnderConstruction= receiverPointer;
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
				TRACESTREAM << "WARNING: Unhooking create for " << hex << underConstruction << " before HCBT_CREATEWND" << endl;
				ObjectMemory::nilOutPointer(m_oteUnderConstruction);
			}
			else
				ASSERT(underConstruction->isNil());
		}
		else
			return primitiveFailureWith(0, argPointer);	// Invalid argument
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
		trace("WARNING: Unwinding Interpreter::subclassWindow(%#x, %#x)\n", window, hWnd);
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

		if (!underConstruction->isNil())
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

int __stdcall DolphinMessage(UINT flags, const char* msg)
{
	char szCaption[512];
	HMODULE hExe = GetModuleHandle(NULL);
	if (!::LoadString(hExe, IDS_APP_TITLE, szCaption, sizeof(szCaption)-1))
		GetModuleFileName(hExe, szCaption, sizeof(szCaption));
	return  ::MessageBox(NULL, msg, szCaption, flags|MB_TASKMODAL);
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

void __stdcall DolphinFatalExit(int /*exitCode*/, const char* msg)
{
	FatalAppExit(0, msg);
}

