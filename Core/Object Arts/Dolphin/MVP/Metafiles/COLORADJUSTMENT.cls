"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #COLORADJUSTMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COLORADJUSTMENT guid: (GUID fromString: '{dbe19b72-cea9-47cf-80f1-de6d59eefd32}')!
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
	"Answer the <Integer> value of the receiver's 'caBlueGamma' field."

	^bytes wordAtOffset: ##(self offsetOf: #caBlueGamma)!

caBlueGamma: anInteger
	"Set the receiver's 'caBlueGamma' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caBlueGamma) put: anInteger!

caBrightness
	"Answer the <Integer> value of the receiver's 'caBrightness' field."

	^bytes swordAtOffset: ##(self offsetOf: #caBrightness)!

caBrightness: anInteger
	"Set the receiver's 'caBrightness' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #caBrightness) put: anInteger!

caColorfulness
	"Answer the <Integer> value of the receiver's 'caColorfulness' field."

	^bytes swordAtOffset: ##(self offsetOf: #caColorfulness)!

caColorfulness: anInteger
	"Set the receiver's 'caColorfulness' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #caColorfulness) put: anInteger!

caContrast
	"Answer the <Integer> value of the receiver's 'caContrast' field."

	^bytes swordAtOffset: ##(self offsetOf: #caContrast)!

caContrast: anInteger
	"Set the receiver's 'caContrast' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #caContrast) put: anInteger!

caFlags
	"Answer the <Integer> value of the receiver's 'caFlags' field."

	^bytes wordAtOffset: ##(self offsetOf: #caFlags)!

caFlags: anInteger
	"Set the receiver's 'caFlags' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caFlags) put: anInteger!

caGreenGamma
	"Answer the <Integer> value of the receiver's 'caGreenGamma' field."

	^bytes wordAtOffset: ##(self offsetOf: #caGreenGamma)!

caGreenGamma: anInteger
	"Set the receiver's 'caGreenGamma' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caGreenGamma) put: anInteger!

caIlluminantIndex
	"Answer the <Integer> value of the receiver's 'caIlluminantIndex' field."

	^bytes wordAtOffset: ##(self offsetOf: #caIlluminantIndex)!

caIlluminantIndex: anInteger
	"Set the receiver's 'caIlluminantIndex' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caIlluminantIndex) put: anInteger!

caRedGamma
	"Answer the <Integer> value of the receiver's 'caRedGamma' field."

	^bytes wordAtOffset: ##(self offsetOf: #caRedGamma)!

caRedGamma: anInteger
	"Set the receiver's 'caRedGamma' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caRedGamma) put: anInteger!

caRedGreenTint
	"Answer the <Integer> value of the receiver's 'caRedGreenTint' field."

	^bytes swordAtOffset: ##(self offsetOf: #caRedGreenTint)!

caRedGreenTint: anInteger
	"Set the receiver's 'caRedGreenTint' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #caRedGreenTint) put: anInteger!

caReferenceBlack
	"Answer the <Integer> value of the receiver's 'caReferenceBlack' field."

	^bytes wordAtOffset: ##(self offsetOf: #caReferenceBlack)!

caReferenceBlack: anInteger
	"Set the receiver's 'caReferenceBlack' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caReferenceBlack) put: anInteger!

caReferenceWhite
	"Answer the <Integer> value of the receiver's 'caReferenceWhite' field."

	^bytes wordAtOffset: ##(self offsetOf: #caReferenceWhite)!

caReferenceWhite: anInteger
	"Set the receiver's 'caReferenceWhite' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #caReferenceWhite) put: anInteger!

caSize
	"Answer the <Integer> value of the receiver's 'caSize' field."

	^bytes wordAtOffset: 0!

caSize: anInteger
	"Set the receiver's 'caSize' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger! !
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
	self byteSize: 24!

getFieldNames
	^#(#caSize #caFlags #caIlluminantIndex #caRedGamma #caGreenGamma #caBlueGamma #caReferenceBlack #caReferenceWhite #caContrast #caBrightness #caColorfulness #caRedGreenTint)! !
!COLORADJUSTMENT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!COLORADJUSTMENT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

