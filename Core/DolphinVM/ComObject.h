#pragma once

#include <unknwn.h>
#include <comdef.h>
#include <concepts>
#include <utility>

class ComObjectBase
{
public:
	virtual ~ComObjectBase() {}

	void LockModule();
	void UnlockModule();
};

class ComObjectBaseNoModuleLock
{
public:
	void LockModule() {}
	void UnlockModule() {}
};

template <LPCWSTR PId, LPCWSTR VIPId, int DescId=0, LPCWSTR ELK=nullptr> 
class ComRegistrationDetails
{
public:
	static constexpr LPCWSTR ProgId = PId;
	static constexpr LPCWSTR VersionIndependentProgId = VIPId;
	static constexpr int DescriptionResourceId = DescId;
	static constexpr LPCWSTR EventLogKey = ELK;
};

typedef ComRegistrationDetails<nullptr, nullptr> NullComRegistration;

template<typename RegDetails = NullComRegistration, typename Base = ComObjectBase, std::derived_from<IUnknown>... Interfaces>
class ComObject : protected Base, public Interfaces...
{
public:
	ComObject() = default;

	template <typename Ti, typename... Tis> constexpr HRESULT QueryInterfaces(REFIID riid, void** ppvObject)
	{
		if (riid == __uuidof(Ti)) {
			*ppvObject = static_cast<Ti*>(this);
			AddRef();
			return S_OK;
		}

		if constexpr (!sizeof...(Tis))	{
			return E_NOINTERFACE;
		} else {
			return QueryInterfaces<Tis... >(riid, ppvObject);
		}
	}

	// IUnknown 
	virtual HRESULT STDMETHODCALLTYPE QueryInterface(_In_ REFIID riid, _COM_Outptr_ void** ppvObject)
	{
		// Check parameters.
		if (ppvObject == nullptr)
			return E_POINTER;

		*ppvObject = nullptr;
		if (riid == __uuidof(IUnknown))
		{
			// Need C++26 for direct pack indexing
			using Ti = std::tuple_element_t<0,std::tuple<Interfaces...>>;
			*ppvObject = static_cast<Ti*>(this);
			AddRef();
			return S_OK;
		}

		return QueryInterfaces<Interfaces... >(riid, ppvObject);
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
		ULONG nRefs = ::InterlockedDecrement(&m_nRefs);
		if (nRefs == 0)
		{
			Base::UnlockModule();
			delete this;
		}

		return nRefs;
	}

public:
	using RegistrationDetails = RegDetails;

private:
	unsigned int m_nRefs = 0;
};
