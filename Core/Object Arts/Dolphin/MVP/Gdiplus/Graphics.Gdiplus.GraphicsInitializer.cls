"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.GraphicsInitializer'
	instanceVariableNames: 'surface'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsInitializer guid: (Core.GUID fromString: '{6e6bbcda-3692-4de6-b203-2b607e175485}')!
Graphics.Gdiplus.GraphicsInitializer isNonInstantiable: true!
Graphics.Gdiplus.GraphicsInitializer comment: ''!
!Graphics.Gdiplus.GraphicsInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [self species == anObject species and: [surface = anObject surface]]!

hash
	"Answer the <integer> hash value for the receiver."

	^(self species hash + surface hash) hashMultiply!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore."

	"We assumed that Gdiplus Graphics objects are used transiently and not stored."

	^false!

printAttributesOn: aLimitedWriteStream 
!

surface
	^surface!

surface: anObject
	surface := anObject! !
!Graphics.Gdiplus.GraphicsInitializer categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isPersistent!public!testing! !
printAttributesOn:!printing!private! !
surface!accessing!private! !
surface:!accessing!private! !
!

!Graphics.Gdiplus.GraphicsInitializer class methodsFor!

cloneHandle: aHandle
	"Cannot be cloned"

	^self shouldNotImplement!

freeHandle: aHandle
	Gdip gdipDeleteGraphics: aHandle!

on: aGraphicsSurface
	"Creates a Gdiplus Graphics object that is associated with a specified surface (HDC, HWND or Gdiplus Image)."

	^self new surface: aGraphicsSurface! !
!Graphics.Gdiplus.GraphicsInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
on:!instance creation!public! !
!

