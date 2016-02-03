#pragma once

#include "ImageHeader.h"

class ImageFileMapping
{
	HANDLE m_hFile;
	HANDLE m_hMapping;
	LPVOID m_pData;
	DWORD  m_dwSize;

public:
	ImageFileMapping() : m_hFile(0), m_hMapping(0), m_pData(NULL), m_dwSize(0) {}
	~ImageFileMapping() { Close(); }

	int Open(LPCSTR imageFileName);
	void Close();

	LPVOID GetRawData() { return m_pData; }
	DWORD GetRawSize() { return m_dwSize; }

	BYTE* GetData() { return static_cast<BYTE*>(GetRawData()) + sizeof(ISTImageHeader); }
	DWORD GetSize() { return m_dwSize - sizeof(ISTImageHeader); }
	IMAGETYPE GetType() { return reinterpret_cast<ISTImageHeader*>(m_pData)->imageType; }
	ImageHeader* GetHeader() { return &(reinterpret_cast<ISTImageHeader*>(m_pData)->header); }

	static const IMAGETYPE ISTIMAGE;
};
