"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StIdentifierToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StIdentifierToken guid: (GUID fromString: '{6942E132-1F89-468C-B389-94D8DF69E1E4}')!
StIdentifierToken comment: ''!
!StIdentifierToken categoriesForClass!System-Compiler! !
!StIdentifierToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptIdentifierToken: self!

isIdentifier
	^true!

isPatternVariable
	^value first == self scannerClass patternVariableCharacter! !
!StIdentifierToken categoriesFor: #acceptVisitor:!public!visitor! !
!StIdentifierToken categoriesFor: #isIdentifier!public!testing! !
!StIdentifierToken categoriesFor: #isPatternVariable!public!testing! !

