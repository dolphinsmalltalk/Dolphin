#pragma once

#include "ComObject.h"

template<typename T>
class ComClassFactory : public ComObject<IClassFactory>
{
public:
	ComClassFactory() = default;

	virtual HRESULT STDMETHODCALLTYPE CreateInstance(_In_opt_  IUnknown* pUnkOuter,
		_In_  REFIID riid,
		_COM_Outptr_  void** ppvObject)
	{
		if (pUnkOuter != nullptr)
			return CLASS_E_NOAGGREGATION;

		T* pT = new T();
		HRESULT hr = pT->QueryInterface(riid, ppvObject);
		if (FAILED(hr))
			delete pT;
		return hr;
	}

	virtual HRESULT STDMETHODCALLTYPE LockServer(_In_ BOOL fLock)
	{
		if (fLock)
		{
			LockModule();
		}
		else
		{
			UnlockModule();
		}
		return S_OK;
	}

private:
};
