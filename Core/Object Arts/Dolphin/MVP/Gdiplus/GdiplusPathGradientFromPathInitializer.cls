"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusPathGradientFromPathInitializer
	instanceVariableNames: 'path'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPathGradientFromPathInitializer guid: (GUID fromString: '{8f2007e2-7d6c-11d7-b609-00e0987e8081}')!
GdiplusPathGradientFromPathInitializer comment: ''!
!GdiplusPathGradientFromPathInitializer categoriesForClass!Unclassified! !
!GdiplusPathGradientFromPathInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreatePathGradientFromPath: path asParameter polyGradient: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating PathGradient'!

isPersistent
	^path initializer isPersistent!

path: aGdiplusPath
	path := aGdiplusPath! !
!GdiplusPathGradientFromPathInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusPathGradientFromPathInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusPathGradientFromPathInitializer categoriesFor: #isPersistent!public! !
!GdiplusPathGradientFromPathInitializer categoriesFor: #path:!public! !

!GdiplusPathGradientFromPathInitializer class methodsFor!

path: aGdiplusPath
	^self new path: aGdiplusPath! !
!GdiplusPathGradientFromPathInitializer class categoriesFor: #path:!instance creation!public! !

