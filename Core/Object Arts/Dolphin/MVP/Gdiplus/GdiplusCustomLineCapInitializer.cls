"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusCustomLineCapInitializer
	instanceVariableNames: 'fillPath strokePath baseCap baseInset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusCustomLineCapInitializer guid: (GUID fromString: '{EA986B36-8426-11D7-B609-00E0987E8081}')!
GdiplusCustomLineCapInitializer comment: ''!
!GdiplusCustomLineCapInitializer categoriesForClass!Unclassified! !
!GdiplusCustomLineCapInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library 
				gdipCreateCustomLineCap: fillPath asParameter
				strokePath: strokePath asParameter
				baseCap: baseCap
				baseInset: baseInset
				customCap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

fillPath: aFillPath strokePath: aStrokePath baseCap: aLineCapConstant baseInset: aRealBaseInset 
	fillPath := aFillPath.
	strokePath := aStrokePath.
	baseCap := aLineCapConstant.
	baseInset := aRealBaseInset!

gdiplusConstructorErrorDescription
	^'Error creating CustomLineCap'! !
!GdiplusCustomLineCapInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusCustomLineCapInitializer categoriesFor: #fillPath:strokePath:baseCap:baseInset:!accessing!public! !
!GdiplusCustomLineCapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusCustomLineCapInitializer class methodsFor!

fillPath: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset 
	^self new 
		fillPath: fillPath
		strokePath: strokePath
		baseCap: baseCap
		baseInset: baseInset! !
!GdiplusCustomLineCapInitializer class categoriesFor: #fillPath:strokePath:baseCap:baseInset:!instance creation!public! !

