"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.CustomLineCapInitializer'
	instanceVariableNames: 'fillPath strokePath baseCap baseInset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.CustomLineCapInitializer guid: (Core.GUID fromString: '{ea986b36-8426-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.CustomLineCapInitializer comment: ''!
!Graphics.Gdiplus.CustomLineCapInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.CustomLineCapInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateCustomLineCap: fillPath asParameter
		strokePath: strokePath asParameter
		baseCap: baseCap
		baseInset: baseInset
		customCap: gpHandle.
	^gpHandle!

fillPath: aFillPath strokePath: aStrokePath baseCap: aLineCapConstant baseInset: aRealBaseInset 
	fillPath := aFillPath.
	strokePath := aStrokePath.
	baseCap := aLineCapConstant.
	baseInset := aRealBaseInset! !
!Graphics.Gdiplus.CustomLineCapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.CustomLineCapInitializer categoriesFor: #fillPath:strokePath:baseCap:baseInset:!initializing!private! !

!Graphics.Gdiplus.CustomLineCapInitializer class methodsFor!

fillPath: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset 
	^self new 
		fillPath: fillPath
		strokePath: strokePath
		baseCap: baseCap
		baseInset: baseInset! !
!Graphics.Gdiplus.CustomLineCapInitializer class categoriesFor: #fillPath:strokePath:baseCap:baseInset:!instance creation!public! !

