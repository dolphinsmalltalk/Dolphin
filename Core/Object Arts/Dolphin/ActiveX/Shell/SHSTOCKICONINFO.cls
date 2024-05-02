"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #SHSTOCKICONINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_hIcon _OffsetOf_iIcon _OffsetOf_iSysImageIndex _OffsetOf_szPath'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SHSTOCKICONINFO guid: (GUID fromString: '{daae46cf-eda1-48a6-97ec-78f4b63fa09e}')!

SHSTOCKICONINFO addClassConstant: '_OffsetOf_dwSize' value: 16r0!
SHSTOCKICONINFO addClassConstant: '_OffsetOf_hIcon' value: 16r4!
SHSTOCKICONINFO addClassConstant: '_OffsetOf_iIcon' value: 16rC!
SHSTOCKICONINFO addClassConstant: '_OffsetOf_iSysImageIndex' value: 16r8!
SHSTOCKICONINFO addClassConstant: '_OffsetOf_szPath' value: 16r10!

SHSTOCKICONINFO comment: ''!

!SHSTOCKICONINFO categoriesForClass!External-Data-Structured-Win32! !

!SHSTOCKICONINFO methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

hIcon
	"Answer the <ExternalHandle> value of the receiver's 'hIcon' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hIcon) asExternalHandle!

iIcon
	"Answer the <Integer> value of the receiver's 'iIcon' field."

	^bytes sdwordAtOffset: _OffsetOf_iIcon!

iSysImageIndex
	"Answer the <Integer> value of the receiver's 'iSysImageIndex' field."

	^bytes sdwordAtOffset: _OffsetOf_iSysImageIndex!

szPath
	"Answer the <Utf16String> value of the receiver's 'szPath' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szPath! !

!SHSTOCKICONINFO categoriesForMethods!
dwSize:!**compiled accessors**!public! !
hIcon!**compiled accessors**!public! !
iIcon!**compiled accessors**!public! !
iSysImageIndex!**compiled accessors**!public! !
szPath!**compiled accessors**!public! !
!

!SHSTOCKICONINFO class methodsFor!

defineFields
	"Define the fields of the SHSTOCKICONINFO structure.

	SHSTOCKICONINFO compileDefinition

		typedef [uuid(94b6ea81-773c-47d8-9e64-b42f7a2ac6dc), helpstring('Receives information used to retrieve a stock Shell icon. This structure is used in a call SHGetStockIconInfo.')]
		struct tagSHSTOCKICONINFO {
			[restricted] DWORD dwSize;
			[readonly] HICON hIcon;
			[readonly] int iSysImageIndex;
			[readonly] int iIcon;
			[readonly, string] unsigned short szPath[260];
		} SHSTOCKICONINFO;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hIcon
			type: HANDLEField new beReadOnly
			offset: 4;
		defineField: #iSysImageIndex
			type: SDWORDField new beReadOnly
			offset: 8;
		defineField: #iIcon
			type: SDWORDField new beReadOnly
			offset: 12;
		defineField: #szPath
			type: (StringField type: Utf16String length: 260) beReadOnly
			offset: 16.
	self byteSize: 536!

getFieldNames
	^#(#dwSize #hIcon #iSysImageIndex #iIcon #szPath)! !

!SHSTOCKICONINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

