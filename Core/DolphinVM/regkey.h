/******************************************************************************

	File: RegKey.h

	Description:

******************************************************************************/
#pragma once
#include <Shlwapi.h>
#include <memory>

// For deriving a unique_ptr to safely delete memory allocated by, e.g. StringFromCLSID.
struct CoTaskMemDeleter
{
	void operator()(void* p) const { ::CoTaskMemFree(p); }
};

typedef std::unique_ptr<OLECHAR, CoTaskMemDeleter> CoTaskMemString;

// Simple RegKey class to replace ATL CRegKey
// It could be much more elegant using exceptions, but we follow the pattern of CRegKey

class RegKey
{
	HKEY m_hKey = nullptr;

private:
	void Copy(const RegKey& other) throw()
	{
		m_hKey = SHRegDuplicateHKey((HKEY)other);
	}

	void Move(RegKey& other) throw()
	{
		m_hKey = other.m_hKey;
		other.m_hKey = nullptr;
	}

public:
	RegKey() = default;
	RegKey(HKEY hKey) throw()
		: m_hKey(hKey)
	{}

	RegKey(RegKey& other) throw()
	{
		Copy(other);
	}

	RegKey(RegKey&& other) throw()
	{
		Move(other);
	}

	RegKey& operator=(const RegKey& other) throw()
	{
		if (m_hKey != other.m_hKey)
		{
			Close();
			Copy(other);
		}
		return *this;
	}

	RegKey& operator=(RegKey&& other) throw()
	{
		if (m_hKey != other.m_hKey)
		{
			Close();
			Move(other);
		}
		return *this;
	}

	~RegKey() throw()
	{
		Close();
	}

public:
	operator HKEY() const throw()
	{
		return m_hKey;
	}

	LSTATUS OpenDolphinKey(LPCWSTR lpszKeyName, REGSAM samDesired = KEY_READ);

	LSTATUS SetDWORDValue(LPCWSTR pszValueName, DWORD dwValue) throw();
	LSTATUS SetStringValue(LPCWSTR pszValueName, LPCWSTR pszValue, DWORD dwType = REG_SZ) throw();
	LSTATUS QueryDWORDValue(LPCWSTR pszValueName, DWORD& dwValue) throw();
	LSTATUS QueryStringValue(LPCWSTR pszValueName, LPWSTR pszValue, ULONG& pnChars) throw();
	LSTATUS SetKeyValue(LPCWSTR lpszKeyName, LPCWSTR lpszValue, LPCWSTR lpszValueName = nullptr) throw();

	// Create a new registry key (or open an existing one).
	LSTATUS Create(HKEY hKeyParent, LPCWSTR lpszKeyName, LPWSTR lpszClass = REG_NONE, 
		DWORD dwOptions = REG_OPTION_NON_VOLATILE, REGSAM samDesired = KEY_READ | KEY_WRITE) throw();
	
	LSTATUS Open(HKEY hKeyParent, LPCWSTR lpszKeyName, REGSAM samDesired = KEY_READ | KEY_WRITE) throw();

	// Close the registry key.
	LSTATUS Close() throw()
	{
		LSTATUS ret = ERROR_SUCCESS;
		if (m_hKey != nullptr)
		{
			ret = RegCloseKey(m_hKey);
			m_hKey = nullptr;
		}
		return ret;
	}

	// Detach the CRegKey object from its HKEY.  Releases ownership.
	HKEY Detach() throw()
	{
		HKEY hKey = m_hKey;
		m_hKey = nullptr;
		return hKey;
	}
	
	// Attach the CRegKey object to an existing HKEY.  Takes ownership.
	void Attach(HKEY hKey) throw()
	{
		Close();
		m_hKey = hKey;
	}

	LSTATUS RecurseDeleteKey(LPCWSTR lpszKey) throw();
};

class RegKeyRedirect
{
	HKEY m_redirected = nullptr;
public:
	RegKeyRedirect() = default;
	RegKeyRedirect(const RegKeyRedirect&) = delete;
	RegKeyRedirect& operator=(const RegKeyRedirect&) = delete;
	RegKeyRedirect(RegKeyRedirect&& other) noexcept
	{
		m_redirected = other.m_redirected;
		other.m_redirected = nullptr;
	}
	~RegKeyRedirect() { Revert(); }

	LSTATUS Redirect(HKEY keyToRedirect, HKEY targetHive, LPCWSTR targetName, REGSAM samDesired= KEY_ALL_ACCESS)
	{
		// Note that the docs are explicit that we don't need to keep the key open as the system maintains
		// its own ref to the handle, so we can use a temp Regkey instance.
		RegKey targetKey;
		LSTATUS status = targetKey.Open(targetHive, targetName, samDesired);
		if (status == ERROR_SUCCESS)
		{
			status = ::RegOverridePredefKey(keyToRedirect, targetKey);
			if (status == ERROR_SUCCESS)
			{
				m_redirected = keyToRedirect;
			}
		}
		return status;
	}

	LSTATUS Revert()
	{
		LSTATUS status = ERROR_SUCCESS;
		if (m_redirected)
		{
			status = ::RegOverridePredefKey(m_redirected, nullptr);
			m_redirected = nullptr;
		}
		return status;
	}
};

inline LSTATUS RegKey::OpenDolphinKey(LPCWSTR lpszKeyName, REGSAM samDesired)
{
	Close();
	constexpr WCHAR DolphinKeyRoot[] = L"Software\\Object Arts\\Dolphin Smalltalk";
	if (!*lpszKeyName)
		return Open(HKEY_CURRENT_USER, DolphinKeyRoot, samDesired);

	size_t cch = wcslen(DolphinKeyRoot) + wcslen(lpszKeyName) + 2;
	std::unique_ptr<WCHAR[]> key(new WCHAR[cch]);
	wcscpy_s(key.get(), cch, DolphinKeyRoot);
	wcscat_s(key.get(), cch, L"\\");
	wcscat_s(key.get(), cch, lpszKeyName);

	return Open(HKEY_CURRENT_USER, key.get(), samDesired);	
}

inline LSTATUS RegKey::Open(HKEY hKeyParent, LPCWSTR lpszKeyName, REGSAM samDesired) throw()
{
	_ASSERTE(hKeyParent != nullptr);
	Close();
	return RegOpenKeyEx(hKeyParent, lpszKeyName, 0, samDesired, &m_hKey);
}

inline LSTATUS RegKey::Create(HKEY hKeyParent, LPCWSTR lpszKeyName, LPWSTR lpszClass, DWORD dwOptions, REGSAM samDesired) throw()
{
	Close();
	return RegCreateKeyEx(hKeyParent, lpszKeyName, 0, lpszClass, dwOptions, samDesired, nullptr, &m_hKey, nullptr);
}

inline LSTATUS RegKey::RecurseDeleteKey(LPCWSTR lpszKey) throw()
{
	return RegDeleteTree(m_hKey, lpszKey);
}

inline LSTATUS RegKey::SetKeyValue(LPCTSTR lpszKeyName, LPCTSTR lpszValue, LPCTSTR lpszValueName) throw()
{
	_ASSERTE(lpszValue != nullptr);
	RegKey key;
	LSTATUS ret = key.Create(m_hKey, lpszKeyName, REG_NONE, REG_OPTION_NON_VOLATILE, KEY_READ | KEY_WRITE);
	if (ret == ERROR_SUCCESS)
	{
		ret = key.SetStringValue(lpszValueName, lpszValue);
	}
	return ret;
}

inline LSTATUS RegKey::SetStringValue(LPCTSTR pszValueName, LPCTSTR pszValue, DWORD dwType) throw()
{
	_ASSERTE(m_hKey);
	if (pszValue == nullptr || !((dwType == REG_SZ) || (dwType == REG_EXPAND_SZ)))
	{
		return ERROR_INVALID_PARAMETER;
	}

	return ::RegSetValueEx(m_hKey, pszValueName, 0, dwType, reinterpret_cast<const BYTE*>(pszValue), (static_cast<DWORD>(wcslen(pszValue)) + 1) * sizeof(WCHAR));
}

inline LSTATUS RegKey::QueryDWORDValue(LPCTSTR pszValueName, DWORD& dwValue) throw()
{
	_ASSERTE(m_hKey);

	ULONG nBytes = sizeof(DWORD);
	DWORD dwType;
	LSTATUS ret = ::RegQueryValueEx(m_hKey, pszValueName, nullptr, &dwType, reinterpret_cast<LPBYTE>(&dwValue), &nBytes);
	if (ret != ERROR_SUCCESS)
		return ret;
	if (dwType != REG_DWORD)
		return ERROR_INVALID_DATA;

	return ERROR_SUCCESS;
}

inline LSTATUS RegKey::QueryStringValue(LPCWSTR pszValueName, LPWSTR pszValue, ULONG& nChars) throw()
{
	_ASSERTE(m_hKey);

	ULONG nBytes = nChars * sizeof(WCHAR);
	nChars = 0;
	DWORD dwType;
	LSTATUS ret = ::RegQueryValueEx(m_hKey, pszValueName, nullptr, &dwType, reinterpret_cast<LPBYTE>(pszValue), &nBytes);

	if (ret != ERROR_SUCCESS)
	{
		return ret;
	}

	if (dwType != REG_SZ && dwType != REG_EXPAND_SZ)
	{
		return ERROR_INVALID_DATA;
	}

	if (pszValue != nullptr)
	{
		if (nBytes != 0)
		{
			if ((nBytes % sizeof(WCHAR) != 0) || (pszValue[nBytes / sizeof(WCHAR) - 1] != 0))
			{
				return ERROR_INVALID_DATA;
			}
		}
		else
		{
			pszValue[0] = L'\0';
		}
	}

	nChars = nBytes / sizeof(WCHAR);

	return ERROR_SUCCESS;
}

inline LSTATUS RegKey::SetDWORDValue(LPCWSTR pszValueName, DWORD dwValue) throw()
{
	_ASSERTE(m_hKey);
	return ::RegSetValueEx(m_hKey, pszValueName, 0, REG_DWORD, reinterpret_cast<const BYTE*>(&dwValue), sizeof(DWORD));
}

