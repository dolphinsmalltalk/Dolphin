"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.AdjustableArrowCapInitializer'
	instanceVariableNames: 'height width isFilled'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AdjustableArrowCapInitializer guid: (Core.GUID fromString: '{c1fcc801-8763-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.AdjustableArrowCapInitializer comment: ''!
!Graphics.Gdiplus.AdjustableArrowCapInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateAdjustableArrowCap: height
		width: width
		isFilled: isFilled asParameter
		cap: gpHandle.
	^gpHandle!

height: heightReal width: widthReal isFilled: isFilledBoolean
	height := heightReal.
	width := widthReal.
	isFilled := isFilledBoolean! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
height:width:isFilled:!initializing!private! !
!

!Graphics.Gdiplus.AdjustableArrowCapInitializer class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self new 
		height: heightReal
		width: widthReal
		isFilled: isFilledBoolean! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer class categoriesForMethods!
height:width:isFilled:!instance creation!public! !
!

