"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.PathInitializer'
	instanceVariableNames: 'fillMode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathInitializer guid: (Core.GUID fromString: '{1a1a5ea1-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathInitializer comment: ''!
!Graphics.Gdiplus.PathInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PathInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreatePath: fillMode path: gpHandle.
	^gpHandle!

fillMode: aNumber
	fillMode := aNumber!

isPersistent
	^false! !
!Graphics.Gdiplus.PathInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.PathInitializer categoriesFor: #fillMode:!initializing!private! !
!Graphics.Gdiplus.PathInitializer categoriesFor: #isPersistent!public!testing! !

!Graphics.Gdiplus.PathInitializer class methodsFor!

fillMode: aNumber
	^self new fillMode: aNumber! !
!Graphics.Gdiplus.PathInitializer class categoriesFor: #fillMode:!instance creation!public! !

