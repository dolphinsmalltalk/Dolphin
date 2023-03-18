"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.DEVMODE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_DEVMODE_Size' -> 16r94.
			'_OffsetOf_dmBitsPerPel' -> 16r68.
			'_OffsetOf_dmCollate' -> 16r44.
			'_OffsetOf_dmColor' -> 16r3C.
			'_OffsetOf_dmCopies' -> 16r36.
			'_OffsetOf_dmDefaultSource' -> 16r38.
			'_OffsetOf_dmDeviceName' -> 16r0.
			'_OffsetOf_dmDisplayFlags' -> 16r74.
			'_OffsetOf_dmDisplayFrequency' -> 16r78.
			'_OffsetOf_dmDitherType' -> 16r88.
			'_OffsetOf_dmDriverExtra' -> 16r26.
			'_OffsetOf_dmDriverVersion' -> 16r22.
			'_OffsetOf_dmDuplex' -> 16r3E.
			'_OffsetOf_dmFields' -> 16r28.
			'_OffsetOf_dmFormName' -> 16r46.
			'_OffsetOf_dmICMIntent' -> 16r80.
			'_OffsetOf_dmICMMethod' -> 16r7C.
			'_OffsetOf_dmLogPixels' -> 16r66.
			'_OffsetOf_dmMediaType' -> 16r84.
			'_OffsetOf_dmOrientation' -> 16r2C.
			'_OffsetOf_dmPaperLength' -> 16r30.
			'_OffsetOf_dmPaperSize' -> 16r2E.
			'_OffsetOf_dmPaperWidth' -> 16r32.
			'_OffsetOf_dmPelsHeight' -> 16r70.
			'_OffsetOf_dmPelsWidth' -> 16r6C.
			'_OffsetOf_dmPrintQuality' -> 16r3A.
			'_OffsetOf_dmReserved1' -> 16r8C.
			'_OffsetOf_dmReserved2' -> 16r90.
			'_OffsetOf_dmScale' -> 16r34.
			'_OffsetOf_dmSize' -> 16r24.
			'_OffsetOf_dmSpecVersion' -> 16r20.
			'_OffsetOf_dmTTOption' -> 16r42.
			'_OffsetOf_dmYResolution' -> 16r40
		}!
OS.DEVMODE guid: (Core.GUID fromString: '{62ad7874-bbbf-4852-99d9-8040855ecb49}')!
OS.DEVMODE comment: '<DEVMODE> is an <ExternalStructure> class to wrap the struct ''Win32.DEVMODE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.DEVMODE categoriesForClass!Win32-Structs! !
!OS.DEVMODE class methodsFor!

byteSize
	^_DEVMODE_Size!

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
		defineField: #dmSpecVersion type: UInt16Field new;
		defineField: #dmDriverVersion type: UInt16Field new;
		defineField: #dmSize type: UInt16Field new;
		defineField: #dmDriverExtra type: UInt16Field new;
		defineField: #dmFields type: UInt32Field new;
		defineField: #dmOrientation type: Int16Field new;
		defineField: #dmPaperSize type: Int16Field new;
		defineField: #dmPaperLength type: Int16Field new;
		defineField: #dmPaperWidth type: Int16Field new;
		defineField: #dmScale type: Int16Field new;
		defineField: #dmCopies type: Int16Field new;
		defineField: #dmDefaultSource type: Int16Field new;
		defineField: #dmPrintQuality type: Int16Field new;
		defineField: #dmColor type: Int16Field new;
		defineField: #dmDuplex type: Int16Field new;
		defineField: #dmYResolution type: Int16Field new;
		defineField: #dmTTOption type: Int16Field new;
		defineField: #dmCollate type: Int16Field new;
		defineField: #dmFormName type: (ArrayField type: ByteArray length: 32);
		defineField: #dmLogPixels type: UInt16Field new;
		defineField: #dmBitsPerPel type: UInt32Field new;
		defineField: #dmPelsWidth type: UInt32Field new;
		defineField: #dmPelsHeight type: UInt32Field new;
		defineField: #dmDisplayFlags type: UInt32Field new;
		defineField: #dmDisplayFrequency type: UInt32Field new;
		defineField: #dmICMMethod type: UInt32Field new;
		defineField: #dmICMIntent type: UInt32Field new;
		defineField: #dmMediaType type: UInt32Field new;
		defineField: #dmDitherType type: UInt32Field new;
		defineField: #dmReserved1 type: UInt32Field filler;
		defineField: #dmReserved2 type: UInt32Field filler!

getFieldNames
	^#(#dmDeviceName #dmSpecVersion #dmDriverVersion #dmSize #dmDriverExtra #dmFields #dmOrientation #dmPaperSize #dmPaperLength #dmPaperWidth #dmScale #dmCopies #dmDefaultSource #dmPrintQuality #dmColor #dmDuplex #dmYResolution #dmTTOption #dmCollate #dmFormName #dmLogPixels #dmBitsPerPel #dmPelsWidth #dmPelsHeight #dmDisplayFlags #dmDisplayFrequency #dmICMMethod #dmICMIntent #dmMediaType #dmDitherType)! !
!OS.DEVMODE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

