"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LOGBRUSH
	instanceVariableNames: 'hatch'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGBRUSH guid: (GUID fromString: '{87b4c5f8-026e-11d3-9fd7-00a0cc3e4a32}')!
LOGBRUSH comment: '<LOGBRUSH> is an <ExternalStructure> class to wrap the struct ''Win.LOGBRUSH'' from type information in the ''Windows API (ANSI)'' library.

From MSDN: "The LOGBRUSH structure defines the style, color, and pattern of a physical brush. It is used by the CreateBrushIndirect and ExtCreatePen functions."

Instance Variables:
	hatch		<integer> hatch code from the HS_XXX enumeration, or <Bitmap> (for a bitmap brush, preventing the premature GC of that Bitmap).

'!
!LOGBRUSH categoriesForClass!Win32-Structs! !
!LOGBRUSH methodsFor!

color
	"Answer the colour member of the receiver as a Colour"

	^Color fromInteger: self lbColor!

color: aColor
	"Sets the colour member of the receiver from  the <Color> argument."

	self lbColor: aColor asParameter!

hatch
	"Answer the hatch object. This is either a <Bitmap>, or one of a set of standard integer constants."

	^hatch 
		ifNil: 
			[self lbStyle = BS_PATTERN ifTrue: [hatch := Bitmap fromHandle: self lbHatch] ifFalse: [self lbHatch]]!

hatch: aBitmapOrInteger 
	hatch := aBitmapOrInteger.
	self lbHatch: aBitmapOrInteger asParameter!

lbColor
	"Answer the receiver's lbColor field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lbColor)!

lbColor: anObject 
	"Set the receiver's lbColor field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lbColor) put: anObject!

lbHatch
	"Answer the receiver's lbHatch field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lbHatch)!

lbHatch: anObject 
	"Set the receiver's lbHatch field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lbHatch) put: anObject!

lbStyle
	"Answer the receiver's lbStyle field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

lbStyle: anObject 
	"Set the receiver's lbStyle field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

printFieldsOn: aStream limit: anInteger 
	aStream
		display: 'style=';
		print: self style;
		space;
		display: 'color=';
		print: self color;
		space;
		display: 'hatch=';
		print: self hatch!

style
	^self lbStyle!

style: anInteger 
	self lbStyle: anInteger! !
!LOGBRUSH categoriesFor: #color!accessing!public! !
!LOGBRUSH categoriesFor: #color:!accessing!public! !
!LOGBRUSH categoriesFor: #hatch!accessing!public! !
!LOGBRUSH categoriesFor: #hatch:!accessing!public! !
!LOGBRUSH categoriesFor: #lbColor!**compiled accessors**!public! !
!LOGBRUSH categoriesFor: #lbColor:!**compiled accessors**!public! !
!LOGBRUSH categoriesFor: #lbHatch!**compiled accessors**!public! !
!LOGBRUSH categoriesFor: #lbHatch:!**compiled accessors**!public! !
!LOGBRUSH categoriesFor: #lbStyle!**compiled accessors**!public! !
!LOGBRUSH categoriesFor: #lbStyle:!**compiled accessors**!public! !
!LOGBRUSH categoriesFor: #printFieldsOn:limit:!printing!private! !
!LOGBRUSH categoriesFor: #style!accessing!public! !
!LOGBRUSH categoriesFor: #style:!accessing!public! !

!LOGBRUSH class methodsFor!

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
		defineField: #lbStyle type: DWORDField new;
		defineField: #lbColor type: DWORDField new;
		defineField: #lbHatch type: UINT_PTRField new!

stbConvertFrom: anSTBClassFormat 
	"Version 1 adds hatch instance variables to hold Bitmap preventing it being GC'd (#1052)."

	^
	[:data | 
	| newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		newInstance]!

stbVersion
	^1! !
!LOGBRUSH class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!LOGBRUSH class categoriesFor: #stbConvertFrom:!binary filing!public! !
!LOGBRUSH class categoriesFor: #stbVersion!binary filing!public! !

