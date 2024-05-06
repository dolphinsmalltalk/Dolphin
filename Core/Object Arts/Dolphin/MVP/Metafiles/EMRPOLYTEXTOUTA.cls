"Filed out from Dolphin Smalltalk"!

ENHMETARECORD subclass: #EMRPOLYTEXTOUTA
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_aemrtext _OffsetOf_cStrings _OffsetOf_exScale _OffsetOf_eyScale _OffsetOf_iGraphicsMode _OffsetOf_rclBounds'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EMRPOLYTEXTOUTA guid: (GUID fromString: '{7c11c025-67e0-44de-87ab-e4f1377a4314}')!

EMRPOLYTEXTOUTA addClassConstant: '_OffsetOf_aemrtext' value: 16r28!
EMRPOLYTEXTOUTA addClassConstant: '_OffsetOf_cStrings' value: 16r24!
EMRPOLYTEXTOUTA addClassConstant: '_OffsetOf_exScale' value: 16r1C!
EMRPOLYTEXTOUTA addClassConstant: '_OffsetOf_eyScale' value: 16r20!
EMRPOLYTEXTOUTA addClassConstant: '_OffsetOf_iGraphicsMode' value: 16r18!
EMRPOLYTEXTOUTA addClassConstant: '_OffsetOf_rclBounds' value: 16r8!

EMRPOLYTEXTOUTA comment: '<EMRPOLYTEXTOUTA> is an <ExternalStructure> class to wrap the struct ''Win32.EMRPOLYTEXTOUTA'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7C11C025-67E0-44DE-87AB-E4F1377A4314)]
struct tagEMRPOLYTEXTOUTA {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Current graphics mode")] DWORD iGraphicsMode;
	[helpstring("X and Y scales from Page units to .01mm units")] float exScale;
	[helpstring("if graphics mode is GM_COMPATIBLE.")] float eyScale;
	long cStrings;
	[helpstring("Array of EMRTEXT structures.  This is followed by the strings and spacing arrays.")] EMRTEXT* aemrtext;
} EMRPOLYTEXTOUTA;
'!

!EMRPOLYTEXTOUTA categoriesForClass!Win32-Structs! !

!EMRPOLYTEXTOUTA methodsFor!

aemrtext
	"Answer the <StructureArray> value of the receiver's 'aemrtext' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_aemrtext
		length: self cStrings
		elementClass: EMRTEXT!

aemrtext: aStructureArrayOfEMRTEXT
	"Set the receiver's 'aemrtext' field to the value of the argument, aStructureArrayOfEMRTEXT"

	| size |
	size := aStructureArrayOfEMRTEXT byteSize.
	aStructureArrayOfEMRTEXT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_aemrtext + 1)
		to: _OffsetOf_aemrtext + size
		startingAt: 1.
	self cStrings: aStructureArrayOfEMRTEXT size!

cStrings
	"Answer the <Integer> value of the receiver's 'cStrings' field."

	^bytes sdwordAtOffset: _OffsetOf_cStrings!

cStrings: anInteger
	"Set the receiver's 'cStrings' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cStrings put: anInteger!

exScale
	"Answer the <Float> value of the receiver's 'exScale' field."

	^bytes floatAtOffset: _OffsetOf_exScale!

exScale: aFloat
	"Set the receiver's 'exScale' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_exScale put: aFloat!

eyScale
	"Answer the <Float> value of the receiver's 'eyScale' field."

	^bytes floatAtOffset: _OffsetOf_eyScale!

eyScale: aFloat
	"Set the receiver's 'eyScale' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eyScale put: aFloat!

iGraphicsMode
	"Answer the <Integer> value of the receiver's 'iGraphicsMode' field."

	^bytes dwordAtOffset: _OffsetOf_iGraphicsMode!

iGraphicsMode: anInteger
	"Set the receiver's 'iGraphicsMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iGraphicsMode put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1! !

!EMRPOLYTEXTOUTA categoriesForMethods!
aemrtext!**compiled accessors**!public! !
aemrtext:!**compiled accessors**!public! !
cStrings!**compiled accessors**!public! !
cStrings:!**compiled accessors**!public! !
exScale!**compiled accessors**!public! !
exScale:!**compiled accessors**!public! !
eyScale!**compiled accessors**!public! !
eyScale:!**compiled accessors**!public! !
iGraphicsMode!**compiled accessors**!public! !
iGraphicsMode:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
!

!EMRPOLYTEXTOUTA class methodsFor!

defineFields
	"Define the fields of the EMRPOLYTEXTOUTA structure.

	EMRPOLYTEXTOUTA  compileDefinition

		typedef [uuid(7C11C025-67E0-44DE-87AB-E4F1377A4314)]
		struct tagEMRPOLYTEXTOUTA {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			[helpstring('Current graphics mode')] DWORD iGraphicsMode;
			[helpstring('X and Y scales from Page units to .01mm units')] float exScale;
			[helpstring('if graphics mode is GM_COMPATIBLE.')] float eyScale;
			long cStrings;
			[helpstring('Array of EMRTEXT structures.  This is followed by the strings and spacing arrays.')] EMRTEXT aemrtext[];
		} EMRPOLYTEXTOUTA;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #iGraphicsMode
			type: DWORDField new
			offset: 24;
		defineField: #exScale
			type: FLOATField new
			offset: 28;
		defineField: #eyScale
			type: FLOATField new
			offset: 32;
		defineField: #cStrings
			type: SDWORDField new
			offset: 36;
		defineField: #aemrtext
			type: (StructureArrayField type: EMRTEXT lengthField: #cStrings)
			offset: 40!

getFieldNames
	^#(#iType #nSize #rclBounds #iGraphicsMode #exScale #eyScale #cStrings #aemrtext)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYTEXTOUTA with: EMR_POLYTEXTOUTW! !

!EMRPOLYTEXTOUTA class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

