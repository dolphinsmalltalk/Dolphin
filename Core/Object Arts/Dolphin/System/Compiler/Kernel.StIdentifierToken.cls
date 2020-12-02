"Filed out from Dolphin Smalltalk 7"!

StValueToken subclass: #StIdentifierToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StIdentifierToken guid: (GUID fromString: '{6942e132-1f89-468c-b389-94d8df69e1e4}')!
StIdentifierToken comment: ''!
!StIdentifierToken categoriesForClass!System-Compiler! !
!StIdentifierToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitIdentifierToken: self!

isIdentifier
	^true!

isPatternVariable
	^value first == self scannerClass patternVariableCharacter! !
!StIdentifierToken categoriesFor: #acceptVisitor:!public!visitor! !
!StIdentifierToken categoriesFor: #isIdentifier!public!testing! !
!StIdentifierToken categoriesFor: #isPatternVariable!public!testing! !

