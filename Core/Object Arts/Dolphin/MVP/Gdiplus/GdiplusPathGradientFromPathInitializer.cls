"Filed out from Dolphin Smalltalk"!

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
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating PathGradient'!

isPersistent
	^path isPersistent!

path: aGdiplusPath
	path := aGdiplusPath! !

!GdiplusPathGradientFromPathInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
isPersistent!public! !
path:!initializing!private! !
!

!GdiplusPathGradientFromPathInitializer class methodsFor!

path: aGdiplusPath
	^self new path: aGdiplusPath! !

!GdiplusPathGradientFromPathInitializer class categoriesForMethods!
path:!instance creation!public! !
!

