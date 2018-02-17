#include "ist.h"
#include "ImageFileResource.h"

#if defined(TO_GO) || defined(USE_VM_DLL)

int ImageFileResource::Open(HMODULE hModule, int resId)
{
	m_hFind = ::FindResource(hModule, LPCSTR(resId), RT_RCDATA);
	if (m_hFind == NULL)
		return -1;
	m_hResource = ::LoadResource(hModule, m_hFind);
	if (m_hResource == NULL)
		return -2;
	m_pData = ::LockResource(m_hResource);
	if (m_pData == NULL)
		return -3;

	m_dwSize = ::SizeofResource(hModule, m_hFind);

	return 0;
}

void ImageFileResource::Close()
{
	if (m_pData)
	{
		UnlockResource(m_pData);
		m_pData = NULL;
	}
	if (m_hResource)
	{
		FreeResource(m_hResource);
		m_hResource = NULL;
	}
	m_hFind = NULL;
}

#endif
