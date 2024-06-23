"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.SHSTOCKICONINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hIcon' -> 16r4.
			'_OffsetOf_iIcon' -> 16rC.
			'_OffsetOf_iSysImageIndex' -> 16r8.
			'_OffsetOf_szPath' -> 16r10.
			'_SHSTOCKICONINFO_Size' -> 16r218.
			'SHGSI_ICON' -> 16r100.
			'SHGSI_ICONLOCATION' -> 16r0.
			'SHGSI_LARGEICON' -> 16r0.
			'SHGSI_SMALLICON' -> 16r1
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

hIcon
	"Answer the <Handle> value of the receiver's 'hIcon' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hIcon) asExternalHandle!

iIcon
	"Answer the <Integer> value of the receiver's 'iIcon' field."

	^bytes int32AtOffset: _OffsetOf_iIcon!

iSysImageIndex
	"Answer the <Integer> value of the receiver's 'iSysImageIndex' field."

	^bytes int32AtOffset: _OffsetOf_iSysImageIndex!

szPath
	"Answer the <Utf16String> value of the receiver's 'szPath' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szPath! !

!OS.SHSTOCKICONINFO categoriesForMethods!
hIcon!**compiled accessors**!public! !
iIcon!**compiled accessors**!public! !
iSysImageIndex!**compiled accessors**!public! !
szPath!**compiled accessors**!public! !
!

!OS.SHSTOCKICONINFO class methodsFor!

byteSize
	^_SHSTOCKICONINFO_Size!

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

	super defineFields.
	self
		defineField: #hIcon type: HANDLEField new beReadOnly offset: 4;
		defineField: #iSysImageIndex type: Int32Field new beReadOnly offset: 8;
		defineField: #iIcon type: Int32Field new beReadOnly offset: 12;
		defineField: #szPath type: (StringField type: Utf16String length: 260) beReadOnly offset: 16.
	self byteSize: 536!

getFieldNames
	^#(#dwSize #hIcon #iSysImageIndex #iIcon #szPath)! !

!OS.SHSTOCKICONINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

