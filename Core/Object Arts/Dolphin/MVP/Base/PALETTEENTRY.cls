"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #PALETTEENTRY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PALETTEENTRY guid: (GUID fromString: '{87B4C606-026E-11D3-9FD7-00A0CC3E4A32}')!
PALETTEENTRY comment: '<PALETTEENTRY> is an <ExternalStructure> class to wrap the struct ''OCIDL.PALETTEENTRY'' from type information in the ''OCIDL Library'' library.

The type library contains no documentation for this struct

WARNING: This comment was automatically generated from the struct''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!PALETTEENTRY categoriesForClass!Win32-Structs! !
!PALETTEENTRY methodsFor!

asColor
	"Answer a new Colour based on the receiver's data"

	^Color
		red: self peRed
		green: self peGreen
		blue: self peBlue!

peBlue
	"Answer the receiver's peBlue field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #peBlue)!

peBlue: anObject 
	"Set the receiver's peBlue field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #peBlue) put: anObject!

peGreen
	"Answer the receiver's peGreen field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #peGreen)!

peGreen: anObject 
	"Set the receiver's peGreen field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #peGreen) put: anObject!

peRed
	"Answer the receiver's peRed field as a Smalltalk object."

	^bytes byteAtOffset: 0!

peRed: anObject 
	"Set the receiver's peRed field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject! !
!PALETTEENTRY categoriesFor: #asColor!converting!public! !
!PALETTEENTRY categoriesFor: #peBlue!**compiled accessors**!public! !
!PALETTEENTRY categoriesFor: #peBlue:!**compiled accessors**!public! !
!PALETTEENTRY categoriesFor: #peGreen!**compiled accessors**!public! !
!PALETTEENTRY categoriesFor: #peGreen:!**compiled accessors**!public! !
!PALETTEENTRY categoriesFor: #peRed!**compiled accessors**!public! !
!PALETTEENTRY categoriesFor: #peRed:!**compiled accessors**!public! !

!PALETTEENTRY class methodsFor!

defineFields
	"Define the fields of the PALETTEENTRY structure.
		PALETTEENTRY compileDefinition
	
		typedef 		struct tagPALETTEENTRY {
			BYTE peRed;
			BYTE peGreen;
			BYTE peBlue;
			BYTE peFlags;
		} PALETTEENTRY;

	"

	self
		defineField: #peRed type: BYTEField new;
		defineField: #peGreen type: BYTEField new;
		defineField: #peBlue type: BYTEField new;
		defineField: #peFlags type: BYTEField new beUncompiled!

threeThreeTwo
	"Answer a packed array palette entries to specify a default 332 palette."

	| palette |
	palette := StructureArray length: 256 elementClass: self.
	0 to: 255
		do: 
			[:i | 
			| pe |
			pe := palette at: i + 1.
			pe peRed: ((i bitShift: -5) bitAnd: 2r111) * 255 // 7.
			pe peGreen: ((i bitShift: -2) bitAnd: 2r111) * 255 // 7.
			pe peBlue: (i bitAnd: 2r11) * 255 // 3].
	^palette


	"
Time millisecondsToRun: [PALETTEENTRY threeThreeTwo]
"! !
!PALETTEENTRY class categoriesFor: #defineFields!initializing!public! !
!PALETTEENTRY class categoriesFor: #threeThreeTwo!instance creation!public! !

