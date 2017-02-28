"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusFromBytesInitializer
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusFromBytesInitializer guid: (GUID fromString: '{3156F9E7-C46C-48E7-9CCA-E6405BF8A085}')!
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
!GdiplusFromBytesInitializer categoriesFor: #=!comparing!public! !
!GdiplusFromBytesInitializer categoriesFor: #bytes!accessing!public! !
!GdiplusFromBytesInitializer categoriesFor: #hash!comparing!public! !
!GdiplusFromBytesInitializer categoriesFor: #iStream!public!realizing/unrealizing! !
!GdiplusFromBytesInitializer categoriesFor: #setBytes:!initializing!private! !

!GdiplusFromBytesInitializer class methodsFor!

bytes: aByteArray 
	^self new setBytes: aByteArray! !
!GdiplusFromBytesInitializer class categoriesFor: #bytes:!instance creation!public! !

