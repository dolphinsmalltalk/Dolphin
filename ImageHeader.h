#pragma once

#define IMAGETYPEENCODE(x) (x[0] + (x[1] << 8) + (x[2] << 16) + (x[3] << 24))
typedef DWORD IMAGETYPE;

struct ImageHeader
{
	// The Dolphin version which wrote the image
	union
	{
		struct
		{
			DWORD		versionMS;			// Win32 most significant version number
			DWORD		versionLS;			// Win32 least significant version number
		};
		struct
		{
			WORD		versionML;
			WORD		versionMH;
			WORD		versionLL;
			WORD		versionLH;
		};
	};

	struct
	{
		DWORD		bIsCompressed : 1;	// Whether or not this image has been compressed when saved
	} flags;

	DWORD		nTableSize;			// Number of object table entries written
	DWORD		nGlobalPointers;	// Number of "global" pointers
	LPVOID		BasePointer;		// Base address of OT when saved (used to fixup)
	DWORD		nNextIdHash;		// The next identity hash value when image was saved
	DWORD		nMaxTableSize;		// The maximum size of OT table required by this image

	bool HasSingleByteNullTerms() const { return versionLH < 54;  }
};

struct ISTImageHeader
{
	IMAGETYPE	imageType;			// Should be "IST"
	ImageHeader	header;
};
