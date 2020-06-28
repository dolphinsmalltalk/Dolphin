"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusGraphicsPathInitializer
	instanceVariableNames: 'fillMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!GdiplusGraphicsPathInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusGraphicsPathInitializer categoriesFor: #fillMode:!initializing!private! !
!GdiplusGraphicsPathInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusGraphicsPathInitializer categoriesFor: #isPersistent!public!testing! !

!GdiplusGraphicsPathInitializer class methodsFor!

fillMode: aNumber
	^self new fillMode: aNumber! !
!GdiplusGraphicsPathInitializer class categoriesFor: #fillMode:!instance creation!public! !

