"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.TypeReference
	subclass: #'Tools.Scintilla.BoolTypeReference'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.BoolTypeReference guid: (Core.GUID fromString: '{47f1adac-b9a0-4b2b-8fca-15b2a308ad85}')!
Tools.Scintilla.BoolTypeReference comment: ''!
!Tools.Scintilla.BoolTypeReference categoriesForClass!Development! !
!Tools.Scintilla.BoolTypeReference methodsFor!

defaultValue
	^false!

directFunctionKeyword
	^'directBooleanFunction:'!

name
	^'bool'!

objectClass
	^Boolean!

printParameter: aString on: aWriteStream
	aWriteStream
		nextPutAll: aString;
		space;
		display: #asParameter! !
!Tools.Scintilla.BoolTypeReference categoriesForMethods!
defaultValue!accessing!public! !
directFunctionKeyword!constants!generating!public! !
name!accessing!public! !
objectClass!accessing!public! !
printParameter:on:!generating!public! !
!

