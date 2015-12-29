"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #COLORADJUSTMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COLORADJUSTMENT guid: (GUID fromString: '{DBE19B72-CEA9-47CF-80F1-DE6D59EEFD32}')!
COLORADJUSTMENT comment: '<COLORADJUSTMENT> is an <ExternalStructure> class to wrap the struct ''Win32.COLORADJUSTMENT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(DBE19B72-CEA9-47CF-80F1-DE6D59EEFD32)]
struct tagCOLORADJUSTMENT {
	WORD caSize;
	WORD caFlags;
	WORD caIlluminantIndex;
	WORD caRedGamma;
	WORD caGreenGamma;
	WORD caBlueGamma;
	WORD caReferenceBlack;
	WORD caReferenceWhite;
	short caContrast;
	short caBrightness;
	short caColorfulness;
	short caRedGreenTint;
} COLORADJUSTMENT;
'!
!COLORADJUSTMENT categoriesForClass!Win32-Structs! !
!COLORADJUSTMENT methodsFor!

caBlueGamma
	"Answer the receiver's caBlueGamma field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caBlueGamma)!

caBlueGamma: anObject 
	"Set the receiver's caBlueGamma field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caBlueGamma) put: anObject!

caBrightness
	"Answer the receiver's caBrightness field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #caBrightness)!

caBrightness: anObject 
	"Set the receiver's caBrightness field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #caBrightness) put: anObject!

caColorfulness
	"Answer the receiver's caColorfulness field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #caColorfulness)!

caColorfulness: anObject 
	"Set the receiver's caColorfulness field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #caColorfulness) put: anObject!

caContrast
	"Answer the receiver's caContrast field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #caContrast)!

caContrast: anObject 
	"Set the receiver's caContrast field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #caContrast) put: anObject!

caFlags
	"Answer the receiver's caFlags field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caFlags)!

caFlags: anObject 
	"Set the receiver's caFlags field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caFlags) put: anObject!

caGreenGamma
	"Answer the receiver's caGreenGamma field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caGreenGamma)!

caGreenGamma: anObject 
	"Set the receiver's caGreenGamma field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caGreenGamma) put: anObject!

caIlluminantIndex
	"Answer the receiver's caIlluminantIndex field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caIlluminantIndex)!

caIlluminantIndex: anObject 
	"Set the receiver's caIlluminantIndex field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caIlluminantIndex) put: anObject!

caRedGamma
	"Answer the receiver's caRedGamma field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caRedGamma)!

caRedGamma: anObject 
	"Set the receiver's caRedGamma field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caRedGamma) put: anObject!

caRedGreenTint
	"Answer the receiver's caRedGreenTint field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #caRedGreenTint)!

caRedGreenTint: anObject 
	"Set the receiver's caRedGreenTint field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #caRedGreenTint) put: anObject!

caReferenceBlack
	"Answer the receiver's caReferenceBlack field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caReferenceBlack)!

caReferenceBlack: anObject 
	"Set the receiver's caReferenceBlack field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caReferenceBlack) put: anObject!

caReferenceWhite
	"Answer the receiver's caReferenceWhite field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #caReferenceWhite)!

caReferenceWhite: anObject 
	"Set the receiver's caReferenceWhite field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #caReferenceWhite) put: anObject!

caSize
	"Answer the receiver's caSize field as a Smalltalk object."

	^bytes wordAtOffset: 0!

caSize: anObject 
	"Set the receiver's caSize field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!COLORADJUSTMENT categoriesFor: #caBlueGamma!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caBlueGamma:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caBrightness!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caBrightness:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caColorfulness!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caColorfulness:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caContrast!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caContrast:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caFlags!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caFlags:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caGreenGamma!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caGreenGamma:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caIlluminantIndex!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caIlluminantIndex:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caRedGamma!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caRedGamma:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caRedGreenTint!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caRedGreenTint:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caReferenceBlack!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caReferenceBlack:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caReferenceWhite!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caReferenceWhite:!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caSize!**compiled accessors**!public! !
!COLORADJUSTMENT categoriesFor: #caSize:!**compiled accessors**!public! !

!COLORADJUSTMENT class methodsFor!

defineFields
	"Define the fields of the COLORADJUSTMENT structure.

	COLORADJUSTMENT  compileDefinition

		typedef [uuid(DBE19B72-CEA9-47CF-80F1-DE6D59EEFD32)]
		struct tagCOLORADJUSTMENT {
			WORD caSize;
			WORD caFlags;
			WORD caIlluminantIndex;
			WORD caRedGamma;
			WORD caGreenGamma;
			WORD caBlueGamma;
			WORD caReferenceBlack;
			WORD caReferenceWhite;
			short caContrast;
			short caBrightness;
			short caColorfulness;
			short caRedGreenTint;
		} COLORADJUSTMENT;
"

	self
		defineField: #caSize type: WORDField new offset: 0;
		defineField: #caFlags type: WORDField new offset: 2;
		defineField: #caIlluminantIndex type: WORDField new offset: 4;
		defineField: #caRedGamma type: WORDField new offset: 6;
		defineField: #caGreenGamma type: WORDField new offset: 8;
		defineField: #caBlueGamma type: WORDField new offset: 10;
		defineField: #caReferenceBlack type: WORDField new offset: 12;
		defineField: #caReferenceWhite type: WORDField new offset: 14;
		defineField: #caContrast type: SWORDField new offset: 16;
		defineField: #caBrightness type: SWORDField new offset: 18;
		defineField: #caColorfulness type: SWORDField new offset: 20;
		defineField: #caRedGreenTint type: SWORDField new offset: 22.
	self byteSize: 24! !
!COLORADJUSTMENT class categoriesFor: #defineFields!**auto generated**!initializing!public! !

