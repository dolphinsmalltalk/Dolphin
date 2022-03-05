"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusGraphicsPathInitializer
	instanceVariableNames: 'fillMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsPathInitializer guid: (GUID fromString: '{1a1a5ea1-6151-11d7-b609-00e0987e8081}')!
GdiplusGraphicsPathInitializer comment: ''!
!GdiplusGraphicsPathInitializer categoriesForClass!Unclassified! !
!GdiplusGraphicsPathInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreatePath: fillMode path: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

fillMode: aNumber
	fillMode := aNumber!

gdiplusConstructorErrorDescription
	^'Error creating GraphicsPath'!

isPersistent
	^false! !
!GdiplusGraphicsPathInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
fillMode:!initializing!private! !
gdiplusConstructorErrorDescription!constants!private! !
isPersistent!public!testing! !
!

!GdiplusGraphicsPathInitializer class methodsFor!

fillMode: aNumber
	^self new fillMode: aNumber! !
!GdiplusGraphicsPathInitializer class categoriesForMethods!
fillMode:!instance creation!public! !
!

