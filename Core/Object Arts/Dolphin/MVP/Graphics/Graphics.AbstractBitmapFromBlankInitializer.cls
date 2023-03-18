"Filed out from Dolphin Smalltalk"!

Graphics.ImageInitializer
	subclass: #'Graphics.AbstractBitmapFromBlankInitializer'
	instanceVariableNames: 'extent depth'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.AbstractBitmapFromBlankInitializer guid: (Core.GUID fromString: '{aaa7476f-f764-4f83-91b9-cb518458e508}')!
Graphics.AbstractBitmapFromBlankInitializer isNonInstantiable: true!
Graphics.AbstractBitmapFromBlankInitializer comment: ''!
!Graphics.AbstractBitmapFromBlankInitializer methodsFor!

depth: anInteger
	depth := anInteger!

extent
	^extent!

extent: aPoint
	extent := aPoint!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the <Image> it describes exactly as it was across Smalltalk image save/restore. This is generally false for blank bitmaps as the expectation is that they will be painted on-the-fly."

	^false!

printImage: aBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		print: aBitmap class;
		nextPutAll: ' extent: ';
		print: extent;
		nextPutAll: ' depth: ';
		print: depth! !
!Graphics.AbstractBitmapFromBlankInitializer categoriesForMethods!
depth:!initializing!private! !
extent!accessing!public! !
extent:!accessing!public! !
isPersistent!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.AbstractBitmapFromBlankInitializer class methodsFor!

extent: aPoint depth: anInteger
	^self subclassResponsibility! !
!Graphics.AbstractBitmapFromBlankInitializer class categoriesForMethods!
extent:depth:!instance creation!public! !
!

