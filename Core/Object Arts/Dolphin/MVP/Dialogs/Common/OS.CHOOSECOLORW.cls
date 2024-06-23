"Filed out from Dolphin Smalltalk"!

OS.ComDlgStructure
	subclass: #'OS.CHOOSECOLORW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CHOOSECOLORW_Size' -> 16r24.
			'_OffsetOf_flags' -> 16r14.
			'_OffsetOf_hInstance' -> 16r8.
			'_OffsetOf_lCustData' -> 16r18.
			'_OffsetOf_lpCustColors' -> 16r10.
			'_OffsetOf_lpfnHook' -> 16r1C.
			'_OffsetOf_lpTemplateName' -> 16r20.
			'_OffsetOf_rgbResult' -> 16rC
		}!

OS.CHOOSECOLORW guid: (Core.GUID fromString: '{87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.CHOOSECOLORW comment: '<CHOOSECOLOR> is an <ExternalStructure> class to wrap the struct ''Win32.CHOOSECOLOR'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32), helpstring("CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour.")]
struct tagCHOOSECOLOR {
	[restricted] DWORD dwSize;
	[restricted] HWND hwndOwner;
	[restricted] HWND hInstance;
	COLORREF rgbResult;
	COLORREF[16]* lpCustColors;
	DWORD flags;
	[hidden] LPARAM lCustData;
	[restricted] LPCCHOOKPROC lpfnHook;
	[hidden] LPSTR lpTemplateName;
} CHOOSECOLOR;
'!

!OS.CHOOSECOLORW categoriesForClass!Win32-Structs! !

!OS.CHOOSECOLORW methodsFor!

color
	"Answer the chosen colour."

	^Graphics.Color fromCOLORREF: self rgbResult!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

hInstance: aHandle
	"Set the receiver's 'hInstance' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hInstance put: aHandle!

hookFlag
	^CC_ENABLEHOOK!

lpCustColors
	"Answer the <UInt32Array> value of the receiver's 'lpCustColors' field."

	^UInt32Array fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpCustColors) length: 16!

lpCustColors: anUInt32Array
	"Set the receiver's 'lpCustColors' field to the value of the argument, anUInt32Array"

	bytes uintPtrAtOffset: _OffsetOf_lpCustColors put: anUInt32Array yourAddress!

lpfnHook: anAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anAddress!

rgbResult
	"Answer the <Integer> value of the receiver's 'rgbResult' field."

	^bytes uint32AtOffset: _OffsetOf_rgbResult!

rgbResult: anInteger
	"Set the receiver's 'rgbResult' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_rgbResult put: anInteger! !

!OS.CHOOSECOLORW categoriesForMethods!
color!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hInstance:!**compiled accessors**!public! !
hookFlag!constants!private! !
lpCustColors!**compiled accessors**!public! !
lpCustColors:!**compiled accessors**!public! !
lpfnHook:!**compiled accessors**!public! !
rgbResult!**compiled accessors**!public! !
rgbResult:!**compiled accessors**!public! !
!

!OS.CHOOSECOLORW class methodsFor!

byteSize
	^_CHOOSECOLORW_Size!

defineFields
	"Define the fields of the CHOOSECOLOR structure.

	self compileDefinition

		typedef [uuid(87b4c5d1-026e-11d3-9fd7-00a0cc3e4a32), helpstring('CHOOSECOLOR is used in conjunction with <ColorDialog> to pop a common file dialog to select a colour.')]
		struct tagCHOOSECOLOR {
			[restricted] DWORD dwSize;
			[restricted] HWND hwndOwner;
			[restricted] HWND hInstance;
			COLORREF rgbResult;
			COLORREF[16]* lpCustColors;
			DWORD flags;
			[hidden] LPARAM lCustData;
			[restricted] LPCCHOOKPROC lpfnHook;
			[hidden] LPWSTR lpTemplateName;
		} CHOOSECOLOR;
"

	super defineFields.
	self
		defineField: #hInstance
			type: HANDLEField new beWriteOnly
			offset: 8;
		defineField: #rgbResult
			type: UInt32Field new
			offset: 12;
		defineField: #lpCustColors
			type: (ArrayPointerField type: UInt32Array length: 16)
			offset: 16;
		defineField: #flags
			type: UInt32Field new
			offset: 20;
		defineField: #lCustData
			type: IntPtrField new beFiller
			offset: 24;
		defineField: #lpfnHook
			type: LPVOIDField new beWriteOnly
			offset: 28;
		defineField: #lpTemplateName
			type: (PointerField type: Utf16String) beFiller
			offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#dwSize #hwndOwner #hInstance #rgbResult #lpCustColors #flags #lpfnHook)! !

!OS.CHOOSECOLORW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

