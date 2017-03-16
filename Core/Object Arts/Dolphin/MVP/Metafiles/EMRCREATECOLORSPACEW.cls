"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRCREATECOLORSPACEW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRCREATECOLORSPACEW guid: (GUID fromString: '{27b16b33-1f59-4046-ae08-0652f9c089f1}')!
EMRCREATECOLORSPACEW comment: '<EMRCREATECOLORSPACEW> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATECOLORSPACEW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(27B16B33-1F59-4046-AE08-0652F9C089F1)]
struct tagEMRCREATECOLORSPACEW {
	EMR EMR;
	[helpstring("ColorSpace handle index")] DWORD ihCS;
	[helpstring("Unicode version of logical color space structure")] LOGCOLORSPACEW lcs;
	[helpstring("flags")] DWORD dwFlags;
	[helpstring("size of raw source profile data if attached")] DWORD cbData;
	[helpstring("Array size is cbData")] BYTE* Data;
} EMRCREATECOLORSPACEW;
'!
!EMRCREATECOLORSPACEW categoriesForClass!Win32-Structs! !
!EMRCREATECOLORSPACEW methodsFor!

cbData
	"Answer the receiver's cbData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbData)!

cbData: anObject 
	"Set the receiver's cbData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbData) put: anObject!

Data
	"Answer the receiver's Data field as a Smalltalk object."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #Data) length: self cbData!

Data: anObject 
	"Set the receiver's Data field to the value of anObject."

	| size |
	size := anObject byteSize min: self cbData * ##(ExternalArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Data) + 1)
		to: ##(self offsetOf: #Data) + size
		startingAt: 1!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

ihCS
	"Answer the receiver's ihCS field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihCS)!

ihCS: anObject 
	"Set the receiver's ihCS field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihCS) put: anObject!

lcs
	"Answer the receiver's lcs field as a Smalltalk object."

	^LOGCOLORSPACEW fromAddress: bytes yourAddress + ##(self offsetOf: #lcs)!

lcs: anObject 
	"Set the receiver's lcs field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #lcs) + 1)
		to: ##((self offsetOf: #lcs) + LOGCOLORSPACEW basicByteSize)
		startingAt: 1! !
!EMRCREATECOLORSPACEW categoriesFor: #cbData!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #cbData:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #Data!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #Data:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #dwFlags!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #dwFlags:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #ihCS!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #ihCS:!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #lcs!**compiled accessors**!public! !
!EMRCREATECOLORSPACEW categoriesFor: #lcs:!**compiled accessors**!public! !

!EMRCREATECOLORSPACEW class methodsFor!

defineFields
	"Define the fields of the EMRCREATECOLORSPACEW structure.

	EMRCREATECOLORSPACEW  compileDefinition

		typedef [uuid(27B16B33-1F59-4046-AE08-0652F9C089F1)]
		struct tagEMRCREATECOLORSPACEW {
			EMR EMR;
			[helpstring('ColorSpace handle index')] DWORD ihCS;
			[helpstring('Unicode version of logical color space structure')] LOGCOLORSPACEW lcs;
			[helpstring('flags')] DWORD dwFlags;
			[helpstring('size of raw source profile data if attached')] DWORD cbData;
			[size_is(cbData)] BYTE Data[];
		} EMRCREATECOLORSPACEW;
"

	super defineFields.
	self
		defineField: #ihCS
			type: DWORDField new
			offset: 8;
		defineField: #lcs
			type: (StructureField type: LOGCOLORSPACEW)
			offset: 12;
		defineField: #dwFlags
			type: DWORDField new
			offset: 340;
		defineField: #cbData
			type: DWORDField new
			offset: 344;
		defineField: #Data
			type: (ConformantArrayField type: ExternalArray length: #cbData)
			offset: 348!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_CREATECOLORSPACEW! !
!EMRCREATECOLORSPACEW class categoriesFor: #defineFields!initializing!public! !
!EMRCREATECOLORSPACEW class categoriesFor: #iTypes!constants!public! !

