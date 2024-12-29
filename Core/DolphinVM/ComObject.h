#pragma once

#include <unknwn.h>
#include <comdef.h>

class ComObjectBase
{
public:
	virtual ~ComObjectBase() {}

	void LockModule();
	void UnlockModule();
};

class ComObjectBaseNoLock
{
public:
	void LockModule() {}
	void UnlockModule() {}
};

template<typename T, LPCWSTR PrgId = nullptr, LPCWSTR VerIndProgId = nullptr, typename Base = ComObjectBase>
class ComObject : protected Base, public T
{
public:
	static constexpr LPCWSTR ProgId = PrgId;
	static constexpr LPCWSTR VersionIndependentProgId = VerIndProgId;

	ComObject() = default;

	// IUnknown 
	virtual HRESULT STDMETHODCALLTYPE QueryInterface(_In_ REFIID riid, _COM_Outptr_ void** ppvObject)
	{
		// Check parameters.
		if (ppvObject == nullptr)
			return E_POINTER;

		*ppvObject = nullptr;
		if (riid == __uuidof(T) || riid == __uuidof(IUnknown))
		{
			*ppvObject = static_cast<T*>(this);
			AddRef();
			return S_OK;
		}

		return E_NOINTERFACE;
	}

	virtual ULONG STDMETHODCALLTYPE AddRef()
	{
		ULONG nRefs = ::InterlockedIncrement(&m_nRefs);
		if (nRefs == 1)
		{
			Base::LockModule();
		}

		return nRefs;
	}

	virtual ULONG STDMETHODCALLTYPE Release()
	{
		ASSERT(m_nRefs > 0);

		ULONG nRefs = ::InterlockedDecrement(&m_nRefs);
		if (nRefs == 0)
		{
			Base::UnlockModule();
			delete this;
		}

		return nRefs;
	}

private:
	unsigned int m_nRefs = 0;
};
