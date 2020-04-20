#include "ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(XIF_SEG)

#include "Compiler_i.h"
#include "DolphinSmalltalk_i.h"

IDolphin* GetVM();

_COM_SMARTPTR_TYPEDEF(ICompiler, __uuidof(ICompiler));
typedef HRESULT (STDAPICALLTYPE *GETCLASSOBJPROC)(REFCLSID rclsid, REFIID riid, LPVOID* ppv);

static HINSTANCE LoadCompiler()
{
	static HINSTANCE hCompiler = NULL;
	if (hCompiler == NULL)
		hCompiler = ::LoadLibraryW(L"DolphinCR7.DLL");
	return hCompiler;
}

static IClassFactoryPtr piFactory;

static ICompilerPtr NewCompiler()
{
	ICompilerPtr piCompiler;
	HRESULT hr = S_OK;

	if (!piFactory)
	{
		hr = CoGetClassObject(__uuidof(DolphinCompiler), CLSCTX_INPROC_SERVER, NULL, IID_IClassFactory, (void**)&piFactory);
		if (FAILED(hr))
		{
			HINSTANCE hLib = LoadCompiler();
			if (hLib)
			{
				// It loaded, now try invoking the class factory entry point
				GETCLASSOBJPROC pfnFactory = (GETCLASSOBJPROC)::GetProcAddress(HMODULE(hLib), "DllGetClassObject");
				if (pfnFactory)
				{
					// Found the entry point, try retrieving the factory
					hr = (*pfnFactory)(__uuidof(DolphinCompiler), IID_IClassFactory, (void**)&piFactory);
				}
			}
		}
	}

	if (SUCCEEDED(hr))
	{
		// Directly invoke the factory to instantiate a compiler instance
		hr = piFactory->CreateInstance(NULL, __uuidof(ICompiler), (void**)&piCompiler);
	}

	return piCompiler;
}

extern "C" Oop __stdcall PrimCompileForClass(Oop compilerOop, const char* szSource, Oop aClass, int flags, Oop notifier)
{
	ICompilerPtr piCompiler = NewCompiler();
	if (piCompiler == NULL)
		return Oop(GetVM()->NilPointer());

	return (Oop)piCompiler->CompileForClass(GetVM(), compilerOop, szSource, (POTE)aClass, static_cast<FLAGS>(flags), notifier);
}

extern "C" Oop __stdcall PrimCompileForEval(Oop compilerOop, const char* szSource, Oop aClassOrNil, Oop aWorkspacePool, int flags, Oop notifier)
{
	ICompilerPtr piCompiler = NewCompiler();
	if (piCompiler == NULL)
		return Oop(GetVM()->NilPointer());

	return (Oop)piCompiler->CompileForEval(GetVM(), compilerOop, szSource, (POTE)aClassOrNil, (POTE)aWorkspacePool, static_cast<FLAGS>(flags), notifier);
}


#include "Compiler_i.c"
