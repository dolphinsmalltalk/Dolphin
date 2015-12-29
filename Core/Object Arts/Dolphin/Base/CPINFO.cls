"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #CPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CPINFO guid: (GUID fromString: '{00C3C027-FA7E-43CB-B7CC-39D358049048}')!
CPINFO comment: '<CPINFO> is an <ExternalStructure> class to wrap the struct ''Win32.CPINFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(00C3C027-FA7E-43CB-B7CC-39D358049048)]
struct tagCPINFO {
	[helpstring("max length (bytes) of a char")] UINT MaxCharSize;
	BYTE DefaultChar[2];
	BYTE LeadByte[12];
} CPINFO;
'!
!CPINFO categoriesForClass!Win32-Structs! !
!CPINFO methodsFor!

DefaultChar
	"Answer the receiver's DefaultChar field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #DefaultChar) length: 2!

LeadByte
	"Answer the receiver's LeadByte field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #LeadByte) length: 12!

MaxCharSize
	"Answer the receiver's MaxCharSize field as a Smalltalk object."

	^bytes dwordAtOffset: 0! !
!CPINFO categoriesFor: #DefaultChar!**compiled accessors**!public! !
!CPINFO categoriesFor: #LeadByte!**compiled accessors**!public! !
!CPINFO categoriesFor: #MaxCharSize!**compiled accessors**!public! !

!CPINFO class methodsFor!

defineFields
	"Define the fields of the CPINFO structure.

	CPINFO  compileDefinition

		typedef [uuid(00C3C027-FA7E-43CB-B7CC-39D358049048)]
		struct tagCPINFO {
			[helpstring('max length (bytes) of a char')] UINT MaxCharSize;
			BYTE DefaultChar[2];
			BYTE LeadByte[12];
		} CPINFO;
"

	self
		defineField: #MaxCharSize type: DWORDField readOnly;
		defineField: #DefaultChar type: (ArrayField type: ByteArray length: 2) beReadOnly;
		defineField: #LeadByte type: (ArrayField type: ByteArray length: 12) beReadOnly! !
!CPINFO class categoriesFor: #defineFields!initializing!public! !

