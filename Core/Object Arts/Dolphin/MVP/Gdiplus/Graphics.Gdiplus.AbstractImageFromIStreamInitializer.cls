"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.ImageInitializer
	subclass: #'Graphics.Gdiplus.AbstractImageFromIStreamInitializer'
	instanceVariableNames: 'iStream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.AbstractImageFromIStreamInitializer guid: (Core.GUID fromString: '{44709983-5631-4104-a8cb-0cfd854cf85a}')!

Graphics.Gdiplus.AbstractImageFromIStreamInitializer isNonInstantiable: true!

Graphics.Gdiplus.AbstractImageFromIStreamInitializer comment: ''!

!Graphics.Gdiplus.AbstractImageFromIStreamInitializer methodsFor!

= anObject
	^self == anObject or: [self species = anObject species and: [iStream = anObject iStream]]!

hash
	^(self species hash + iStream hash) hashMultiply!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore. "

	"The IStream will (probably) no longer be valid when restoring from a saved image or binary filed content."

	^false!

iStream
	^iStream!

iStream: pStream
	iStream := pStream.
	^self! !

!Graphics.Gdiplus.AbstractImageFromIStreamInitializer categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isPersistent!constants!public!realizing/unrealizing!testing! !
iStream!accessing!private! !
iStream:!initializing!private! !
!

!Graphics.Gdiplus.AbstractImageFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !

!Graphics.Gdiplus.AbstractImageFromIStreamInitializer class categoriesForMethods!
iStream:!instance creation!public! !
!

