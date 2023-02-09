"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.ImageInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageInitializer guid: (Core.GUID fromString: '{adb9b081-7b40-4598-bb46-75142fbcf20c}')!
Graphics.Gdiplus.ImageInitializer isNonInstantiable: true!
Graphics.Gdiplus.ImageInitializer comment: ''!
!Graphics.Gdiplus.ImageInitializer methodsFor!

absoluteFilename
	^nil!

printAttributesOn: aStream
	"Private"! !
!Graphics.Gdiplus.ImageInitializer categoriesForMethods!
absoluteFilename!enquiries!public! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.ImageInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneImage: aHandle cloneImage: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDisposeImage: aHandle! !
!Graphics.Gdiplus.ImageInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
!

