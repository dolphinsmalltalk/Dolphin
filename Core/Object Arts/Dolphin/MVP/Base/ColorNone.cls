"Filed out from Dolphin Smalltalk 7"!

ColorRef subclass: #ColorNone
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorNone guid: (GUID fromString: '{21257bc4-33c5-4684-b606-e387fcfbede6}')!
ColorNone comment: '`ColorNone` is the special ColorRef which represents a completely transparent colour. It is used to specify that something should be drawn transparently, or that the background should not be filled.

`ColorNone`s singleton instance is accessed using the expression `Color none`.

The superclass `code` instance variable has the value `Win32Constants.CLR_NONE`.'!
!ColorNone categoriesForClass!Unclassified! !
!ColorNone methodsFor!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255). This specifies
	the opacity of the colour, with 0 being completely transparent and 255 completely opaque."

	^0!

brush
	"Answer a Brush configured for solid painting of the receiver's color."

	^StockBrush fromId: NULL_BRUSH!

isNone
	"Answer whether the receiver is the special <Color> representing no colour."

	^true!

luminance
	^0!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream
		display: Color;
		space;
		display: #none! !
!ColorNone categoriesFor: #alpha!accessing!public! !
!ColorNone categoriesFor: #brush!converting!public! !
!ColorNone categoriesFor: #isNone!public!testing! !
!ColorNone categoriesFor: #luminance!public! !
!ColorNone categoriesFor: #printOn:!development!printing!public! !

!ColorNone class methodsFor!

initialize
	Color addClassConstant: 'None'
		value: (self basicNew
				setCode: CLR_NONE;
				isImmutable: true;
				yourself)! !
!ColorNone class categoriesFor: #initialize!public! !

