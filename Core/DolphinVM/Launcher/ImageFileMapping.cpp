#include "ist.h"
#include "ImageFileMapping.h"

const IMAGETYPE ImageFileMapping::ISTIMAGE = IMAGETYPEENCODE("IST");

int ImageFileMapping::Open(LPCWSTR szImageName)
{
	// Open the image file
	m_hFile = CreateFileW(szImageName,
				GENERIC_READ,
				FILE_SHARE_WRITE,	// Prevent anyone else writing to the file while mapped
				NULL,
				OPEN_EXISTING,
				FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
				NULL);
	if (m_hFile == INVALID_HANDLE_VALUE)
		return -1;

	// Create a mapping onto it
	m_hMapping = CreateFileMapping(m_hFile,
		NULL,
		PAGE_READONLY,
		0, 0,
		NULL);
	if (m_hMapping == NULL)
		return -2;

	// Create a view onto the map
	m_pData = MapViewOfFile(m_hMapping, 
				FILE_MAP_READ,
				0, 0, 
				0);
	if (m_pData == NULL)
		return -3;

	ULARGE_INTEGER fileSize;
	fileSize.LowPart = GetFileSize(m_hFile, &fileSize.HighPart);
#ifdef _M_X64
	m_size = fileSize.QuadPart;
#else
	if (fileSize.HighPart != 0)
		return -4;
	m_size = fileSize.LowPart;
#endif

	return 0;
}

void ImageFileMapping::Close()
{
	if (m_pData)
	{
		UnmapViewOfFile(m_pData);
		m_pData = NULL;
	}
	if (m_hMapping)
	{
		CloseHandle(m_hMapping);
		m_hMapping = 0;
	}
	if (m_hFile)
	{
		CloseHandle(m_hFile);
		m_hFile = 0;
	}
}
