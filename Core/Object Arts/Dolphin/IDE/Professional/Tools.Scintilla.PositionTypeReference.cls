"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.IntTypeReference subclass: #'Tools.Scintilla.PositionTypeReference'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.PositionTypeReference guid: (Core.GUID fromString: '{800dd767-5986-45fb-a47b-c9685723140b}')!
Tools.Scintilla.PositionTypeReference comment: ''!
!Tools.Scintilla.PositionTypeReference categoriesForClass!Development! !
!Tools.Scintilla.PositionTypeReference methodsFor!

defaultValue
	^'INVALID_POSITION'!

emitReturnConversionAround: aBlockClosure on: aPuttableStream
	aPuttableStream nextPut: $(.
	aBlockClosure value.
	aPuttableStream nextPutAll: ') + 1'!

name
	^'position'!

printParameter: aString on: aWriteStream
	aWriteStream
		nextPutAll: aString;
		space;
		display: ' - 1'! !
!Tools.Scintilla.PositionTypeReference categoriesFor: #defaultValue!accessing!public! !
!Tools.Scintilla.PositionTypeReference categoriesFor: #emitReturnConversionAround:on:!generating!private! !
!Tools.Scintilla.PositionTypeReference categoriesFor: #name!accessing!public! !
!Tools.Scintilla.PositionTypeReference categoriesFor: #printParameter:on:!generating!public! !

