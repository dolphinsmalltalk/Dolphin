"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractCustomLineCap
	subclass: #'Graphics.Gdiplus.CustomLineCap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.CustomLineCap guid: (Core.GUID fromString: '{ea986b35-8426-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.CustomLineCap comment: 'GdiplusCustomLineCap defines the style of graphic used to draw the ends of a line. It can be various shapes, such as a square, circle, or diamond and is defined by the path that draws it. The path is drawn by using a Pen object to draw the outline of a shape or by using a Brush object to fill the interior. The cap can be used on either or both ends of the line. Spacing can be adjusted between the end caps and the line.

'!
!Graphics.Gdiplus.CustomLineCap methodsFor!

baseCap
	"Answer a LineCap integer that represents the style of the base cap used at the end of a line."

	"This property can be set on AdjustableArrowCaps, but has no effect so to avoid frustration the accessors are pushed down."

	^initializer baseCap!

baseCap: anIntegerLineCapConstant
	"Set the style of the base cap used at the end of a line to that represented by <integer> argument, which is expected to be a member of the LineCap enumeration."

	initializer baseCapOf: self set: anIntegerLineCapConstant!

baseInset
	"Answer the distance between the base cap to the start of the line."

	"This property can be set on AdjustableArrowCaps, but has no effect so to avoid frustration the accessors are pushed down."

	^initializer baseInset!

baseInset: aNumber
	"Set the distance between the end of a line and the base cap."

	"This property can be set on GpAdjustableArrowCaps, but has no effect."

	initializer baseInsetOf: self set: aNumber!

clone
	"Answer a copy of the receiver."

	"We cannot query all the receiver's possible attributes from Gdiplus, in particular we cannot query the strokePath or fillPath. As we cannot get the handles of these sub-objects of the clone, the clone API isn't much use, so we just revert to our standard copy operation."

	^self copy!

endCap
	"Answer the style of the stroke cap used at the end of lines."

	"This property can be set on AdjustableArrowCaps, but has no effect so to avoid frustration the accessors are pushed down."

	^self strokeCaps at: 2!

endCap: aLineCapConstant
	"Set the style of the stroke cap used at the end of lines."

	self startCap: self startCap endCap: aLineCapConstant!

fillPath
	"Answer a <GraphicsPath> describing the fill-path of the custom line cap.
	Note that a CustomLineCap cannot have both a fillPath and a strokePath."

	^initializer fillPath!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^CustomLineCapInitializer!

startCap
	"Answer the style of the stroke cap used at the start of lines."

	"This property can be set on AdjustableArrowCaps, but has no effect so to avoid frustration the accessors are pushed down."

	^self strokeCaps at: 1!

startCap: aLineCapConstant
	"Set the style of the stroke cap used at the start of lines."

	self startCap: aLineCapConstant endCap: self endCap!

startCap: startLineCapConstant endCap: endLineCapConstant
	"Set the style of the stroke cap used at the start and ends of lines."

	"These properties can be set on GpAdjustableArrowCaps, but have no effect."

	initializer
		strokeCapsOf: self
		setStart: startLineCapConstant
		end: endLineCapConstant!

strokeCaps
	"Answer a 2-element <Array> of <integer> that contains the styles of the start and ending stroke caps, members of the LineCap enumeration."

	^initializer strokeCaps!

strokePath
	"Answer a <GraphicsPath> describing the outline path of the custom line cap.
	Note that a CustomLineCap cannot have both a fillPath and a strokePath."

	^initializer strokePath! !
!Graphics.Gdiplus.CustomLineCap categoriesForMethods!
baseCap!accessing!public! !
baseCap:!accessing!public! !
baseInset!accessing!public! !
baseInset:!accessing!public! !
clone!copying!public! !
endCap!accessing!public! !
endCap:!accessing!public! !
fillPath!accessing!public! !
initializerClass!private!realizing/unrealizing! !
startCap!accessing!public! !
startCap:!accessing!public! !
startCap:endCap:!accessing!public! !
strokeCaps!accessing!public! !
strokePath!accessing!public! !
!

!Graphics.Gdiplus.CustomLineCap class methodsFor!

fillPath: aGraphicsPath baseCap: aLineCapConstant baseInset: aNumber
	^self fromInitializer: (CustomLineCapInitializer
				fillPath: aGraphicsPath
				strokePath: nil
				baseCap: aLineCapConstant
				baseInset: aNumber)!

new
	^self strokePath: GraphicsPath new!

strokePath: aGraphicsPath
	^self
		strokePath: aGraphicsPath
		baseCap: LineCapFlat
		baseInset: 0!

strokePath: aGraphicsPath baseCap: anIntegerLineCapConstant baseInset: aFloat
	^self fromInitializer: (CustomLineCapInitializer
				fillPath: nil
				strokePath: aGraphicsPath
				baseCap: anIntegerLineCapConstant
				baseInset: aFloat)! !
!Graphics.Gdiplus.CustomLineCap class categoriesForMethods!
fillPath:baseCap:baseInset:!instance creation!public! !
new!instance creation!public! !
strokePath:!instance creation!public! !
strokePath:baseCap:baseInset:!instance creation!public! !
!

