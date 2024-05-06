"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusFromBytesInitializer
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFromBytesInitializer guid: (GUID fromString: '{3156f9e7-c46c-48e7-9cca-e6405bf8a085}')!

GdiplusFromBytesInitializer isAbstract: true!

GdiplusFromBytesInitializer comment: ''!

!GdiplusFromBytesInitializer categoriesForClass!Unclassified! !

!GdiplusFromBytesInitializer methodsFor!

= comperand 
	^self species = comperand species and: [self bytes = comperand bytes]!

bytes
	^bytes!

hash
	^self bytes hash!

iStream
	^IStream fromBytes: bytes!

setBytes: aByteArray 
	bytes := aByteArray! !

!GdiplusFromBytesInitializer categoriesForMethods!
=!comparing!public! !
bytes!accessing!public! !
hash!comparing!public! !
iStream!public!realizing/unrealizing! !
setBytes:!initializing!private! !
!

!GdiplusFromBytesInitializer class methodsFor!

bytes: aByteArray 
	^self new setBytes: aByteArray! !

!GdiplusFromBytesInitializer class categoriesForMethods!
bytes:!instance creation!public! !
!

