#pragma once

#include "ImageHeader.h"

#ifndef VMDLL

class ImageFileResource
{
	HRSRC m_hFind;
	HGLOBAL m_hResource;
	LPVOID m_pData;
	DWORD  m_size;	// The size of the resource, therefore limiting a runtime image attached as a resource to 4Gb maximum size

public:
	ImageFileResource() : m_hFind(0), m_hResource(0), m_pData(NULL), m_size(0) {}
	~ImageFileResource() { Close(); }

	int Open(HMODULE hMod, int resId);
	void Close();

	LPVOID GetRawData() { return m_pData; }
	size_t GetRawSize() { return m_size; }

	BYTE* GetData() { return static_cast<BYTE*>(m_pData) + sizeof(ISTImageHeader); }
	size_t GetSize() { return m_size - sizeof(ISTImageHeader); }
	IMAGETYPE GetType() { return *reinterpret_cast<IMAGETYPE*>(GetRawData()); }
	ImageHeader* GetHeader() { return &(reinterpret_cast<ISTImageHeader*>(m_pData)->header); }
};

#endif
