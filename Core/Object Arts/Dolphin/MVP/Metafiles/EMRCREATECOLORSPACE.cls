"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATECOLORSPACE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATECOLORSPACE guid: (GUID fromString: '{20d38d2a-27f0-4a74-ad30-adb4de0f37c1}')!
EMRCREATECOLORSPACE comment: '<EMRCREATECOLORSPACE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATECOLORSPACE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(20D38D2A-27F0-4A74-AD30-ADB4DE0F37C1)]
struct tagEMRCREATECOLORSPACE {
	EMR EMR;
	[helpstring("ColorSpace handle index")] DWORD ihCS;
	LOGCOLORSPACE lcs;
} EMRCREATECOLORSPACE;
'!
!EMRCREATECOLORSPACE categoriesForClass!Win32-Structs! !
!EMRCREATECOLORSPACE methodsFor!

ihCS
	"Answer the receiver's ihCS field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihCS)!

ihCS: anObject 
	"Set the receiver's ihCS field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihCS) put: anObject!

lcs
	"Answer the receiver's lcs field as a Smalltalk object."

	^LOGCOLORSPACE fromAddress: bytes yourAddress + ##(self offsetOf: #lcs)!

lcs: anObject 
	"Set the receiver's lcs field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lcs) + 1)
		to: ##((self offsetOf: #lcs) + LOGCOLORSPACE basicByteSize)
		startingAt: 1! !
!EMRCREATECOLORSPACE categoriesFor: #ihCS!**compiled accessors**!public! !
!EMRCREATECOLORSPACE categoriesFor: #ihCS:!**compiled accessors**!public! !
!EMRCREATECOLORSPACE categoriesFor: #lcs!**compiled accessors**!public! !
!EMRCREATECOLORSPACE categoriesFor: #lcs:!**compiled accessors**!public! !

!EMRCREATECOLORSPACE class methodsFor!

defineFields
	"Define the fields of the EMRCREATECOLORSPACE structure.

	EMRCREATECOLORSPACE  compileDefinition

		typedef [uuid(20D38D2A-27F0-4A74-AD30-ADB4DE0F37C1)]
		struct tagEMRCREATECOLORSPACE {
			EMR EMR;
			[helpstring('ColorSpace handle index')] DWORD ihCS;
			LOGCOLORSPACE lcs;
		} EMRCREATECOLORSPACE;
"

	super defineFields.
	self
		defineField: #ihCS type: DWORDField new offset: 8;
		defineField: #lcs type: (StructureField type: LOGCOLORSPACE) offset: 12.
	self byteSize: 340!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATECOLORSPACE! !
!EMRCREATECOLORSPACE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRCREATECOLORSPACE class categoriesFor: #iTypes!constants!public! !

