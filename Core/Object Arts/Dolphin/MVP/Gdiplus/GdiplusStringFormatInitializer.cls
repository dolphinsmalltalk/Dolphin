"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusStringFormatInitializer
	instanceVariableNames: 'formatFlags language'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusStringFormatInitializer guid: (GUID fromString: '{f4b7aa82-5fd1-11d7-b609-00e0987e8081}')!
GdiplusStringFormatInitializer comment: ''!
!GdiplusStringFormatInitializer categoriesForClass!Unclassified! !
!GdiplusStringFormatInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library 
				gdipCreateStringFormat: formatFlags
				language: language
				format: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

formatFlags: flagsNumber language: languageNumber
	formatFlags := flagsNumber.
	language := languageNumber!

gdiplusConstructorErrorDescription
	^'Error creating StringFormat'! !
!GdiplusStringFormatInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusStringFormatInitializer categoriesFor: #formatFlags:language:!accessing!public! !
!GdiplusStringFormatInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusStringFormatInitializer class methodsFor!

formatFlags: flagsNumber language: languageNumber
	^self new formatFlags: flagsNumber language: languageNumber! !
!GdiplusStringFormatInitializer class categoriesFor: #formatFlags:language:!instance creation!public! !

