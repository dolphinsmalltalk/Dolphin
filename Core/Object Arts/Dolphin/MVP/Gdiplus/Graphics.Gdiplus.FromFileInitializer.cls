"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.FromFileInitializer'
	instanceVariableNames: 'filename fileLocator'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FromFileInitializer guid: (Core.GUID fromString: '{9bcb004e-83e4-4d47-9adf-ec7927a69088}')!
Graphics.Gdiplus.FromFileInitializer isNonInstantiable: true!
Graphics.Gdiplus.FromFileInitializer comment: ''!
!Graphics.Gdiplus.FromFileInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FromFileInitializer methodsFor!

absoluteFilename
	^fileLocator isNil ifTrue: [filename] ifFalse: [fileLocator localFileSpecFor: filename]!

filename: aFilename fileLocator: aFileLocator
	filename := aFilename.
	fileLocator := aFileLocator!

printImage: anImage on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Graphics.Gdiplus.Image> initialized by the receiver."

	aWriteStream
		print: anImage class;
		nextPutAll: ' fromFile: ';
		print: filename.
	fileLocator = FileLocator default
		ifFalse: 
			[aWriteStream
				nextPutAll: ' usingLocator: ';
				print: fileLocator]! !
!Graphics.Gdiplus.FromFileInitializer categoriesForMethods!
absoluteFilename!enquiries!public! !
filename:fileLocator:!initializing!private! !
printImage:on:!public! !
!

!Graphics.Gdiplus.FromFileInitializer class methodsFor!

filename: aFilename fileLocator: aFileLocator
	^self new filename: aFilename fileLocator: aFileLocator! !
!Graphics.Gdiplus.FromFileInitializer class categoriesForMethods!
filename:fileLocator:!instance creation!public! !
!

