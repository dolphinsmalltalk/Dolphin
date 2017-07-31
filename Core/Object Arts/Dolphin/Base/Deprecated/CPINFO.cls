"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #CPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CPINFO guid: (GUID fromString: '{00c3c027-fa7e-43cb-b7cc-39d358049048}')!
CPINFO comment: '<CPINFO> is an <ExternalStructure> class to wrap the struct ''Win32.CPINFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains information about a code page. This structure is used by the GetCPInfo function."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(00c3c027-fa7e-43cb-b7cc-39d358049048), helpstring("Contains information about a code page. This structure is used by the GetCPInfo function.")]
struct tagCPINFO {
	[readonly, helpstring("Maximum length, in bytes, of a character in the code page.")] unsigned int MaxCharSize;
	[readonly, helpstring("Default character used when translating character strings to the specific code page.")] BYTE DefaultChar[2];
	[readonly, helpstring("A fixed-length array of lead byte ranges, for which the number of lead byte ranges is variable.")] BYTE LeadByte[12];
} CPINFO;
'!
!CPINFO categoriesForClass!Win32-Structs! !
!CPINFO methodsFor!

DefaultChar
	"Answer the <ExternalArray> value of the receiver's 'DefaultChar' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #DefaultChar) length: 2!

LeadByte
	"Answer the <ExternalArray> value of the receiver's 'LeadByte' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #LeadByte) length: 12!

MaxCharSize
	"Answer the <Integer> value of the receiver's 'MaxCharSize' field."

	^bytes dwordAtOffset: 0! !
!CPINFO categoriesFor: #DefaultChar!**compiled accessors**!public! !
!CPINFO categoriesFor: #LeadByte!**compiled accessors**!public! !
!CPINFO categoriesFor: #MaxCharSize!**compiled accessors**!public! !

!CPINFO class methodsFor!

defineFields
	"Define the fields of the CPINFO structure.

	CPINFO compileDefinition

		typedef [uuid(00c3c027-fa7e-43cb-b7cc-39d358049048), helpstring('Contains information about a code page. This structure is used by the GetCPInfo function.')]
		struct tagCPINFO {
			[readonly, helpstring('Maximum length, in bytes, of a character in the code page.')] unsigned int MaxCharSize;
			[readonly, helpstring('Default character used when translating character strings to the specific code page.')] BYTE DefaultChar[2];
			[readonly, helpstring('A fixed-length array of lead byte ranges, for which the number of lead byte ranges is variable.')] BYTE LeadByte[12];
		} CPINFO;
"

	self
		defineField: #MaxCharSize type: DWORDField new beReadOnly offset: 0;
		defineField: #DefaultChar type: (ArrayField type: ExternalArray length: 2) beReadOnly offset: 4;
		defineField: #LeadByte type: (ArrayField type: ExternalArray length: 12) beReadOnly offset: 6.
	self byteSize: 20! !
!CPINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

