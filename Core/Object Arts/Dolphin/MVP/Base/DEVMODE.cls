"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #DEVMODE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DEVMODE guid: (GUID fromString: '{62ad7874-bbbf-4852-99d9-8040855ecb49}')!
DEVMODE comment: '<DEVMODE> is an <ExternalStructure> class to wrap the struct ''Win32.DEVMODE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(62AD7874-BBBF-4852-99D9-8040855ECB49)]
struct tagDEVMODE {
	CHAR dmDeviceName[32];
	WORD dmSpecVersion;
	WORD dmDriverVersion;
	WORD dmSize;
	WORD dmDriverExtra;
	DWORD dmFields;
	short dmOrientation;
	short dmPaperSize;
	short dmPaperLength;
	short dmPaperWidth;
	short dmScale;
	short dmCopies;
	short dmDefaultSource;
	short dmPrintQuality;
	short dmColor;
	short dmDuplex;
	short dmYResolution;
	short dmTTOption;
	short dmCollate;
	CHAR dmFormName[32];
	WORD dmLogPixels;
	DWORD dmBitsPerPel;
	DWORD dmPelsWidth;
	DWORD dmPelsHeight;
	DWORD dmDisplayFlags;
	DWORD dmDisplayFrequency;
	DWORD dmICMMethod;
	DWORD dmICMIntent;
	DWORD dmMediaType;
	DWORD dmDitherType;
	DWORD dmReserved1;
	DWORD dmReserved2;
} DEVMODE;
'!
!DEVMODE categoriesForClass!Win32-Structs! !
!DEVMODE class methodsFor!

defineFields
	"Define the fields of the DEVMODE structure.

	DEVMODE  compileDefinition

		typedef [uuid(62AD7874-BBBF-4852-99D9-8040855ECB49)]
		struct tagDEVMODE {
			CHAR dmDeviceName[32];
			WORD dmSpecVersion;
			WORD dmDriverVersion;
			WORD dmSize;
			WORD dmDriverExtra;
			DWORD dmFields;
			short dmOrientation;
			short dmPaperSize;
			short dmPaperLength;
			short dmPaperWidth;
			short dmScale;
			short dmCopies;
			short dmDefaultSource;
			short dmPrintQuality;
			short dmColor;
			short dmDuplex;
			short dmYResolution;
			short dmTTOption;
			short dmCollate;
			CHAR dmFormName[32];
			WORD dmLogPixels;
			DWORD dmBitsPerPel;
			DWORD dmPelsWidth;
			DWORD dmPelsHeight;
			DWORD dmDisplayFlags;
			DWORD dmDisplayFrequency;
			DWORD dmICMMethod;
			DWORD dmICMIntent;
			DWORD dmMediaType;
			DWORD dmDitherType;
			DWORD dmReserved1;
			DWORD dmReserved2;
		} DEVMODE;
"

	self
		beUncompiled;
		defineField: #dmDeviceName type: (ArrayField type: ByteArray length: 32);
		defineField: #dmSpecVersion type: WORDField new;
		defineField: #dmDriverVersion type: WORDField new;
		defineField: #dmSize type: WORDField new;
		defineField: #dmDriverExtra type: WORDField new;
		defineField: #dmFields type: DWORDField new;
		defineField: #dmOrientation type: SWORDField new;
		defineField: #dmPaperSize type: SWORDField new;
		defineField: #dmPaperLength type: SWORDField new;
		defineField: #dmPaperWidth type: SWORDField new;
		defineField: #dmScale type: SWORDField new;
		defineField: #dmCopies type: SWORDField new;
		defineField: #dmDefaultSource type: SWORDField new;
		defineField: #dmPrintQuality type: SWORDField new;
		defineField: #dmColor type: SWORDField new;
		defineField: #dmDuplex type: SWORDField new;
		defineField: #dmYResolution type: SWORDField new;
		defineField: #dmTTOption type: SWORDField new;
		defineField: #dmCollate type: SWORDField new;
		defineField: #dmFormName type: (ArrayField type: ByteArray length: 32);
		defineField: #dmLogPixels type: WORDField new;
		defineField: #dmBitsPerPel type: DWORDField new;
		defineField: #dmPelsWidth type: DWORDField new;
		defineField: #dmPelsHeight type: DWORDField new;
		defineField: #dmDisplayFlags type: DWORDField new;
		defineField: #dmDisplayFrequency type: DWORDField new;
		defineField: #dmICMMethod type: DWORDField new;
		defineField: #dmICMIntent type: DWORDField new;
		defineField: #dmMediaType type: DWORDField new;
		defineField: #dmDitherType type: DWORDField new;
		defineField: #dmReserved1 type: DWORDField filler;
		defineField: #dmReserved2 type: DWORDField filler! !
!DEVMODE class categoriesFor: #defineFields!initializing!public! !

