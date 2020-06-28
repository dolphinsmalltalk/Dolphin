"Filed out from Dolphin Smalltalk 7"!

GdiplusStringFormatInitializer subclass: #GdiplusStringFormatFromFlagsInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusStringFormatFromFlagsInitializer guid: (GUID fromString: '{f4b7aa82-5fd1-11d7-b609-00e0987e8081}')!
GdiplusStringFormatFromFlagsInitializer comment: ''!
!GdiplusStringFormatFromFlagsInitializer categoriesForClass!Unclassified! !
!GdiplusStringFormatFromFlagsInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateStringFormat: formatFlags
				language: language
				format: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

formatFlags: flagsNumber language: languageNumber
	formatFlags := flagsNumber.
	language := languageNumber! !
!GdiplusStringFormatFromFlagsInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusStringFormatFromFlagsInitializer categoriesFor: #formatFlags:language:!initializing!private! !

!GdiplusStringFormatFromFlagsInitializer class methodsFor!

formatFlags: flagsNumber language: languageNumber
	^self new formatFlags: flagsNumber language: languageNumber! !
!GdiplusStringFormatFromFlagsInitializer class categoriesFor: #formatFlags:language:!instance creation!public! !

