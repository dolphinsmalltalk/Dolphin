"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StKeywordToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StKeywordToken guid: (GUID fromString: '{e61c129a-266f-46b1-a320-25df7d71ac8f}')!

StKeywordToken comment: ''!

!StKeywordToken categoriesForClass!System-Compiler! !

!StKeywordToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitKeywordToken: self!

isKeyword
	^true!

isPatternVariable
	^value first == SmalltalkScanner patternVariableCharacter! !

!StKeywordToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isKeyword!public!testing! !
isPatternVariable!public!testing! !
!

