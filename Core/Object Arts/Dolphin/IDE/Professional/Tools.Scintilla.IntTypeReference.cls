"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.TypeReference subclass: #'Tools.Scintilla.IntTypeReference'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.IntTypeReference guid: (Core.GUID fromString: '{3bdd5bc5-0bb0-48e2-879d-d6d1375961e0}')!
Tools.Scintilla.IntTypeReference comment: ''!
!Tools.Scintilla.IntTypeReference categoriesForClass!Development! !
!Tools.Scintilla.IntTypeReference methodsFor!

defaultValue
	^0!

name
	^'int'!

objectClass
	^Integer!

printParameter: aString on: aWriteStream
	aWriteStream nextPutAll: aString! !
!Tools.Scintilla.IntTypeReference categoriesFor: #defaultValue!accessing!public! !
!Tools.Scintilla.IntTypeReference categoriesFor: #name!accessing!public! !
!Tools.Scintilla.IntTypeReference categoriesFor: #objectClass!accessing!public! !
!Tools.Scintilla.IntTypeReference categoriesFor: #printParameter:on:!generating!public! !

