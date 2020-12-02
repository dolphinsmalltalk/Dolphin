"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusAdjustableArrowCapInitializer
	instanceVariableNames: 'height width isFilled'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!GdiplusAdjustableArrowCapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusAdjustableArrowCapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusAdjustableArrowCapInitializer categoriesFor: #height:width:isFilled:!initializing!private! !

!GdiplusAdjustableArrowCapInitializer class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self new 
		height: heightReal
		width: widthReal
		isFilled: isFilledBoolean! !
!GdiplusAdjustableArrowCapInitializer class categoriesFor: #height:width:isFilled:!instance creation!public! !

