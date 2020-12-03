"Filed out from Dolphin Smalltalk 7"!

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
	fileLocator := aFileLocator! !
!Graphics.Gdiplus.FromFileInitializer categoriesFor: #absoluteFilename!enquiries!public! !
!Graphics.Gdiplus.FromFileInitializer categoriesFor: #filename:fileLocator:!initializing!private! !

!Graphics.Gdiplus.FromFileInitializer class methodsFor!

filename: aFilename fileLocator: aFileLocator
	^self new filename: aFilename fileLocator: aFileLocator! !
!Graphics.Gdiplus.FromFileInitializer class categoriesFor: #filename:fileLocator:!instance creation!public! !

