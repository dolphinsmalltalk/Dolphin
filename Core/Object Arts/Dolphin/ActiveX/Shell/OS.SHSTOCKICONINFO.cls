"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.SHSTOCKICONINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_HICON' -> 16r4.
		'_OffsetOf_iIcon' -> 16rC.
		'_OffsetOf_iSysImageIndex' -> 16r8.
		'_OffsetOf_szPath' -> 16r10
	}!
OS.SHSTOCKICONINFO guid: (Core.GUID fromString: '{94b6ea81-773c-47d8-9e64-b42f7a2ac6dc}')!
OS.SHSTOCKICONINFO comment: '`SHSTOCKICONINFO` is an `External.Structure` class to wrap the struct ''Win32.SHSTOCKICONINFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Receives information used to retrieve a stock Shell icon. This structure is used in a call SHGetStockIconInfo."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(94b6ea81-773c-47d8-9e64-b42f7a2ac6dc), helpstring("Receives information used to retrieve a stock Shell icon. This structure is used in a call SHGetStockIconInfo.")]
struct tagSHSTOCKICONINFO {
	[restricted] DWORD dwSize;
	[readonly] HICON HICON;
	[readonly] int iSysImageIndex;
	[readonly] int iIcon;
	[readonly, string] unsigned short szPath[260];
} SHSTOCKICONINFO;
```
'!
!OS.SHSTOCKICONINFO categoriesForClass!Win32-Structs! !
!OS.SHSTOCKICONINFO methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

HICON
	"Answer the <Handle> value of the receiver's 'HICON' field."

	^(bytes uintPtrAtOffset: _OffsetOf_HICON) asExternalHandle!

iIcon
	"Answer the <Integer> value of the receiver's 'iIcon' field."

	^bytes sdwordAtOffset: _OffsetOf_iIcon!

iSysImageIndex
	"Answer the <Integer> value of the receiver's 'iSysImageIndex' field."

	^bytes sdwordAtOffset: _OffsetOf_iSysImageIndex!

szPath
	"Answer the <Utf16String> value of the receiver's 'szPath' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szPath! !
!OS.SHSTOCKICONINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!OS.SHSTOCKICONINFO categoriesFor: #HICON!**compiled accessors**!public! !
!OS.SHSTOCKICONINFO categoriesFor: #iIcon!**compiled accessors**!public! !
!OS.SHSTOCKICONINFO categoriesFor: #iSysImageIndex!**compiled accessors**!public! !
!OS.SHSTOCKICONINFO categoriesFor: #szPath!**compiled accessors**!public! !

!OS.SHSTOCKICONINFO class methodsFor!

defineFields
	"Define the fields of the SHSTOCKICONINFO structure.

	SHSTOCKICONINFO compileDefinition

		typedef [uuid(94b6ea81-773c-47d8-9e64-b42f7a2ac6dc), helpstring('Receives information used to retrieve a stock Shell icon. This structure is used in a call SHGetStockIconInfo.')]
		struct tagSHSTOCKICONINFO {
			[restricted] DWORD dwSize;
			[readonly] HICON HICON;
			[readonly] int iSysImageIndex;
			[readonly] int iIcon;
			[readonly, string] unsigned short szPath[260];
		} SHSTOCKICONINFO;
"

	self
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #HICON type: HANDLEField new beReadOnly offset: 4;
		defineField: #iSysImageIndex type: SDWORDField new beReadOnly offset: 8;
		defineField: #iIcon type: SDWORDField new beReadOnly offset: 12;
		defineField: #szPath type: (StringField type: Utf16String length: 260) beReadOnly offset: 16.
	self byteSize: 536!

getFieldNames
	^#(#dwSize #HICON #iSysImageIndex #iIcon #szPath)! !
!OS.SHSTOCKICONINFO class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!OS.SHSTOCKICONINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

