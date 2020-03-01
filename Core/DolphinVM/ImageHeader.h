#pragma once

#define IMAGETYPEENCODE(x) (x[0] + (x[1] << 8) + (x[2] << 16) + (x[3] << 24))
typedef uint32_t IMAGETYPE;

struct ImageHeader
{
	// The Dolphin version which wrote the image
	union
	{
		struct
		{
			uint32_t		versionMS;			// Win32 most significant version number
			uint32_t		versionLS;			// Win32 least significant version number
		};
		struct
		{
			uint16_t		versionML;
			uint16_t		versionMH;
			uint16_t		versionLL;
			uint16_t		versionLH;
		};
	};

	struct
	{
		uint32_t		bIsCompressed : 1;	// Whether or not this image has been compressed when saved
	} flags;

	uint32_t	nTableSize;			// Number of object table entries written
	uint32_t	nGlobalPointers;	// Number of "global" pointers
	LPVOID		BasePointer;		// Base address of OT when saved (used to fixup)
	uint32_t	nNextIdHash;		// The next identity hash value when image was saved
	uint32_t	nMaxTableSize;		// The maximum size of OT table required by this image

	bool HasSingleByteNullTerms() const { return versionLH < 54;  }
};

struct ISTImageHeader
{
	IMAGETYPE	imageType;			// Should be "IST"
	ImageHeader	header;
};
