"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusRegionFromPathInitializer
	instanceVariableNames: 'path'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusRegionFromPathInitializer guid: (GUID fromString: '{2e7c1bb2-37d2-4d8b-9135-3eb9ab2ed1bb}')!
GdiplusRegionFromPathInitializer comment: ''!
!GdiplusRegionFromPathInitializer categoriesForClass!Unclassified! !
!GdiplusRegionFromPathInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateRegionPath: path asParameter region: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Region'!

isPersistent
	^path isPersistent!

path: aPath
	path := aPath! !
!GdiplusRegionFromPathInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusRegionFromPathInitializer categoriesFor: #gdiplusConstructorErrorDescription!initializing!private! !
!GdiplusRegionFromPathInitializer categoriesFor: #isPersistent!public! !
!GdiplusRegionFromPathInitializer categoriesFor: #path:!initializing!private! !

!GdiplusRegionFromPathInitializer class methodsFor!

fromPath: aPath
	^self new path: aPath! !
!GdiplusRegionFromPathInitializer class categoriesFor: #fromPath:!instance creation!public! !

