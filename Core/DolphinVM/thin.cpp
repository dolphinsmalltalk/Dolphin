// thin.cpp
// The thin.exe is executed with either a .img file as an argument or
// else the default .img file is used

#include "ist.h"
#include "DolphinSmalltalk.h"

/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
int APIENTRY 
WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	::CoInitialize(NULL);

	CComObject<CDolphinSmalltalk>* pDolphin;
	HRESULT hr = CComObject<CDolphinSmalltalk>::CreateInstance(&pDolphin);
	pDolphin->AddRef();

	_ASSERTE(SUCCEEDED(hr));
	int nRet = pDolphin->Start(hInstance, hPrevInstance, lpCmdLine, nCmdShow, 0, NULL, NULL);

	pDolphin->Release();

	::CoUninitialize();
	return nRet;
}


