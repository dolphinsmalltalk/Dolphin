"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GraphicsInitializer
	subclass: #'Graphics.Gdiplus.GraphicsFromHWNDInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsFromHWNDInitializer guid: (Core.GUID fromString: '{d71eb72c-5b27-43b5-9041-39bd41ee9c3e}')!
Graphics.Gdiplus.GraphicsFromHWNDInitializer comment: ''!
!Graphics.Gdiplus.GraphicsFromHWNDInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateFromHWND: surface asParameter graphics: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.GraphicsFromHWNDInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

