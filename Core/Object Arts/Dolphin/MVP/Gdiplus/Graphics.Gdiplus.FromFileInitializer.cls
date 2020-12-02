"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusFromFileInitializer
	instanceVariableNames: 'filename fileLocator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusFromFileInitializer guid: (GUID fromString: '{9bcb004e-83e4-4d47-9adf-ec7927a69088}')!
GdiplusFromFileInitializer isAbstract: true!
GdiplusFromFileInitializer comment: ''!
!GdiplusFromFileInitializer categoriesForClass!Unclassified! !
!GdiplusFromFileInitializer methodsFor!

absoluteFilename
	^fileLocator isNil ifTrue: [filename] ifFalse: [fileLocator localFileSpecFor: filename]!

filename: aFilename fileLocator: aFileLocator
	filename := aFilename.
	fileLocator := aFileLocator! !
!GdiplusFromFileInitializer categoriesFor: #absoluteFilename!enquiries!public! !
!GdiplusFromFileInitializer categoriesFor: #filename:fileLocator:!initializing!private! !

!GdiplusFromFileInitializer class methodsFor!

filename: aFilename fileLocator: aFileLocator
	^self new filename: aFilename fileLocator: aFileLocator! !
!GdiplusFromFileInitializer class categoriesFor: #filename:fileLocator:!instance creation!public! !

