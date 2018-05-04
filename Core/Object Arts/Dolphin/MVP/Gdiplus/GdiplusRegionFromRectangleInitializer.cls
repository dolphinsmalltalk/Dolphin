"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusRegionFromRectangleInitializer
	instanceVariableNames: 'rectangle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusRegionFromRectangleInitializer guid: (GUID fromString: '{4b87dc0a-0ca6-4f47-93af-ea525ced5f99}')!
GdiplusRegionFromRectangleInitializer comment: ''!
!GdiplusRegionFromRectangleInitializer categoriesForClass!Unclassified! !
!GdiplusRegionFromRectangleInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateRegionRectI: rectangle asParameter region: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Region'!

rectangle: aRectangle
	rectangle := aRectangle! !
!GdiplusRegionFromRectangleInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusRegionFromRectangleInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusRegionFromRectangleInitializer categoriesFor: #rectangle:!accessing!public! !

!GdiplusRegionFromRectangleInitializer class methodsFor!

fromRectangle: aRectangle
	^self new rectangle: aRectangle! !
!GdiplusRegionFromRectangleInitializer class categoriesFor: #fromRectangle:!instance creation!public! !

