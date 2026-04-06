"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.LOGBRUSH'
	instanceVariableNames: 'hatch'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_LOGBRUSH_Size' -> 16rC.
			'_OffsetOf_lbColor' -> 16r4.
			'_OffsetOf_lbHatch' -> 16r8.
			'_OffsetOf_lbStyle' -> 16r0.
			'BS_DIBPATTERN' -> 16r5.
			'BS_DIBPATTERN8X8' -> 16r8.
			'BS_DIBPATTERNPT' -> 16r6.
			'BS_HATCHED' -> 16r2.
			'BS_HOLLOW' -> 16r1.
			'BS_INDEXED' -> 16r4.
			'BS_NULL' -> 16r1.
			'BS_PATTERN' -> 16r3.
			'BS_PATTERN8X8' -> 16r7.
			'BS_SOLID' -> 16r0.
			'HS_BDIAGONAL' -> 16r3.
			'HS_CROSS' -> 16r4.
			'HS_DIAGCROSS' -> 16r5.
			'HS_FDIAGONAL' -> 16r2.
			'HS_HORIZONTAL' -> 16r0.
			'HS_VERTICAL' -> 16r1
		}!

OS.LOGBRUSH guid: (Core.GUID fromString: '{87b4c5f8-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.LOGBRUSH comment: '<LOGBRUSH> is an <ExternalStructure> class to wrap the struct ''Win.LOGBRUSH'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The LOGBRUSH structure defines the style, color, and pattern of a physical brush. It is used by the CreateBrushIndirect and ExtCreatePen functions."

Instance Variables:
	hatch		<integer> hatch code from the HS_XXX enumeration, or <Bitmap> (for a bitmap brush, preventing the premature GC of that Bitmap).

'!

!OS.LOGBRUSH categoriesForClass!Win32-Structs! !

!OS.LOGBRUSH methodsFor!

color
	"Answer the colour member of the receiver as a Colour"

	^self lbColor!

hatch
	"Answer the hatch object. This is either a <Bitmap>, or one of a set of standard <integer> constants."

	^hatch
		ifNil: 
			[self lbStyle = BS_PATTERN ifTrue: [hatch := Graphics.Bitmap fromHandle: self lbHatch] ifFalse: [self lbHatch]]!

hatch: aBitmapOrInteger 
	hatch := aBitmapOrInteger.
	self lbHatch: aBitmapOrInteger asParameter!

hatchStyleName
	"Answer the symbolic hatch style name, or if not a hatched brush"

	^self lbStyle == BS_HATCHED
		ifTrue: [#(#horizontal #vertical #reverseDiagonal #diagonal #cross #diamond) lookup: self lbHatch + 1]!

lbColor
	"Answer the <Graphics.Color> value of the receiver's 'lbColor' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_lbColor)!

lbColor: aColor
	"Set the receiver's 'lbColor' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_lbColor put: aColor asCOLORREF!

lbHatch
	"Answer the <Integer> value of the receiver's 'lbHatch' field."

	^bytes uintPtrAtOffset: _OffsetOf_lbHatch!

lbHatch: anInteger
	"Set the receiver's 'lbHatch' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_lbHatch put: anInteger!

lbStyle
	"Answer the <Integer> value of the receiver's 'lbStyle' field."

	^bytes uint32AtOffset: _OffsetOf_lbStyle!

lbStyle: anInteger
	"Set the receiver's 'lbStyle' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lbStyle put: anInteger!

style: styleFlags color: aColour hatch: hatchObject
	hatch := hatchObject.
	bytes
		uint32AtOffset: _OffsetOf_lbStyle put: styleFlags;
		uint32AtOffset: _OffsetOf_lbColor put: aColour asCOLORREF;
		uintPtrAtOffset: _OffsetOf_lbHatch put: hatchObject asParameter! !

!OS.LOGBRUSH categoriesForMethods!
color!accessing!public! !
hatch!accessing!public! !
hatch:!accessing!public! !
hatchStyleName!accessing!public! !
lbColor!**compiled accessors**!public! !
lbColor:!**compiled accessors**!public! !
lbHatch!**compiled accessors**!public! !
lbHatch:!**compiled accessors**!public! !
lbStyle!**compiled accessors**!public! !
lbStyle:!**compiled accessors**!public! !
style:color:hatch:!initializing!private! !
!

!OS.LOGBRUSH class methodsFor!

byteSize
	^_LOGBRUSH_Size!

defineFields
	"Define the fields of the LOGBRUSH structure.

	LOGBRUSH  compileDefinition

		typedef [uuid(87B4C5F8-026E-11D3-9FD7-00A0CC3E4A32), helpstring('The LOGBRUSH structure defines the style, color, and pattern of a physical brush. It is used by the CreateBrushIndirect and ExtCreatePen functions.')]
		struct tagLOGBRUSH {
			unsigned int lbStyle;
			COLORREF lbColor;
			ULONG_PTR lbHatch;
		} LOGBRUSH;
"

	self
		defineField: #lbStyle type: UInt32Field new;
		defineField: #lbColor type: COLORREFField new;
		defineField: #lbHatch type: UIntPtrField new!

getFieldNames
	^#(#lbStyle #lbColor #lbHatch)!

stbConvertFromVersion0: anArray
	"Private - Convert from version 0 Structure.

	Version 1 adds hatch instance variables to hold Bitmap preventing it being GC'd (#1052).

	Version 0: bytes
	Version 1: bytes hatch
	Version 2: bytes hatch owner"


	^LOGBRUSH basicNew
		bytes: (anArray at: 1);
		yourself!

stbConvertFromVersion1: anArray
	"Private - Convert from version 1 Structure.

	Version 1: bytes hatch
	Version 2: bytes owner hatch"

	^{ anArray at: 1. nil. anArray at: 2 } becomeA: LOGBRUSH!

stbVersion
	"Version 1: Adds hatch instance variables to hold Bitmap preventing it being GC'd (#1052).
	Version 2: 'owner' added to Structure base class"

	^2!

style: styleFlags color: aColour hatch: hatchObject
	^self newBuffer
		style: styleFlags
		color: aColour
		hatch: hatchObject!

withStyle: styleFlags color: aColour hatch: hatchObject
	^self newBuffer
		style: styleFlags
		color: aColour
		hatch: hatchObject! !

!OS.LOGBRUSH class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
stbConvertFromVersion0:!binary filing!public! !
stbConvertFromVersion1:!binary filing!public! !
stbVersion!binary filing!public! !
style:color:hatch:!instance creation!public! !
withStyle:color:hatch:!instance creation!public! !
!

