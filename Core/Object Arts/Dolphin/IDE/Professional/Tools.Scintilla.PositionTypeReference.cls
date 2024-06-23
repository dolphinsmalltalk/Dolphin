"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.IntTypeReference
	subclass: #'Tools.Scintilla.PositionTypeReference'
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

!Tools.Scintilla.PositionTypeReference categoriesForMethods!
defaultValue!accessing!public! !
emitReturnConversionAround:on:!generating!private! !
name!accessing!public! !
printParameter:on:!generating!public! !
!

