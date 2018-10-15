"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRPOLYTEXTOUTA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRPOLYTEXTOUTA guid: (GUID fromString: '{7c11c025-67e0-44de-87ab-e4f1377a4314}')!
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
	"Answer the receiver's aemrtext field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #aemrtext)
		length: self cStrings
		elementClass: EMRTEXT!

aemrtext: anObject 
	"Set the receiver's aemrtext field to the value of anObject."

	| size |
	size := anObject byteSize min: self cStrings * ##(EMRTEXT basicByteSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #aemrtext) + 1)
		to: ##(self offsetOf: #aemrtext) + size
		startingAt: 1!

cStrings
	"Answer the receiver's cStrings field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cStrings)!

cStrings: anObject 
	"Set the receiver's cStrings field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cStrings) put: anObject!

exScale
	"Answer the receiver's exScale field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #exScale)!

exScale: anObject 
	"Set the receiver's exScale field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #exScale) put: anObject!

eyScale
	"Answer the receiver's eyScale field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eyScale)!

eyScale: anObject 
	"Set the receiver's eyScale field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eyScale) put: anObject!

iGraphicsMode
	"Answer the receiver's iGraphicsMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iGraphicsMode)!

iGraphicsMode: anObject 
	"Set the receiver's iGraphicsMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iGraphicsMode) put: anObject!

rclBounds
	"Answer the receiver's rclBounds field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rclBounds)!

rclBounds: anObject 
	"Set the receiver's rclBounds field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rclBounds) + 1)
		to: ##((self offsetOf: #rclBounds) + RECT basicByteSize)
		startingAt: 1! !
!EMRPOLYTEXTOUTA categoriesFor: #aemrtext!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #aemrtext:!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #cStrings!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #cStrings:!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #exScale!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #exScale:!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #eyScale!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #eyScale:!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #iGraphicsMode!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #iGraphicsMode:!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRPOLYTEXTOUTA categoriesFor: #rclBounds:!**compiled accessors**!public! !

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

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_POLYTEXTOUTA with: EMR_POLYTEXTOUTW! !
!EMRPOLYTEXTOUTA class categoriesFor: #defineFields!initializing!public! !
!EMRPOLYTEXTOUTA class categoriesFor: #iTypes!constants!public! !

