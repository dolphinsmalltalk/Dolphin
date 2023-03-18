"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.BrushInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BrushInitializer guid: (Core.GUID fromString: '{2589b5c1-e874-4e59-bd01-6cd94b1da8f1}')!
Graphics.Gdiplus.BrushInitializer isNonInstantiable: true!
Graphics.Gdiplus.BrushInitializer comment: ''!
!Graphics.Gdiplus.BrushInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneBrush: aHandle cloneBrush: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDeleteBrush: aHandle! !
!Graphics.Gdiplus.BrushInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
!

