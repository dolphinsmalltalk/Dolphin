"Filed out from Dolphin Smalltalk 7"!

StValueToken subclass: #StKeywordToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StKeywordToken categoriesFor: #acceptVisitor:!public!visitor! !
!StKeywordToken categoriesFor: #isKeyword!public!testing! !
!StKeywordToken categoriesFor: #isPatternVariable!public!testing! !

