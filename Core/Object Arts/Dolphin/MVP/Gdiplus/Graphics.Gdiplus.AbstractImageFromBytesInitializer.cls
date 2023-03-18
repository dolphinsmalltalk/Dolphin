"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.ImageInitializer
	subclass: #'Graphics.Gdiplus.AbstractImageFromBytesInitializer'
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AbstractImageFromBytesInitializer guid: (Core.GUID fromString: '{3156f9e7-c46c-48e7-9cca-e6405bf8a085}')!
Graphics.Gdiplus.AbstractImageFromBytesInitializer isNonInstantiable: true!
Graphics.Gdiplus.AbstractImageFromBytesInitializer comment: ''!
!Graphics.Gdiplus.AbstractImageFromBytesInitializer methodsFor!

= anObject
	^self == anObject or: [self species = anObject species and: [self bytes = anObject bytes]]!

bytes
	^bytes!

hash
	^(self species hash + bytes hash) hashMultiply!

iStream
	^COM.IStream fromBytes: bytes!

printImage: aGdiplusImage on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Graphics.Gdiplus.Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: aGdiplusImage class;
		nextPutAll: ' fromByteArray: ';
		print: bytes;
		nextPut: $)!

setBytes: aByteArray
	bytes := aByteArray.
	^self! !
!Graphics.Gdiplus.AbstractImageFromBytesInitializer categoriesForMethods!
=!comparing!public! !
bytes!accessing!private! !
hash!comparing!public! !
iStream!private!realizing/unrealizing! !
printImage:on:!printing!private! !
setBytes:!initializing!private! !
!

!Graphics.Gdiplus.AbstractImageFromBytesInitializer class methodsFor!

bytes: aByteArray 
	^self new setBytes: aByteArray! !
!Graphics.Gdiplus.AbstractImageFromBytesInitializer class categoriesForMethods!
bytes:!instance creation!public! !
!

