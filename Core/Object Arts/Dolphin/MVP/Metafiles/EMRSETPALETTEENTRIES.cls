"Filed out from Dolphin Smalltalk X6.1"!

ENHMETARECORD subclass: #EMRSETPALETTEENTRIES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRSETPALETTEENTRIES guid: (GUID fromString: '{E7BFC219-37E0-4690-BF26-61E47EF6CCFB}')!
EMRSETPALETTEENTRIES comment: '<EMRSETPALETTEENTRIES> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSETPALETTEENTRIES'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(E7BFC219-37E0-4690-BF26-61E47EF6CCFB)]
struct tagEMRSETPALETTEENTRIES {
	EMR EMR;
	[helpstring("Palette handle index")] DWORD ihPal;
	DWORD iStart;
	DWORD cEntries;
	PALETTEENTRY* aPalEntries;
} EMRSETPALETTEENTRIES;
'!
!EMRSETPALETTEENTRIES categoriesForClass!Win32-Structs! !
!EMRSETPALETTEENTRIES methodsFor!

aPalEntries
	"Answer the receiver's aPalEntries field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #aPalEntries)
		length: self cEntries
		elementClass: PALETTEENTRY!

aPalEntries: anObject 
	"Set the receiver's aPalEntries field to the value of anObject."

	| size |
	size := anObject byteSize min: self cEntries * ##(PALETTEENTRY basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aPalEntries) + 1)
		to: ##(self offsetOf: #aPalEntries) + size
		startingAt: 1!

cEntries
	"Answer the receiver's cEntries field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cEntries)!

cEntries: anObject 
	"Set the receiver's cEntries field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cEntries) put: anObject!

ihPal
	"Answer the receiver's ihPal field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ihPal)!

ihPal: anObject 
	"Set the receiver's ihPal field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ihPal) put: anObject!

iStart
	"Answer the receiver's iStart field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iStart)!

iStart: anObject 
	"Set the receiver's iStart field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iStart) put: anObject! !
!EMRSETPALETTEENTRIES categoriesFor: #aPalEntries!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #aPalEntries:!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #cEntries!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #cEntries:!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #ihPal!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #ihPal:!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #iStart!**compiled accessors**!public! !
!EMRSETPALETTEENTRIES categoriesFor: #iStart:!**compiled accessors**!public! !

!EMRSETPALETTEENTRIES class methodsFor!

defineFields
	"Define the fields of the EMRSETPALETTEENTRIES structure.

	EMRSETPALETTEENTRIES  compileDefinition

		typedef [uuid(E7BFC219-37E0-4690-BF26-61E47EF6CCFB)]
		struct tagEMRSETPALETTEENTRIES {
			EMR EMR;
			[helpstring('Palette handle index')] DWORD ihPal;
			DWORD iStart;
			DWORD cEntries;
			PALETTEENTRY* aPalEntries;
		} EMRSETPALETTEENTRIES;
"

	super defineFields.
	self
		defineField: #ihPal
			type: DWORDField new
			offset: 8;
		defineField: #iStart
			type: DWORDField new
			offset: 12;
		defineField: #cEntries
			type: DWORDField new
			offset: 16;
		defineField: #aPalEntries
			type: (ConformantStructureArrayField type: PALETTEENTRY length: #cEntries)
			offset: 20!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_SETPALETTEENTRIES! !
!EMRSETPALETTEENTRIES class categoriesFor: #defineFields!initializing!public! !
!EMRSETPALETTEENTRIES class categoriesFor: #iTypes!constants!public! !

