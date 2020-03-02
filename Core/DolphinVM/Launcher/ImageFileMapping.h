#pragma once

#include "ImageHeader.h"

class ImageFileMapping
{
	HANDLE m_hFile;
	HANDLE m_hMapping;
	LPVOID m_pData;
	size_t  m_size;

public:
	ImageFileMapping() : m_hFile(0), m_hMapping(0), m_pData(NULL), m_size(0) {}
	~ImageFileMapping() { Close(); }

	int Open(LPCWSTR imageFileName);
	void Close();

	LPVOID GetRawData() { return m_pData; }
	size_t GetRawSize() { return m_size; }

	uint8_t* GetData() { return static_cast<uint8_t*>(GetRawData()) + sizeof(ISTImageHeader); }
	size_t GetSize() { return m_size - sizeof(ISTImageHeader); }
	IMAGETYPE GetType() { return reinterpret_cast<ISTImageHeader*>(m_pData)->imageType; }
	ImageHeader* GetHeader() { return &(reinterpret_cast<ISTImageHeader*>(m_pData)->header); }

	static const IMAGETYPE ISTIMAGE;
};
