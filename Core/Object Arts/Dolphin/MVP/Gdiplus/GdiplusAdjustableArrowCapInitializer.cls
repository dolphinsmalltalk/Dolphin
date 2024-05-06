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
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateAdjustableArrowCap: height
				width: width
				isFilled: isFilled asParameter
				cap: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating AdjustableArrowCap'!

height: heightReal width: widthReal isFilled: isFilledBoolean
	height := heightReal.
	width := widthReal.
	isFilled := isFilledBoolean! !

!GdiplusAdjustableArrowCapInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
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

