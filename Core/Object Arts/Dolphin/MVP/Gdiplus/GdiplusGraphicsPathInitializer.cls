"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusGraphicsPathInitializer
	instanceVariableNames: 'fillMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsPathInitializer guid: (GUID fromString: '{1A1A5EA1-6151-11D7-B609-00E0987E8081}')!
GdiplusGraphicsPathInitializer comment: ''!
!GdiplusGraphicsPathInitializer categoriesForClass!Unclassified! !
!GdiplusGraphicsPathInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreatePath: fillMode path: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

fillMode: aNumber
	fillMode := aNumber!

gdiplusConstructorErrorDescription
	^'Error creating GraphicsPath'!

isPersistent
	^false! !
!GdiplusGraphicsPathInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusGraphicsPathInitializer categoriesFor: #fillMode:!accessing!public! !
!GdiplusGraphicsPathInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusGraphicsPathInitializer categoriesFor: #isPersistent!public!testing! !

!GdiplusGraphicsPathInitializer class methodsFor!

fillMode: aNumber
	^self new fillMode: aNumber! !
!GdiplusGraphicsPathInitializer class categoriesFor: #fillMode:!instance creation!public! !

