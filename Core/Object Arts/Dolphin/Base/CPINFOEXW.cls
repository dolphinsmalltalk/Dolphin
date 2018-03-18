"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #CPINFOEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CPINFOEXW guid: (GUID fromString: '{daee0d37-37b6-4a47-a208-c12409c7f158}')!
CPINFOEXW comment: '<CPINFOEXW> is an <ExternalStructure> class to wrap the struct ''Win32.CPINFOEXW'' from type information in the ''Win32 API'' library.

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
!CPINFOEXW categoriesForClass!Win32-Structs! !
!CPINFOEXW methodsFor!

codepage
	"Answer the <Integer> value of the receiver's 'codepage' field."

	^bytes dwordAtOffset: ##(self offsetOf: #codepage)!

CodePageName
	"Answer the <Utf16String> value of the receiver's 'CodePageName' field."

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #CodePageName)!

DefaultChar
	"Answer the <ExternalArray> value of the receiver's 'DefaultChar' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #DefaultChar) length: 2!

defaultCharacter
	"The character used for code points that cannot be represented on the code page described by the receiver."

	| utf16 |
	utf16 := Utf16String new: 2.
	(KernelLibrary default
		multiByteToWideChar: self codepage
		dwFlags: 0
		lpMultiByteStr: bytes yourAddress + ##(self offsetOf: #DefaultChar)
		cchMultiByte: 2
		lpWideCharStr: utf16
		cchWideChar: 2) == 0
		ifTrue: [^KernelLibrary default systemError].
	^utf16 at: 1!

LeadByte
	"Answer the <ExternalArray> value of the receiver's 'LeadByte' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #LeadByte) length: 12!

MaxCharSize
	"Answer the <Integer> value of the receiver's 'MaxCharSize' field."

	^bytes dwordAtOffset: 0!

UnicodeDefaultChar
	"Answer the <Integer> value of the receiver's 'UnicodeDefaultChar' field."

	^bytes wordAtOffset: ##(self offsetOf: #UnicodeDefaultChar)! !
!CPINFOEXW categoriesFor: #codepage!**compiled accessors**!public! !
!CPINFOEXW categoriesFor: #CodePageName!**compiled accessors**!public! !
!CPINFOEXW categoriesFor: #DefaultChar!**compiled accessors**!public! !
!CPINFOEXW categoriesFor: #defaultCharacter!accessing!public! !
!CPINFOEXW categoriesFor: #LeadByte!**compiled accessors**!public! !
!CPINFOEXW categoriesFor: #MaxCharSize!**compiled accessors**!public! !
!CPINFOEXW categoriesFor: #UnicodeDefaultChar!**compiled accessors**!public! !

!CPINFOEXW class methodsFor!

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
		defineField: #MaxCharSize type: DWORDField new beReadOnly offset: 0;
		defineField: #DefaultChar type: (ArrayField type: ExternalArray length: 2) beReadOnly offset: 4;
		defineField: #LeadByte type: (ArrayField type: ExternalArray length: 12) beReadOnly offset: 6;
		defineField: #UnicodeDefaultChar type: WORDField new beReadOnly offset: 18;
		defineField: #codepage type: DWORDField new beReadOnly offset: 20;
		defineField: #CodePageName type: (StringField type: Utf16String length: 260) beReadOnly offset: 24.
	self byteSize: 544! !
!CPINFOEXW class categoriesFor: #defineFields!**auto generated**!initializing!public! !

