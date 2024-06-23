"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.ImageInitializer
	subclass: #'Graphics.Gdiplus.AbstractImageFromFileInitializer'
	instanceVariableNames: 'filename fileLocator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.AbstractImageFromFileInitializer guid: (Core.GUID fromString: '{9bcb004e-83e4-4d47-9adf-ec7927a69088}')!

Graphics.Gdiplus.AbstractImageFromFileInitializer isNonInstantiable: true!

Graphics.Gdiplus.AbstractImageFromFileInitializer comment: ''!

!Graphics.Gdiplus.AbstractImageFromFileInitializer methodsFor!

= anObject
	^self == anObject or: 
			[self species = anObject species
				and: [filename = anObject filename and: [fileLocator = anObject fileLocator]]]!

absoluteFilename
	^fileLocator isNil ifTrue: [filename] ifFalse: [fileLocator localFileSpecFor: filename]!

fileLocator
	^fileLocator!

filename
	^filename!

filename: aFilename fileLocator: aFileLocator
	filename := aFilename.
	fileLocator := aFileLocator.
	^self!

hash
	^((self species hash + filename hash) hashMultiply + fileLocator hash) hashMultiply!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^fileLocator isSelfEvaluating!

printImage: aGdiplusImage on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Graphics.Gdiplus.Image> initialized by the receiver."

	aWriteStream
		nextPut: $(;
		print: aGdiplusImage class;
		nextPutAll: ' fromFile: ';
		print: filename.
	fileLocator = FileLocator default
		ifFalse: 
			[aWriteStream
				nextPutAll: ' usingLocator: ';
				print: fileLocator].
	aWriteStream nextPut: $)! !

!Graphics.Gdiplus.AbstractImageFromFileInitializer categoriesForMethods!
=!comparing!public! !
absoluteFilename!enquiries!public! !
fileLocator!accessing!private! !
filename!accessing!private! !
filename:fileLocator:!initializing!private! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
printImage:on:!printing!private! !
!

!Graphics.Gdiplus.AbstractImageFromFileInitializer class methodsFor!

filename: aFilename fileLocator: aFileLocator
	^self new filename: aFilename fileLocator: aFileLocator! !

!Graphics.Gdiplus.AbstractImageFromFileInitializer class categoriesForMethods!
filename:fileLocator:!instance creation!public! !
!

