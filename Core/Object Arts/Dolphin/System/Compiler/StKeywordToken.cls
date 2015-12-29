"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StKeywordToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StKeywordToken guid: (GUID fromString: '{E61C129A-266F-46B1-A320-25DF7D71AC8F}')!
StKeywordToken comment: ''!
!StKeywordToken categoriesForClass!System-Compiler! !
!StKeywordToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptKeywordToken: self!

isKeyword
	^true!

isPatternVariable
	^value first == SmalltalkScanner patternVariableCharacter! !
!StKeywordToken categoriesFor: #acceptVisitor:!public!visitor! !
!StKeywordToken categoriesFor: #isKeyword!public!testing! !
!StKeywordToken categoriesFor: #isPatternVariable!public!testing! !

