"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusAdjustableArrowCapInitializer
	instanceVariableNames: 'height width isFilled'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusAdjustableArrowCapInitializer guid: (GUID fromString: '{c1fcc801-8763-11d7-b609-00e0987e8081}')!

GdiplusAdjustableArrowCapInitializer comment: ''!

!GdiplusAdjustableArrowCapInitializer categoriesForClass!Unclassified! !

!GdiplusAdjustableArrowCapInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
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

!GdiplusAdjustableArrowCapInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
height:width:isFilled:!initializing!private! !
!

!GdiplusAdjustableArrowCapInitializer class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self new 
		height: heightReal
		width: widthReal
		isFilled: isFilledBoolean! !

!GdiplusAdjustableArrowCapInitializer class categoriesForMethods!
height:width:isFilled:!instance creation!public! !
!

