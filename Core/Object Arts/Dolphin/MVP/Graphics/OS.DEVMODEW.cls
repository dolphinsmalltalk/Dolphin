"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.DEVMODEW'
	instanceVariableNames: ''
	classVariableNames: 'DM_DISPLAYFIXEDOUTPUT'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_DEVMODEW_Size' -> 16rBC.
			'_OffsetOf_dmBitsPerPel' -> 16rA8.
			'_OffsetOf_dmCollate' -> 16r64.
			'_OffsetOf_dmColor' -> 16r5C.
			'_OffsetOf_dmCopies' -> 16r56.
			'_OffsetOf_dmDefaultSource' -> 16r58.
			'_OffsetOf_dmDeviceName' -> 16r0.
			'_OffsetOf_dmDisplayFixedOutput' -> 16r58.
			'_OffsetOf_dmDisplayFlags' -> 16rB4.
			'_OffsetOf_dmDisplayFrequency' -> 16rB8.
			'_OffsetOf_dmDisplayOrientation' -> 16r54.
			'_OffsetOf_dmDriverExtra' -> 16r46.
			'_OffsetOf_dmDriverVersion' -> 16r42.
			'_OffsetOf_dmDuplex' -> 16r5E.
			'_OffsetOf_dmFields' -> 16r48.
			'_OffsetOf_dmFormName' -> 16r66.
			'_OffsetOf_dmLogPixels' -> 16rA6.
			'_OffsetOf_dmNup' -> 16rB4.
			'_OffsetOf_dmOrientation' -> 16r4C.
			'_OffsetOf_dmPaperLength' -> 16r50.
			'_OffsetOf_dmPaperSize' -> 16r4E.
			'_OffsetOf_dmPaperWidth' -> 16r52.
			'_OffsetOf_dmPelsHeight' -> 16rB0.
			'_OffsetOf_dmPelsWidth' -> 16rAC.
			'_OffsetOf_dmPosition' -> 16r4C.
			'_OffsetOf_dmPrintQuality' -> 16r5A.
			'_OffsetOf_dmScale' -> 16r54.
			'_OffsetOf_dmSize' -> 16r44.
			'_OffsetOf_dmSpecVersion' -> 16r40.
			'_OffsetOf_dmTTOption' -> 16r62.
			'_OffsetOf_dmYResolution' -> 16r60.
			'DM_BITSPERPEL' -> 16r40000.
			'DM_COLLATE' -> 16r8000.
			'DM_COLOR' -> 16r800.
			'DM_COPIES' -> 16r100.
			'DM_DEFAULTSOURCE' -> 16r200.
			'DM_DISPLAYFLAGS' -> 16r200000.
			'DM_DISPLAYFREQUENCY' -> 16r400000.
			'DM_DISPLAYORIENTATION' -> 16r80.
			'DM_DITHERTYPE' -> 16r4000000.
			'DM_DUPLEX' -> 16r1000.
			'DM_FORMNAME' -> 16r10000.
			'DM_ICMINTENT' -> 16r1000000.
			'DM_ICMMETHOD' -> 16r800000.
			'DM_LOGPIXELS' -> 16r20000.
			'DM_MEDIATYPE' -> 16r2000000.
			'DM_NUP' -> 16r40.
			'DM_ORIENTATION' -> 16r1.
			'DM_PANNINGHEIGHT' -> 16r10000000.
			'DM_PANNINGWIDTH' -> 16r8000000.
			'DM_PAPERLENGTH' -> 16r4.
			'DM_PAPERSIZE' -> 16r2.
			'DM_PAPERWIDTH' -> 16r8.
			'DM_PELSHEIGHT' -> 16r100000.
			'DM_PELSWIDTH' -> 16r80000.
			'DM_POSITION' -> 16r20.
			'DM_PRINTQUALITY' -> 16r400.
			'DM_SCALE' -> 16r10.
			'DM_TTOPTION' -> 16r4000.
			'DM_YRESOLUTION' -> 16r2000
		}!
OS.DEVMODEW guid: (Core.GUID fromString: '{0a67c0c4-d07a-4460-bffb-82c3c700dbd1}')!
OS.DEVMODEW comment: '`DEVMODEW` is an `External.Structure` class to wrap the struct ''Win32.DEVMODEW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(0a67c0c4-d07a-4460-bffb-82c3c700dbd1)]
struct tagDEVMODEW {
	[string] unsigned short dmDeviceName[32];
	WORD dmSpecVersion;
	WORD dmDriverVersion;
	WORD dmSize;
	WORD dmDriverExtra;
	DWORD dmFields;
	union {
		struct {
			short dmOrientation;
			short dmPaperSize;
			short dmPaperLength;
			short dmPaperWidth;
			short dmScale;
			short dmCopies;
			short dmDefaultSource;
			short dmPrintQuality;
		};
		struct {
			POINTL dmPosition;
			DWORD dmDisplayOrientation;
			DWORD dmDisplayFixedOutput;
		};
	};
	short dmColor;
	short dmDuplex;
	short dmYResolution;
	short dmTTOption;
	short dmCollate;
	[string] unsigned short dmFormName[32];
	WORD dmLogPixels;
	DWORD dmBitsPerPel;
	DWORD dmPelsWidth;
	DWORD dmPelsHeight;
	union {
		DWORD dmDisplayFlags;
		DWORD dmNup;
	};
	DWORD dmDisplayFrequency;
} DEVMODEW;
```
'!
!OS.DEVMODEW categoriesForClass!Win32-Structs! !
!OS.DEVMODEW methodsFor!

byteSize
	^(bytes uint16AtOffset: _OffsetOf_dmSize) + (bytes uint16AtOffset: _OffsetOf_dmDriverExtra)!

dmBitsPerPel
	"Answer the <Integer> value of the receiver's 'dmBitsPerPel' field."

	^bytes uint32AtOffset: _OffsetOf_dmBitsPerPel!

dmBitsPerPel: anInteger
	"Set the receiver's 'dmBitsPerPel' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmBitsPerPel put: anInteger!

dmCollate
	"Answer the <Integer> value of the receiver's 'dmCollate' field."

	^bytes int16AtOffset: _OffsetOf_dmCollate!

dmCollate: anInteger
	"Set the receiver's 'dmCollate' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmCollate put: anInteger!

dmColor
	"Answer the <Integer> value of the receiver's 'dmColor' field."

	^bytes int16AtOffset: _OffsetOf_dmColor!

dmColor: anInteger
	"Set the receiver's 'dmColor' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmColor put: anInteger!

dmCopies
	"Answer the <Integer> value of the receiver's 'dmCopies' field."

	^bytes int16AtOffset: _OffsetOf_dmCopies!

dmCopies: anInteger
	"Set the receiver's 'dmCopies' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmCopies put: anInteger!

dmDefaultSource
	"Answer the <Integer> value of the receiver's 'dmDefaultSource' field."

	^bytes int16AtOffset: _OffsetOf_dmDefaultSource!

dmDefaultSource: anInteger
	"Set the receiver's 'dmDefaultSource' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmDefaultSource put: anInteger!

dmDeviceName
	"Answer the <Utf16String> value of the receiver's 'dmDeviceName' field."

	^Utf16String fromAddress: bytes yourAddress!

dmDeviceName: anUtf16String
	"Set the receiver's 'dmDeviceName' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(31 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_dmDeviceName + 1)
		to: size
		startingAt: 1.
	bytes uint16AtOffset: _OffsetOf_dmDeviceName + size put: 0!

dmDisplayFixedOutput
	"Answer the <Integer> value of the receiver's 'dmDisplayFixedOutput' field."

	^bytes uint32AtOffset: _OffsetOf_dmDisplayFixedOutput!

dmDisplayFixedOutput: anInteger
	"Set the receiver's 'dmDisplayFixedOutput' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmDisplayFixedOutput put: anInteger!

dmDisplayFlags
	"Answer the <Integer> value of the receiver's 'dmDisplayFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dmDisplayFlags!

dmDisplayFlags: anInteger
	"Set the receiver's 'dmDisplayFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmDisplayFlags put: anInteger!

dmDisplayFrequency
	"Answer the <Integer> value of the receiver's 'dmDisplayFrequency' field."

	^bytes uint32AtOffset: _OffsetOf_dmDisplayFrequency!

dmDisplayFrequency: anInteger
	"Set the receiver's 'dmDisplayFrequency' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmDisplayFrequency put: anInteger!

dmDisplayOrientation
	"Answer the <Integer> value of the receiver's 'dmDisplayOrientation' field."

	^bytes uint32AtOffset: _OffsetOf_dmDisplayOrientation!

dmDisplayOrientation: anInteger
	"Set the receiver's 'dmDisplayOrientation' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmDisplayOrientation put: anInteger!

dmDriverExtra
	"Answer the <Integer> value of the receiver's 'dmDriverExtra' field."

	^bytes uint16AtOffset: _OffsetOf_dmDriverExtra!

dmDriverExtra: anInteger
	"Set the receiver's 'dmDriverExtra' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_dmDriverExtra put: anInteger!

dmDriverVersion
	"Answer the <Integer> value of the receiver's 'dmDriverVersion' field."

	^bytes uint16AtOffset: _OffsetOf_dmDriverVersion!

dmDriverVersion: anInteger
	"Set the receiver's 'dmDriverVersion' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_dmDriverVersion put: anInteger!

dmDuplex
	"Answer the <Integer> value of the receiver's 'dmDuplex' field."

	^bytes int16AtOffset: _OffsetOf_dmDuplex!

dmDuplex: anInteger
	"Set the receiver's 'dmDuplex' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmDuplex put: anInteger!

dmFields
	"Answer the <Integer> value of the receiver's 'dmFields' field."

	^bytes uint32AtOffset: _OffsetOf_dmFields!

dmFields: anInteger
	"Set the receiver's 'dmFields' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmFields put: anInteger!

dmFormName
	"Answer the <Utf16String> value of the receiver's 'dmFormName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_dmFormName!

dmFormName: anUtf16String
	"Set the receiver's 'dmFormName' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(31 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_dmFormName + 1)
		to: _OffsetOf_dmFormName + size
		startingAt: 1.
	bytes uint16AtOffset: _OffsetOf_dmFormName + size put: 0!

dmLogPixels
	"Answer the <Integer> value of the receiver's 'dmLogPixels' field."

	^bytes uint16AtOffset: _OffsetOf_dmLogPixels!

dmLogPixels: anInteger
	"Set the receiver's 'dmLogPixels' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_dmLogPixels put: anInteger!

dmNup
	"Answer the <Integer> value of the receiver's 'dmNup' field."

	^bytes uint32AtOffset: _OffsetOf_dmNup!

dmNup: anInteger
	"Set the receiver's 'dmNup' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmNup put: anInteger!

dmOrientation
	"Answer the <Integer> value of the receiver's 'dmOrientation' field."

	^bytes int16AtOffset: _OffsetOf_dmOrientation!

dmOrientation: anInteger
	"Set the receiver's 'dmOrientation' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmOrientation put: anInteger!

dmPaperLength
	"Answer the <Integer> value of the receiver's 'dmPaperLength' field."

	^bytes int16AtOffset: _OffsetOf_dmPaperLength!

dmPaperLength: anInteger
	"Set the receiver's 'dmPaperLength' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmPaperLength put: anInteger!

dmPaperSize
	"Answer the <Integer> value of the receiver's 'dmPaperSize' field."

	^bytes int16AtOffset: _OffsetOf_dmPaperSize!

dmPaperSize: anInteger
	"Set the receiver's 'dmPaperSize' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmPaperSize put: anInteger!

dmPaperWidth
	"Answer the <Integer> value of the receiver's 'dmPaperWidth' field."

	^bytes int16AtOffset: _OffsetOf_dmPaperWidth!

dmPaperWidth: anInteger
	"Set the receiver's 'dmPaperWidth' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmPaperWidth put: anInteger!

dmPelsHeight
	"Answer the <Integer> value of the receiver's 'dmPelsHeight' field."

	^bytes uint32AtOffset: _OffsetOf_dmPelsHeight!

dmPelsHeight: anInteger
	"Set the receiver's 'dmPelsHeight' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmPelsHeight put: anInteger!

dmPelsWidth
	"Answer the <Integer> value of the receiver's 'dmPelsWidth' field."

	^bytes uint32AtOffset: _OffsetOf_dmPelsWidth!

dmPelsWidth: anInteger
	"Set the receiver's 'dmPelsWidth' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dmPelsWidth put: anInteger!

dmPosition
	"Answer the <POINTL> value of the receiver's 'dmPosition' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_dmPosition!

dmPosition: aPOINTL
	"Set the receiver's 'dmPosition' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_dmPosition + 1)
		to: ##(_OffsetOf_dmPosition + POINTL._POINTL_Size)
		startingAt: 1!

dmPrintQuality
	"Answer the <Integer> value of the receiver's 'dmPrintQuality' field."

	^bytes int16AtOffset: _OffsetOf_dmPrintQuality!

dmPrintQuality: anInteger
	"Set the receiver's 'dmPrintQuality' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmPrintQuality put: anInteger!

dmScale
	"Answer the <Integer> value of the receiver's 'dmScale' field."

	^bytes int16AtOffset: _OffsetOf_dmScale!

dmScale: anInteger
	"Set the receiver's 'dmScale' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmScale put: anInteger!

dmSize
	"Answer the <Integer> value of the receiver's 'dmSize' field."

	^bytes uint16AtOffset: _OffsetOf_dmSize!

dmSize: anInteger
	"Set the receiver's 'dmSize' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_dmSize put: anInteger!

dmSpecVersion
	"Answer the <Integer> value of the receiver's 'dmSpecVersion' field."

	^bytes uint16AtOffset: _OffsetOf_dmSpecVersion!

dmSpecVersion: anInteger
	"Set the receiver's 'dmSpecVersion' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_dmSpecVersion put: anInteger!

dmTTOption
	"Answer the <Integer> value of the receiver's 'dmTTOption' field."

	^bytes int16AtOffset: _OffsetOf_dmTTOption!

dmTTOption: anInteger
	"Set the receiver's 'dmTTOption' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmTTOption put: anInteger!

dmYResolution
	"Answer the <Integer> value of the receiver's 'dmYResolution' field."

	^bytes int16AtOffset: _OffsetOf_dmYResolution!

dmYResolution: anInteger
	"Set the receiver's 'dmYResolution' field to the value of the argument, anInteger"

	bytes int16AtOffset: _OffsetOf_dmYResolution put: anInteger!

getValidFields
	| dmFields mask |
	self isNull ifTrue: [^#()].
	dmFields := self dmFields.
	mask := 1.
	^#(#dmDeviceName #dmSpecVersion #dmDriverVersion #dmSize #dmDriverExtra #dmFields)
		, (#(#dmOrientation #dmPaperSize #dmPaperLength #dmPaperWidth #dmScale #dmPosition #dmNup #dmDisplayOrientation #dmCopies #dmDefaultSource #dmPrintQuality #dmColor #dmDuplex #dmYResolution #dmTTOption #dmCollate #dmFormName #dmLogPixels #dmBitsPerPel #dmPelsWidth #dmPelsHeight #dmDisplayFlags #dmDisplayFrequency #dmICMMethod #dmICMIntent #dmMediaType #dmDitherType #dmPanningWidth #dmPanningHeight #dmDisplayFixedOutput)
				select: 
					[:each |
					| live |
					live := dmFields allMask: mask.
					mask := mask bitShift: 1.
					live])! !
!OS.DEVMODEW categoriesForMethods!
byteSize!accessing!public! !
dmBitsPerPel!**compiled accessors**!public! !
dmBitsPerPel:!**compiled accessors**!public! !
dmCollate!**compiled accessors**!public! !
dmCollate:!**compiled accessors**!public! !
dmColor!**compiled accessors**!public! !
dmColor:!**compiled accessors**!public! !
dmCopies!**compiled accessors**!public! !
dmCopies:!**compiled accessors**!public! !
dmDefaultSource!**compiled accessors**!public! !
dmDefaultSource:!**compiled accessors**!public! !
dmDeviceName!**compiled accessors**!public! !
dmDeviceName:!**compiled accessors**!public! !
dmDisplayFixedOutput!**compiled accessors**!public! !
dmDisplayFixedOutput:!**compiled accessors**!public! !
dmDisplayFlags!**compiled accessors**!public! !
dmDisplayFlags:!**compiled accessors**!public! !
dmDisplayFrequency!**compiled accessors**!public! !
dmDisplayFrequency:!**compiled accessors**!public! !
dmDisplayOrientation!**compiled accessors**!public! !
dmDisplayOrientation:!**compiled accessors**!public! !
dmDriverExtra!**compiled accessors**!public! !
dmDriverExtra:!**compiled accessors**!public! !
dmDriverVersion!**compiled accessors**!public! !
dmDriverVersion:!**compiled accessors**!public! !
dmDuplex!**compiled accessors**!public! !
dmDuplex:!**compiled accessors**!public! !
dmFields!**compiled accessors**!public! !
dmFields:!**compiled accessors**!public! !
dmFormName!**compiled accessors**!public! !
dmFormName:!**compiled accessors**!public! !
dmLogPixels!**compiled accessors**!public! !
dmLogPixels:!**compiled accessors**!public! !
dmNup!**compiled accessors**!public! !
dmNup:!**compiled accessors**!public! !
dmOrientation!**compiled accessors**!public! !
dmOrientation:!**compiled accessors**!public! !
dmPaperLength!**compiled accessors**!public! !
dmPaperLength:!**compiled accessors**!public! !
dmPaperSize!**compiled accessors**!public! !
dmPaperSize:!**compiled accessors**!public! !
dmPaperWidth!**compiled accessors**!public! !
dmPaperWidth:!**compiled accessors**!public! !
dmPelsHeight!**compiled accessors**!public! !
dmPelsHeight:!**compiled accessors**!public! !
dmPelsWidth!**compiled accessors**!public! !
dmPelsWidth:!**compiled accessors**!public! !
dmPosition!**compiled accessors**!public! !
dmPosition:!**compiled accessors**!public! !
dmPrintQuality!**compiled accessors**!public! !
dmPrintQuality:!**compiled accessors**!public! !
dmScale!**compiled accessors**!public! !
dmScale:!**compiled accessors**!public! !
dmSize!**compiled accessors**!public! !
dmSize:!**compiled accessors**!public! !
dmSpecVersion!**compiled accessors**!public! !
dmSpecVersion:!**compiled accessors**!public! !
dmTTOption!**compiled accessors**!public! !
dmTTOption:!**compiled accessors**!public! !
dmYResolution!**compiled accessors**!public! !
dmYResolution:!**compiled accessors**!public! !
getValidFields!public! !
!

!OS.DEVMODEW class methodsFor!

byteSize
	^_DEVMODEW_Size!

defineFields
	"Define the fields of the DEVMODEW structure.

	DEVMODEW compileDefinition

		typedef [uuid(0a67c0c4-d07a-4460-bffb-82c3c700dbd1)]
		struct tagDEVMODEW {
			[string] unsigned short dmDeviceName[32];
			WORD dmSpecVersion;
			WORD dmDriverVersion;
			WORD dmSize;
			WORD dmDriverExtra;
			DWORD dmFields;
			union {
				struct {
					short dmOrientation;
					short dmPaperSize;
					short dmPaperLength;
					short dmPaperWidth;
					short dmScale;
					short dmCopies;
					short dmDefaultSource;
					short dmPrintQuality;
				};
				struct {
					POINTL dmPosition;
					DWORD dmDisplayOrientation;
					DWORD dmDisplayFixedOutput;
				};
			};
			short dmColor;
			short dmDuplex;
			short dmYResolution;
			short dmTTOption;
			short dmCollate;
			[string] unsigned short dmFormName[32];
			WORD dmLogPixels;
			DWORD dmBitsPerPel;
			DWORD dmPelsWidth;
			DWORD dmPelsHeight;
			union {
				DWORD dmDisplayFlags;
				DWORD dmNup;
			};
			DWORD dmDisplayFrequency;
		} DEVMODEW;
"

	self
		defineField: #dmDeviceName type: (StringField type: Utf16String length: 32) offset: 0;
		defineField: #dmSpecVersion type: UInt16Field new offset: 64;
		defineField: #dmDriverVersion type: UInt16Field new offset: 66;
		defineField: #dmSize type: UInt16Field new offset: 68;
		defineField: #dmDriverExtra type: UInt16Field new offset: 70;
		defineField: #dmFields type: UInt32Field new offset: 72;
		defineField: #dmOrientation type: Int16Field new offset: 76;
		defineField: #dmPaperSize type: Int16Field new offset: 78;
		defineField: #dmPaperLength type: Int16Field new offset: 80;
		defineField: #dmPaperWidth type: Int16Field new offset: 82;
		defineField: #dmScale type: Int16Field new offset: 84;
		defineField: #dmCopies type: Int16Field new offset: 86;
		defineField: #dmDefaultSource type: Int16Field new offset: 88;
		defineField: #dmPrintQuality type: Int16Field new offset: 90;
		defineField: #dmPosition type: (StructureField type: POINTL) offset: 76;
		defineField: #dmDisplayOrientation type: UInt32Field new offset: 84;
		defineField: #dmDisplayFixedOutput type: UInt32Field new offset: 88;
		defineField: #dmColor type: Int16Field new offset: 92;
		defineField: #dmDuplex type: Int16Field new offset: 94;
		defineField: #dmYResolution type: Int16Field new offset: 96;
		defineField: #dmTTOption type: Int16Field new offset: 98;
		defineField: #dmCollate type: Int16Field new offset: 100;
		defineField: #dmFormName type: (StringField type: Utf16String length: 32) offset: 102;
		defineField: #dmLogPixels type: UInt16Field new offset: 166;
		defineField: #dmBitsPerPel type: UInt32Field new offset: 168;
		defineField: #dmPelsWidth type: UInt32Field new offset: 172;
		defineField: #dmPelsHeight type: UInt32Field new offset: 176;
		defineField: #dmDisplayFlags type: UInt32Field new offset: 180;
		defineField: #dmNup type: UInt32Field new offset: 180;
		defineField: #dmDisplayFrequency type: UInt32Field new offset: 184.
	self byteSize: 188!

getFieldNames
	^#(#dmDeviceName #dmSpecVersion #dmDriverVersion #dmSize #dmDriverExtra #dmFields #dmOrientation #dmPosition #dmPaperSize #dmPaperLength #dmPaperWidth #dmDisplayOrientation #dmScale #dmCopies #dmDefaultSource #dmDisplayFixedOutput #dmPrintQuality #dmColor #dmDuplex #dmYResolution #dmTTOption #dmCollate #dmFormName #dmLogPixels #dmBitsPerPel #dmPelsWidth #dmPelsHeight #dmDisplayFlags #dmNup #dmDisplayFrequency)! !
!OS.DEVMODEW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

