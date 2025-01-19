#pragma once

#include <WinBase.h>

class ActivationContext
{
public:
	ActivationContext() = delete;

	ActivationContext(HMODULE hModule) 
	{
		m_actctx.hModule = hModule;
	}

	~ActivationContext()
	{
		Release();
	}

	// Copy/Move may make sense, but we don't need them for now
	ActivationContext(const ActivationContext&) = delete;
	ActivationContext& operator=(const ActivationContext&) = delete;
	ActivationContext(ActivationContext&&) = delete;
	ActivationContext& operator=(ActivationContext&&) = delete;

public:

	__declspec(property(get = get_moduleHandle, put = put_moduleHandle)) HMODULE ModuleHandle;
	HMODULE get_moduleHandle() const throw()
	{
		return m_actctx.hModule;
	}

	__declspec(property(get = get_source, put = put_source)) LPCWSTR Source;
	LPCWSTR get_source() const throw()
	{
		return m_actctx.lpSource;
	}
	void put_source(_In_ LPCWSTR lpSource) throw()
	{
		m_actctx.lpSource = lpSource;
		SetFlag(ACTCTX_FLAG_SOURCE_IS_ASSEMBLYREF, lpSource);
	}

	__declspec(property(get = get_processorArchitecture, put = put_processorArchitecture)) USHORT ProcessorArchitecture;
	USHORT get_processorArchitecture() const throw()
	{
		return m_actctx.wProcessorArchitecture;
	}
	void put_processorArchitecture(_In_ USHORT wProcessorArchitecture) throw()
	{
		m_actctx.wProcessorArchitecture = wProcessorArchitecture;
		SetFlag(ACTCTX_FLAG_PROCESSOR_ARCHITECTURE_VALID, wProcessorArchitecture);
	}

	__declspec(property(get = get_langId, put = put_langId)) USHORT LangId;
	USHORT get_langId() const throw()
	{
		return m_actctx.wLangId;
	}
	void put_langId(_In_ USHORT wLangId) throw()
	{
		m_actctx.wLangId = wLangId;
		SetFlag(ACTCTX_FLAG_LANGID_VALID, wLangId);
	}

	__declspec(property(get = get_assemblyDirectory, put = put_assemblyDirectory)) LPCWSTR AssemblyDirectory;
	LPCWSTR get_assemblyDirectory() const throw()
	{
		return m_actctx.lpAssemblyDirectory;
	}
	void put_assemblyDirectory(_In_ LPCWSTR lpAssemblyDirectory) throw()
	{
		m_actctx.lpAssemblyDirectory = lpAssemblyDirectory;
		SetFlag(ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID, lpAssemblyDirectory);
	}

	__declspec(property(get = get_resourceName, put = put_resourceName)) LPCWSTR ResourceName;
	LPCWSTR get_resourceName() const throw()
	{
		return m_actctx.lpResourceName;
	}
	void put_resourceName(_In_ LPCWSTR lpResourceName) throw()
	{
		m_actctx.lpResourceName = lpResourceName;
		SetFlag(ACTCTX_FLAG_RESOURCE_NAME_VALID, lpResourceName);
	}

	__declspec(property(get = get_resourceId, put = put_resourceId)) uintptr_t ResourceId;
	uintptr_t get_resourceId() const throw()
	{
		return reinterpret_cast<uintptr_t>(m_actctx.lpResourceName);
	}
	void put_resourceId(_In_ uintptr_t id) throw()
	{
		put_resourceName(MAKEINTRESOURCE(id));
	}

	__declspec(property(get = get_applicationName, put = put_applicationName)) LPCWSTR ApplicationName;
	LPCWSTR get_applicationName() const throw()
	{
		return m_actctx.lpApplicationName;
	}
	void put_applicationName(_In_ LPCWSTR lpApplicationName) throw()
	{
		m_actctx.lpApplicationName = lpApplicationName;
		SetFlag(ACTCTX_FLAG_APPLICATION_NAME_VALID, lpApplicationName);
	}

	__declspec(property(get = get_isProcessDefault, put = put_isProcessDefault)) bool IsProcessDefault;
	bool get_isProcessDefault() const throw()
	{
		return m_actctx.dwFlags & ACTCTX_FLAG_SET_PROCESS_DEFAULT;
	}
	void put_isProcessDefault(_In_ bool isProcessDefault) throw()
	{
		SetFlag(ACTCTX_FLAG_SET_PROCESS_DEFAULT, isProcessDefault);
	}

	__declspec(property(get = get_handle)) HANDLE Handle;
	HANDLE get_handle() const
	{
		DWORD dwErr = 0;
		if (!m_created) {
			m_hCtx = ::CreateActCtx(&m_actctx);
			if (m_hCtx == INVALID_HANDLE_VALUE)
			{
				dwErr = ::GetLastError();
				_com_raise_error(HRESULT_FROM_WIN32(dwErr));
			}
			m_created = true;
		}
		return m_hCtx;
	}

private:
	void Release()
	{
		if (m_created) {
			::ReleaseActCtx(m_hCtx);
			m_created = false;
		}
	}

	void SetFlag(DWORD flag, bool value) throw()
	{
		m_actctx.dwFlags = value
			? m_actctx.dwFlags | flag
			: m_actctx.dwFlags & ~flag;
	}

private:
	ACTCTXW m_actctx = { 
		.cbSize = sizeof(m_actctx), 
		.dwFlags = ACTCTX_FLAG_HMODULE_VALID| ACTCTX_FLAG_RESOURCE_NAME_VALID, 
		.lpResourceName = ISOLATIONAWARE_MANIFEST_RESOURCE_ID
	};
	mutable HANDLE m_hCtx = nullptr;
	mutable bool m_created = false;
};

class ActivationContextScope
{
public:
	ActivationContextScope() = delete;
	ActivationContextScope(const ActivationContext& context)
		: m_cookie(Activate(context.Handle)) {
	}

	~ActivationContextScope()
	{
		if (m_cookie) {
			::DeactivateActCtx(0, m_cookie);
		}
	}

	// Not copyable
	ActivationContextScope(const ActivationContextScope&) = delete;
	ActivationContextScope& operator=(const ActivationContextScope&) = delete;

	// But can be moved
	ActivationContextScope(ActivationContextScope&& other) noexcept
		: m_cookie(other.m_cookie)
	{
		other.m_cookie = 0;
	}

	ActivationContextScope& operator=(ActivationContextScope&& other) noexcept = delete;

private:
	static ULONG_PTR Activate(HANDLE hContext)
	{
		ULONG_PTR cookie = 0;
		::ActivateActCtx(hContext, &cookie);
		return cookie;
	}

private:
	ULONG_PTR m_cookie = 0;
};
