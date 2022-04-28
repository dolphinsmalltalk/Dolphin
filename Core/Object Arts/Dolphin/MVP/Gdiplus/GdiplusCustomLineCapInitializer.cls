﻿"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusCustomLineCapInitializer
	instanceVariableNames: 'fillPath strokePath baseCap baseInset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusCustomLineCapInitializer guid: (GUID fromString: '{ea986b36-8426-11d7-b609-00e0987e8081}')!
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
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

fillPath: aFillPath strokePath: aStrokePath baseCap: aLineCapConstant baseInset: aRealBaseInset 
	fillPath := aFillPath.
	strokePath := aStrokePath.
	baseCap := aLineCapConstant.
	baseInset := aRealBaseInset!

gdiplusConstructorErrorDescription
	^'Error creating CustomLineCap'! !
!GdiplusCustomLineCapInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
fillPath:strokePath:baseCap:baseInset:!initializing!private! !
gdiplusConstructorErrorDescription!constants!private! !
!

!GdiplusCustomLineCapInitializer class methodsFor!

fillPath: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset 
	^self new 
		fillPath: fillPath
		strokePath: strokePath
		baseCap: baseCap
		baseInset: baseInset! !
!GdiplusCustomLineCapInitializer class categoriesForMethods!
fillPath:strokePath:baseCap:baseInset:!instance creation!public! !
!
