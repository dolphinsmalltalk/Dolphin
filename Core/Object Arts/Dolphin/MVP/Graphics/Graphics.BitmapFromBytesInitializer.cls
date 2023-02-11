"Filed out from Dolphin Smalltalk"!

Graphics.BitmapFromBlankInitializer subclass: #'Graphics.BitmapFromBytesInitializer'
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.BitmapFromBytesInitializer guid: (Core.GUID fromString: '{1cc4ae6f-d94c-4c0b-a4b5-2b3707a1bba7}')!
Graphics.BitmapFromBytesInitializer comment: ''!
!Graphics.BitmapFromBytesInitializer methodsFor!

bytes
	^bytes!

bytes: anObject
	bytes := anObject!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore.
	In the receiver's case this depends on whether the bitmap bytes were supplied as a ByteArray, or a pointer to the bits."

	^bytes isIndirection not! !
!Graphics.BitmapFromBytesInitializer categoriesForMethods!
bytes!accessing!public! !
bytes:!initializing!private! !
isPersistent!public!testing! !
!

!Graphics.BitmapFromBytesInitializer class methodsFor!

extent: aPoint depth: bppInteger planes: planesInteger bytes: aByteArray
	<primitive: 157>
	^self new
		extent: aPoint;
		depth: bppInteger;
		planes: planesInteger;
		bytes: aByteArray;
		yourself! !
!Graphics.BitmapFromBytesInitializer class categoriesForMethods!
extent:depth:planes:bytes:!instance creation!public! !
!

