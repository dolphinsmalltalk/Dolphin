#pragma once

#include "ImageHeader.h"

class ImageFileResource
{
	HRSRC m_hFind;
	HGLOBAL m_hResource;
	LPVOID m_pData;
	DWORD  m_dwSize;

public:
	ImageFileResource() : m_hFind(0), m_hResource(0), m_pData(NULL), m_dwSize(0) {}
	~ImageFileResource() { Close(); }

	int Open(HMODULE hMod, int resId);
	void Close();

	LPVOID GetRawData() { return m_pData; }
	DWORD GetRawSize() { return m_dwSize; }

	BYTE* GetData() { return static_cast<BYTE*>(m_pData) + sizeof(ISTImageHeader); }
	DWORD GetSize() { return m_dwSize - sizeof(ISTImageHeader); }
	IMAGETYPE GetType() { return *reinterpret_cast<DWORD*>(GetRawData()); }
	ImageHeader* GetHeader() { return &(reinterpret_cast<ISTImageHeader*>(m_pData)->header); }
};
