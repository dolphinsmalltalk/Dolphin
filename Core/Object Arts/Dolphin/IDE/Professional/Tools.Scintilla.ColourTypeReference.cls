"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.TypeReference
	subclass: #'Tools.Scintilla.ColourTypeReference'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.ColourTypeReference guid: (Core.GUID fromString: '{f4009d29-afe4-4041-aa9d-6d2cb20861a9}')!
Tools.Scintilla.ColourTypeReference comment: ''!
!Tools.Scintilla.ColourTypeReference categoriesForClass!Development! !
!Tools.Scintilla.ColourTypeReference methodsFor!

defaultValue
	^'Color black rgbCode'!

emitReturnConversionAround: aBlockClosure on: aPuttableStream
	aPuttableStream
		print: self objectClass;
		space;
		nextPutAll: self fromMessage;
		nextPutAll: ' ('.
	aBlockClosure value.
	aPuttableStream nextPut: $)!

fromMessage
	^#fromRgbCode:!

name
	^'colour'!

objectClass
	^Color!

printParameter: aString on: aWriteStream
	aWriteStream
		nextPutAll: aString;
		space;
		display: #rgbCode! !
!Tools.Scintilla.ColourTypeReference categoriesForMethods!
defaultValue!constants!public! !
emitReturnConversionAround:on:!generating!private! !
fromMessage!generating!private! !
name!accessing!public! !
objectClass!accessing!public! !
printParameter:on:!generating!public! !
!

