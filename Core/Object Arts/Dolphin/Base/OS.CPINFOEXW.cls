"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.CPINFOEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_CPINFOEXW_Size' -> 16r220.
		'_OffsetOf_codepage' -> 16r14.
		'_OffsetOf_CodePageName' -> 16r18.
		'_OffsetOf_DefaultChar' -> 16r4.
		'_OffsetOf_LeadByte' -> 16r6.
		'_OffsetOf_MaxCharSize' -> 16r0.
		'_OffsetOf_UnicodeDefaultChar' -> 16r12
	}!
OS.CPINFOEXW guid: (Core.GUID fromString: '{daee0d37-37b6-4a47-a208-c12409c7f158}')!
OS.CPINFOEXW comment: '<CPINFOEXW> is an <ExternalStructure> class to wrap the struct ''Win32.CPINFOEXW'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains information about a code page. This structure is used by the GetCPInfoExW function."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(daee0d37-37b6-4a47-a208-c12409c7f158), helpstring("Contains information about a code page. This structure is used by the GetCPInfoExW function.")]
struct tagCPINFOEXW {
	[readonly, helpstring("max length (in bytes) of a char")] unsigned int MaxCharSize;
	[readonly, helpstring("default character (MB)")] BYTE DefaultChar[2];
	[readonly, helpstring("lead byte ranges")] BYTE LeadByte[12];
	[readonly, helpstring("default character (Unicode)")] unsigned short UnicodeDefaultChar;
	[readonly, helpstring("code page id")] unsigned int codepage;
	[readonly, helpstring("code page name (Unicode)"), string] unsigned short CodePageName[260];
} CPINFOEXW;
'!
!OS.CPINFOEXW categoriesForClass!Win32-Structs! !
!OS.CPINFOEXW methodsFor!

codepage
	"Answer the <Integer> value of the receiver's 'codepage' field."

	^bytes uint32AtOffset: _OffsetOf_codepage!

CodePageName
	"Answer the <Utf16String> value of the receiver's 'CodePageName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_CodePageName!

DefaultChar
	"Answer the <ExternalArray> value of the receiver's 'DefaultChar' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_DefaultChar length: 2!

defaultCharacter
	"The character used for code points that cannot be represented on the code page described by the receiver."

	| utf16 |
	utf16 := Utf16String newFixed: 2.
	(Kernel32
		multiByteToWideChar: self codepage
		dwFlags: 0
		lpMultiByteStr: bytes yourAddress + _OffsetOf_DefaultChar
		cchMultiByte: 2
		lpWideCharStr: utf16
		cchWideChar: 2) == 0
		ifTrue: [^Kernel32 systemError].
	^utf16 at: 1!

LeadByte
	"Answer the <ExternalArray> value of the receiver's 'LeadByte' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_LeadByte length: 12!

MaxCharSize
	"Answer the <Integer> value of the receiver's 'MaxCharSize' field."

	^bytes uint32AtOffset: _OffsetOf_MaxCharSize!

unicodeDefaultChar
	"Answer the default Unicode character for the described code page."

	^Character codePoint: self UnicodeDefaultChar!

UnicodeDefaultChar
	"Answer the <Integer> value of the receiver's 'UnicodeDefaultChar' field."

	^bytes uint16AtOffset: _OffsetOf_UnicodeDefaultChar! !
!OS.CPINFOEXW categoriesForMethods!
codepage!**compiled accessors**!public! !
CodePageName!**compiled accessors**!public! !
DefaultChar!**compiled accessors**!public! !
defaultCharacter!accessing!public! !
LeadByte!**compiled accessors**!public! !
MaxCharSize!**compiled accessors**!public! !
unicodeDefaultChar!accessing!public! !
UnicodeDefaultChar!**compiled accessors**!public! !
!

!OS.CPINFOEXW class methodsFor!

byteSize
	^_CPINFOEXW_Size!

codePage: anInteger
	| cpinfo |
	cpinfo := self newBuffer.
	Kernel32
		getCPInfoExW: anInteger
		dwFlags: 0
		lpCPInfoEx: cpinfo.
	^cpinfo!

defineFields
	"Define the fields of the CPINFOEXW structure.

	CPINFOEXW compileDefinition

		typedef [uuid(daee0d37-37b6-4a47-a208-c12409c7f158), helpstring('Contains information about a code page. This structure is used by the GetCPInfoExW function.')]
		struct tagCPINFOEXW {
			[readonly, helpstring('max length (in bytes) of a char')] unsigned int MaxCharSize;
			[readonly, helpstring('default character (MB)')] BYTE DefaultChar[2];
			[readonly, helpstring('lead byte ranges')] BYTE LeadByte[12];
			[readonly, helpstring('default character (Unicode)')] unsigned short UnicodeDefaultChar;
			[readonly, helpstring('code page id')] unsigned int codepage;
			[readonly, helpstring('code page name (Unicode)'), string] unsigned short CodePageName[260];
		} CPINFOEXW;
"

	self
		defineField: #MaxCharSize
			type: UInt32Field new beReadOnly
			offset: 0;
		defineField: #DefaultChar
			type: (ArrayField type: ExternalArray length: 2) beReadOnly
			offset: 4;
		defineField: #LeadByte
			type: (ArrayField type: ExternalArray length: 12) beReadOnly
			offset: 6;
		defineField: #UnicodeDefaultChar
			type: UInt16Field new beReadOnly
			offset: 18;
		defineField: #codepage
			type: UInt32Field new beReadOnly
			offset: 20;
		defineField: #CodePageName
			type: (StringField type: Utf16String length: 260) beReadOnly
			offset: 24.
	self byteSize: 544!

getFieldNames
	^#(#MaxCharSize #DefaultChar #LeadByte #UnicodeDefaultChar #codepage #CodePageName)! !
!OS.CPINFOEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
codePage:!instance creation!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

