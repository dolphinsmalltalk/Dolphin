"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractCustomLineCap subclass: #'Graphics.Gdiplus.AdjustableArrowCap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AdjustableArrowCap guid: (Core.GUID fromString: '{c1fcc800-8763-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.AdjustableArrowCap comment: 'GdiplusAdjustableArrowCap creates a line cap that looks like an arrow.'!
!Graphics.Gdiplus.AdjustableArrowCap methodsFor!

height
	"Answer the height of the receiver's cap."

	^self initializer height!

height: aNumber
	"Set the height of the receiver's arrow cap."

	initializer heightOf: self set: aNumber!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^AdjustableArrowCapInitializer!

isFilled
	"Answer whether the receiver's cap is filled."

	^self initializer isFilled!

isFilled: aBoolean
	"Set whether the receiver's arrow cap should be filled."

	initializer fillStateOf: self set: aBoolean!

middleInset
	"Answer the middleInset of the receiver's cap."

	^initializer middleInset!

middleInset: aNumber
	"Set the middleInset of the receiver's arrow cap."

	initializer middleInsetOf: self set: aNumber!

width
	"Answer the width of the receiver's cap."

	^self initializer width!

width: aNumber
	"Set the width of the receiver's arrow cap."

	initializer widthOf: self set: aNumber! !
!Graphics.Gdiplus.AdjustableArrowCap categoriesForMethods!
height!accessing!public! !
height:!accessing!public! !
initializerClass!constants!private! !
isFilled!accessing!public! !
isFilled:!accessing!public! !
middleInset!accessing!public! !
middleInset:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!Graphics.Gdiplus.AdjustableArrowCap class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self fromInitializer: (AdjustableArrowCapInitializer
				height: heightReal
				width: widthReal
				isFilled: isFilledBoolean)!

new
	^self height: 10 width: 5 isFilled: false! !
!Graphics.Gdiplus.AdjustableArrowCap class categoriesForMethods!
height:width:isFilled:!instance creation!public! !
new!instance creation!public! !
!

