"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusFromFileInitializer
	instanceVariableNames: 'filename fileLocator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusFromFileInitializer guid: (GUID fromString: '{9BCB004E-83E4-4D47-9ADF-EC7927A69088}')!
GdiplusFromFileInitializer comment: ''!
!GdiplusFromFileInitializer categoriesForClass!Unclassified! !
!GdiplusFromFileInitializer methodsFor!

absoluteFilename
	^fileLocator isNil ifTrue: [filename] ifFalse: [fileLocator localFileSpecFor: filename]!

filename: aFilename fileLocator: aFileLocator
	filename := aFilename.
	fileLocator := aFileLocator! !
!GdiplusFromFileInitializer categoriesFor: #absoluteFilename!enquiries!public! !
!GdiplusFromFileInitializer categoriesFor: #filename:fileLocator:!accessing!public! !

!GdiplusFromFileInitializer class methodsFor!

filename: aFilename fileLocator: aFileLocator
	^self new filename: aFilename fileLocator: aFileLocator! !
!GdiplusFromFileInitializer class categoriesFor: #filename:fileLocator:!instance creation!public! !

