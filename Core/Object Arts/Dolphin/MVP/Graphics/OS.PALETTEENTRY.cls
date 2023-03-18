"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.PALETTEENTRY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_peBlue' -> 16r2.
		'_OffsetOf_peFlags' -> 16r3.
		'_OffsetOf_peGreen' -> 16r1.
		'_OffsetOf_peRed' -> 16r0.
		'_PALETTEENTRY_Size' -> 16r4
	}!
OS.PALETTEENTRY guid: (Core.GUID fromString: '{87b4c606-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.PALETTEENTRY comment: '<PALETTEENTRY> is an <ExternalStructure> class to wrap the struct ''Win32.PALETTEENTRY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The PALETTEENTRY structure specifies the color and usage of an entry in a logical palette."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(87b4c606-026e-11d3-9fd7-00a0cc3e4a32), helpstring("The PALETTEENTRY structure specifies the color and usage of an entry in a logical palette.")]
struct tagPALETTEENTRY {
	[helpstring("The red intensity value for the palette entry.")] BYTE peRed;
	[helpstring("The green intensity value for the palette entry.")] BYTE peGreen;
	[helpstring("The blue intensity value for the palette entry.")] BYTE peBlue;
	[helpstring("Flags from the PC_ enumeration indicating how the palette entry should be used.")] BYTE peFlags;
} PALETTEENTRY;
'!
!OS.PALETTEENTRY categoriesForClass!Win32-Structs! !
!OS.PALETTEENTRY methodsFor!

asColor
	"Answer a new Colour based on the receiver's data"

	^Graphics.Color fromRgbCode: self rgbCode!

peBlue
	"Answer the <Integer> value of the receiver's 'peBlue' field."

	^bytes uint8AtOffset: _OffsetOf_peBlue!

peBlue: anInteger
	"Set the receiver's 'peBlue' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_peBlue put: anInteger!

peFlags
	"Answer the <Integer> value of the receiver's 'peFlags' field."

	^bytes uint8AtOffset: _OffsetOf_peFlags!

peFlags: anInteger
	"Set the receiver's 'peFlags' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_peFlags put: anInteger!

peGreen
	"Answer the <Integer> value of the receiver's 'peGreen' field."

	^bytes uint8AtOffset: _OffsetOf_peGreen!

peGreen: anInteger
	"Set the receiver's 'peGreen' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_peGreen put: anInteger!

peRed
	"Answer the <Integer> value of the receiver's 'peRed' field."

	^bytes uint8AtOffset: _OffsetOf_peRed!

peRed: anInteger
	"Set the receiver's 'peRed' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_peRed put: anInteger!

rgbCode
	^(bytes uint32AtOffset: 0) bitAnd: 16rFFFFFF! !
!OS.PALETTEENTRY categoriesForMethods!
asColor!converting!public! !
peBlue!**compiled accessors**!public! !
peBlue:!**compiled accessors**!public! !
peFlags!**compiled accessors**!public! !
peFlags:!**compiled accessors**!public! !
peGreen!**compiled accessors**!public! !
peGreen:!**compiled accessors**!public! !
peRed!**compiled accessors**!public! !
peRed:!**compiled accessors**!public! !
rgbCode!accessing!public! !
!

!OS.PALETTEENTRY class methodsFor!

byteSize
	^_PALETTEENTRY_Size!

defineFields
	"Define the fields of the PALETTEENTRY structure.

	PALETTEENTRY compileDefinition

		typedef [uuid(87b4c606-026e-11d3-9fd7-00a0cc3e4a32), helpstring('The PALETTEENTRY structure specifies the color and usage of an entry in a logical palette.')]
		struct tagPALETTEENTRY {
			[helpstring('The red intensity value for the palette entry.')] BYTE peRed;
			[helpstring('The green intensity value for the palette entry.')] BYTE peGreen;
			[helpstring('The blue intensity value for the palette entry.')] BYTE peBlue;
			[helpstring('Flags from the PC_ enumeration indicating how the palette entry should be used.')] BYTE peFlags;
		} PALETTEENTRY;
"

	self
		defineField: #peRed
			type: UInt8Field new
			offset: 0;
		defineField: #peGreen
			type: UInt8Field new
			offset: 1;
		defineField: #peBlue
			type: UInt8Field new
			offset: 2;
		defineField: #peFlags
			type: UInt8Field new
			offset: 3.
	self byteSize: 4!

getFieldNames
	^#(#peRed #peGreen #peBlue #peFlags)!

threeThreeTwo
	"Answer a packed array palette entries to specify a default 332 palette."

	| palette |
	palette := StructureArray
				length: 256
				elementClass: self
				initializer: 
					[:pe :index |
					| i |
					i := index - 1.
					pe peRed: ((i bitShift: -5) bitAnd: 2r111) * 255 // 7.
					pe peGreen: ((i bitShift: -2) bitAnd: 2r111) * 255 // 7.
					pe peBlue: (i bitAnd: 2r11) * 255 // 3].
	^palette! !
!OS.PALETTEENTRY class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
threeThreeTwo!instance creation!public! !
!

