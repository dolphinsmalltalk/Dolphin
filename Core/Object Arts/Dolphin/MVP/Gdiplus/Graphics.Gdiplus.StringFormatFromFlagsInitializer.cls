"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.StringFormatInitializer subclass: #'Graphics.Gdiplus.StringFormatFromFlagsInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatFromFlagsInitializer guid: (Core.GUID fromString: '{f4b7aa82-5fd1-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.StringFormatFromFlagsInitializer comment: ''!
!Graphics.Gdiplus.StringFormatFromFlagsInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.StringFormatFromFlagsInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateStringFormat: formatFlags
		language: language
		format: gpHandle.
	^gpHandle!

formatFlags: flagsNumber language: languageNumber
	formatFlags := flagsNumber.
	language := languageNumber! !
!Graphics.Gdiplus.StringFormatFromFlagsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
formatFlags:language:!initializing!private! !
!

!Graphics.Gdiplus.StringFormatFromFlagsInitializer class methodsFor!

formatFlags: flagsNumber language: languageNumber
	^self new formatFlags: flagsNumber language: languageNumber! !
!Graphics.Gdiplus.StringFormatFromFlagsInitializer class categoriesForMethods!
formatFlags:language:!instance creation!public! !
!

