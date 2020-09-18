"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.PathGradientFromPathInitializer'
	instanceVariableNames: 'path'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientFromPathInitializer guid: (Core.GUID fromString: '{8f2007e2-7d6c-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathGradientFromPathInitializer comment: ''!
!Graphics.Gdiplus.PathGradientFromPathInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PathGradientFromPathInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreatePathGradientFromPath: path asParameter polyGradient: gpHandle.
	^gpHandle!

isPersistent
	^path isPersistent!

path: aGdiplusPath
	path := aGdiplusPath! !
!Graphics.Gdiplus.PathGradientFromPathInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.PathGradientFromPathInitializer categoriesFor: #isPersistent!public! !
!Graphics.Gdiplus.PathGradientFromPathInitializer categoriesFor: #path:!initializing!private! !

!Graphics.Gdiplus.PathGradientFromPathInitializer class methodsFor!

path: aGdiplusPath
	^self new path: aGdiplusPath! !
!Graphics.Gdiplus.PathGradientFromPathInitializer class categoriesFor: #path:!instance creation!public! !

