"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #COLORADJUSTMENT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_caBlueGamma _OffsetOf_caBrightness _OffsetOf_caColorfulness _OffsetOf_caContrast _OffsetOf_caFlags _OffsetOf_caGreenGamma _OffsetOf_caIlluminantIndex _OffsetOf_caRedGamma _OffsetOf_caRedGreenTint _OffsetOf_caReferenceBlack _OffsetOf_caReferenceWhite _OffsetOf_caSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

COLORADJUSTMENT guid: (GUID fromString: '{dbe19b72-cea9-47cf-80f1-de6d59eefd32}')!

COLORADJUSTMENT addClassConstant: '_OffsetOf_caBlueGamma' value: 16rA!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caBrightness' value: 16r12!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caColorfulness' value: 16r14!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caContrast' value: 16r10!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caFlags' value: 16r2!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caGreenGamma' value: 16r8!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caIlluminantIndex' value: 16r4!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caRedGamma' value: 16r6!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caRedGreenTint' value: 16r16!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caReferenceBlack' value: 16rC!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caReferenceWhite' value: 16rE!
COLORADJUSTMENT addClassConstant: '_OffsetOf_caSize' value: 16r0!

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

	^bytes wordAtOffset: _OffsetOf_caBlueGamma!

caBlueGamma: anInteger
	"Set the receiver's 'caBlueGamma' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caBlueGamma put: anInteger!

caBrightness
	"Answer the <Integer> value of the receiver's 'caBrightness' field."

	^bytes swordAtOffset: _OffsetOf_caBrightness!

caBrightness: anInteger
	"Set the receiver's 'caBrightness' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_caBrightness put: anInteger!

caColorfulness
	"Answer the <Integer> value of the receiver's 'caColorfulness' field."

	^bytes swordAtOffset: _OffsetOf_caColorfulness!

caColorfulness: anInteger
	"Set the receiver's 'caColorfulness' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_caColorfulness put: anInteger!

caContrast
	"Answer the <Integer> value of the receiver's 'caContrast' field."

	^bytes swordAtOffset: _OffsetOf_caContrast!

caContrast: anInteger
	"Set the receiver's 'caContrast' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_caContrast put: anInteger!

caFlags
	"Answer the <Integer> value of the receiver's 'caFlags' field."

	^bytes wordAtOffset: _OffsetOf_caFlags!

caFlags: anInteger
	"Set the receiver's 'caFlags' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caFlags put: anInteger!

caGreenGamma
	"Answer the <Integer> value of the receiver's 'caGreenGamma' field."

	^bytes wordAtOffset: _OffsetOf_caGreenGamma!

caGreenGamma: anInteger
	"Set the receiver's 'caGreenGamma' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caGreenGamma put: anInteger!

caIlluminantIndex
	"Answer the <Integer> value of the receiver's 'caIlluminantIndex' field."

	^bytes wordAtOffset: _OffsetOf_caIlluminantIndex!

caIlluminantIndex: anInteger
	"Set the receiver's 'caIlluminantIndex' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caIlluminantIndex put: anInteger!

caRedGamma
	"Answer the <Integer> value of the receiver's 'caRedGamma' field."

	^bytes wordAtOffset: _OffsetOf_caRedGamma!

caRedGamma: anInteger
	"Set the receiver's 'caRedGamma' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caRedGamma put: anInteger!

caRedGreenTint
	"Answer the <Integer> value of the receiver's 'caRedGreenTint' field."

	^bytes swordAtOffset: _OffsetOf_caRedGreenTint!

caRedGreenTint: anInteger
	"Set the receiver's 'caRedGreenTint' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_caRedGreenTint put: anInteger!

caReferenceBlack
	"Answer the <Integer> value of the receiver's 'caReferenceBlack' field."

	^bytes wordAtOffset: _OffsetOf_caReferenceBlack!

caReferenceBlack: anInteger
	"Set the receiver's 'caReferenceBlack' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caReferenceBlack put: anInteger!

caReferenceWhite
	"Answer the <Integer> value of the receiver's 'caReferenceWhite' field."

	^bytes wordAtOffset: _OffsetOf_caReferenceWhite!

caReferenceWhite: anInteger
	"Set the receiver's 'caReferenceWhite' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caReferenceWhite put: anInteger!

caSize
	"Answer the <Integer> value of the receiver's 'caSize' field."

	^bytes wordAtOffset: _OffsetOf_caSize!

caSize: anInteger
	"Set the receiver's 'caSize' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_caSize put: anInteger! !

!COLORADJUSTMENT categoriesForMethods!
caBlueGamma!**compiled accessors**!public! !
caBlueGamma:!**compiled accessors**!public! !
caBrightness!**compiled accessors**!public! !
caBrightness:!**compiled accessors**!public! !
caColorfulness!**compiled accessors**!public! !
caColorfulness:!**compiled accessors**!public! !
caContrast!**compiled accessors**!public! !
caContrast:!**compiled accessors**!public! !
caFlags!**compiled accessors**!public! !
caFlags:!**compiled accessors**!public! !
caGreenGamma!**compiled accessors**!public! !
caGreenGamma:!**compiled accessors**!public! !
caIlluminantIndex!**compiled accessors**!public! !
caIlluminantIndex:!**compiled accessors**!public! !
caRedGamma!**compiled accessors**!public! !
caRedGamma:!**compiled accessors**!public! !
caRedGreenTint!**compiled accessors**!public! !
caRedGreenTint:!**compiled accessors**!public! !
caReferenceBlack!**compiled accessors**!public! !
caReferenceBlack:!**compiled accessors**!public! !
caReferenceWhite!**compiled accessors**!public! !
caReferenceWhite:!**compiled accessors**!public! !
caSize!**compiled accessors**!public! !
caSize:!**compiled accessors**!public! !
!

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

!COLORADJUSTMENT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

