"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.ColourTypeReference subclass: #'Tools.Scintilla.ColourAlphaTypeReference'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.ColourAlphaTypeReference guid: (Core.GUID fromString: '{a69a2d0b-2d7f-498d-b2dc-715cb304b176}')!
Tools.Scintilla.ColourAlphaTypeReference comment: ''!
!Tools.Scintilla.ColourAlphaTypeReference categoriesForClass!Development! !
!Tools.Scintilla.ColourAlphaTypeReference methodsFor!

fromMessage
	^#fromRgbaCode:!

name
	^'colouralpha'!

printParameter: aString on: aWriteStream
	aWriteStream
		nextPutAll: aString;
		space;
		display: #rgbaCode! !
!Tools.Scintilla.ColourAlphaTypeReference categoriesFor: #fromMessage!generating!private! !
!Tools.Scintilla.ColourAlphaTypeReference categoriesFor: #name!accessing!public! !
!Tools.Scintilla.ColourAlphaTypeReference categoriesFor: #printParameter:on:!generating!public! !

