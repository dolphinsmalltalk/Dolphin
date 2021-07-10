"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.FromBytesInitializer'
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FromBytesInitializer guid: (Core.GUID fromString: '{3156f9e7-c46c-48e7-9cca-e6405bf8a085}')!
Graphics.Gdiplus.FromBytesInitializer isNonInstantiable: true!
Graphics.Gdiplus.FromBytesInitializer comment: ''!
!Graphics.Gdiplus.FromBytesInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FromBytesInitializer methodsFor!

= comperand 
	^self species = comperand species and: [self bytes = comperand bytes]!

bytes
	^bytes!

hash
	^self bytes hash!

iStream
	^COM.IStream fromBytes: bytes!

setBytes: aByteArray 
	bytes := aByteArray! !
!Graphics.Gdiplus.FromBytesInitializer categoriesForMethods!
=!comparing!public! !
bytes!accessing!public! !
hash!comparing!public! !
iStream!public!realizing/unrealizing! !
setBytes:!initializing!private! !
!

!Graphics.Gdiplus.FromBytesInitializer class methodsFor!

bytes: aByteArray 
	^self new setBytes: aByteArray! !
!Graphics.Gdiplus.FromBytesInitializer class categoriesForMethods!
bytes:!instance creation!public! !
!

