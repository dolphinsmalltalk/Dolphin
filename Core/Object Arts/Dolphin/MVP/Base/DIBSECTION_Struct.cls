"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #DIBSECTION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DIBSECTION guid: (GUID fromString: '{87b4c5e7-026e-11d3-9fd7-00a0cc3e4a32}')!
DIBSECTION comment: '<DIBSECTION> is an <ExternalStructure> class to wrap the struct ''Win.DIBSECTION'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagDIBSECTION {
	BITMAP dsBm;
	BITMAPINFOHEADER dsBmih;
	long dsBitfields[3];
	long dshSection;
	long dsOffset;
} DIBSECTION;
'!
!DIBSECTION categoriesForClass!Win32-Structs! !
!DIBSECTION methodsFor!

dsBitfields
	"Answer the receiver's dsBitfields field as a Smalltalk object."

	^DWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #dsBitfields) length: 3!

dsBm
	"Answer the receiver's dsBm field as a Smalltalk object."

	^BITMAP fromAddress: bytes yourAddress!

dsBm: anObject 
	"Set the receiver's dsBm field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(BITMAP basicByteSize)
		startingAt: 1!

dsBmih
	"Answer the receiver's dsBmih field as a Smalltalk object."

	^BITMAPINFOHEADER fromAddress: bytes yourAddress + ##(self offsetOf: #dsBmih)!

dsBmih: anObject 
	"Set the receiver's dsBmih field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #dsBmih) + 1)
		to: ##((self offsetOf: #dsBmih) + BITMAPINFOHEADER basicByteSize)
		startingAt: 1!

dshSection
	"Answer the receiver's dshSection field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #dshSection)) asExternalHandle!

dshSection: anObject 
	"Set the receiver's dshSection field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #dshSection) put: anObject!

dsOffset
	"Answer the receiver's dsOffset field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dsOffset)!

dsOffset: anObject 
	"Set the receiver's dsOffset field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dsOffset) put: anObject! !
!DIBSECTION categoriesFor: #dsBitfields!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dsBm!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dsBm:!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dsBmih!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dsBmih:!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dshSection!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dshSection:!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dsOffset!**compiled accessors**!public! !
!DIBSECTION categoriesFor: #dsOffset:!**compiled accessors**!public! !

!DIBSECTION class methodsFor!

defineFields
	"Define the fields of the DIBSECTION structure.
		DIBSECTION compileDefinition
	
		typedef [uuid(87B4C5E7-026E-11D3-9FD7-00A0CC3E4A32)]
		struct tagDIBSECTION {
			BITMAP dsBm;
			BITMAPINFOHEADER dsBmih;
			unsigned long dsBitfields[3];
			HANDLE dshSection;
			unsigned long dsOffset;
		} DIBSECTION;
"

	self
		defineField: #dsBm type: (StructureField type: BITMAP);
		defineField: #dsBmih type: (StructureField type: BITMAPINFOHEADER);
		defineField: #dsBitfields type: (ArrayField type: DWORDArray length: 3) beReadOnly;
		defineField: #dshSection type: HANDLEField new;
		defineField: #dsOffset type: DWORDField new!

fileOutStem
	"Private - Answer standard file name for the class to file out on."

	^'DIBSECTION_Struct'! !
!DIBSECTION class categoriesFor: #defineFields!initializing!public! !
!DIBSECTION class categoriesFor: #fileOutStem!private!source filing! !

