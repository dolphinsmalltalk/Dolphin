"Filed out from Dolphin Smalltalk"!

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
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Region'!

rectangle: aRectangle
	rectangle := aRectangle! !

!GdiplusRegionFromRectangleInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
rectangle:!initializing!private! !
!

!GdiplusRegionFromRectangleInitializer class methodsFor!

fromRectangle: aRectangle
	^self new rectangle: aRectangle! !

!GdiplusRegionFromRectangleInitializer class categoriesForMethods!
fromRectangle:!instance creation!public! !
!

