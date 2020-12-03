"Filed out from Dolphin Smalltalk 7"!

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
	| gpHandle status |
	gpHandle := Handle new.
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
!Graphics.Gdiplus.AdjustableArrowCapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer categoriesFor: #height:width:isFilled:!initializing!private! !

!Graphics.Gdiplus.AdjustableArrowCapInitializer class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self new 
		height: heightReal
		width: widthReal
		isFilled: isFilledBoolean! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer class categoriesFor: #height:width:isFilled:!instance creation!public! !

