"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StIdentifierToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!StIdentifierToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isIdentifier!public!testing! !
isPatternVariable!public!testing! !
!

