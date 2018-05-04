"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusRegionFromPathInitializer
	instanceVariableNames: 'path'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusRegionFromPathInitializer guid: (GUID fromString: '{2e7c1bb2-37d2-4d8b-9135-3eb9ab2ed1bb}')!
GdiplusRegionFromPathInitializer comment: ''!
!GdiplusRegionFromPathInitializer categoriesForClass!Unclassified! !
!GdiplusRegionFromPathInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateRegionPath: path asParameter region: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Region'!

path: aPath
	path := aPath! !
!GdiplusRegionFromPathInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusRegionFromPathInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusRegionFromPathInitializer categoriesFor: #path:!accessing!public! !

!GdiplusRegionFromPathInitializer class methodsFor!

fromPath: aPath
	^self new path: aPath! !
!GdiplusRegionFromPathInitializer class categoriesFor: #fromPath:!instance creation!public! !

