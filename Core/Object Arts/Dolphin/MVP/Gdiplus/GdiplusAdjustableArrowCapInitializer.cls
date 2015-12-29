"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusAdjustableArrowCapInitializer
	instanceVariableNames: 'height width isFilled'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusAdjustableArrowCapInitializer guid: (GUID fromString: '{C1FCC801-8763-11D7-B609-00E0987E8081}')!
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
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating AdjustableArrowCap'!

height: heightReal width: widthReal isFilled: isFilledBoolean
	height := heightReal.
	width := widthReal.
	isFilled := isFilledBoolean! !
!GdiplusAdjustableArrowCapInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusAdjustableArrowCapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusAdjustableArrowCapInitializer categoriesFor: #height:width:isFilled:!accessing!public! !

!GdiplusAdjustableArrowCapInitializer class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self new 
		height: heightReal
		width: widthReal
		isFilled: isFilledBoolean! !
!GdiplusAdjustableArrowCapInitializer class categoriesFor: #height:width:isFilled:!instance creation!public! !

