"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #PALETTEENTRY
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_peBlue _OffsetOf_peFlags _OffsetOf_peGreen _OffsetOf_peRed'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PALETTEENTRY guid: (GUID fromString: '{87b4c606-026e-11d3-9fd7-00a0cc3e4a32}')!
PALETTEENTRY addClassConstant: '_OffsetOf_peBlue' value: 16r2!
PALETTEENTRY addClassConstant: '_OffsetOf_peFlags' value: 16r3!
PALETTEENTRY addClassConstant: '_OffsetOf_peGreen' value: 16r1!
PALETTEENTRY addClassConstant: '_OffsetOf_peRed' value: 16r0!
PALETTEENTRY comment: '<PALETTEENTRY> is an <ExternalStructure> class to wrap the struct ''Win32.PALETTEENTRY'' from type information in the ''Win32 API'' library.

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
!PALETTEENTRY categoriesForClass!Win32-Structs! !
!PALETTEENTRY methodsFor!

asColor
	"Answer a new Colour based on the receiver's data"

	^Color fromRgbCode: self rgbCode!

peBlue
	"Answer the <Integer> value of the receiver's 'peBlue' field."

	^bytes byteAtOffset: _OffsetOf_peBlue!

peBlue: anInteger
	"Set the receiver's 'peBlue' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_peBlue put: anInteger!

peFlags
	"Answer the <Integer> value of the receiver's 'peFlags' field."

	^bytes byteAtOffset: _OffsetOf_peFlags!

peFlags: anInteger
	"Set the receiver's 'peFlags' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_peFlags put: anInteger!

peGreen
	"Answer the <Integer> value of the receiver's 'peGreen' field."

	^bytes byteAtOffset: _OffsetOf_peGreen!

peGreen: anInteger
	"Set the receiver's 'peGreen' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_peGreen put: anInteger!

peRed
	"Answer the <Integer> value of the receiver's 'peRed' field."

	^bytes byteAtOffset: _OffsetOf_peRed!

peRed: anInteger
	"Set the receiver's 'peRed' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_peRed put: anInteger!

rgbCode
	^(bytes dwordAtOffset: 0) bitAnd: 16rFFFFFF! !
!PALETTEENTRY categoriesForMethods!
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

!PALETTEENTRY class methodsFor!

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
		defineField: #peRed type: BYTEField new offset: 0;
		defineField: #peGreen type: BYTEField new offset: 1;
		defineField: #peBlue type: BYTEField new offset: 2;
		defineField: #peFlags type: BYTEField new offset: 3.
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
!PALETTEENTRY class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
threeThreeTwo!instance creation!public! !
!

