"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueToken subclass: #'Kernel.StIdentifierToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StIdentifierToken guid: (Core.GUID fromString: '{6942e132-1f89-468c-b389-94d8df69e1e4}')!
Kernel.StIdentifierToken comment: ''!
!Kernel.StIdentifierToken categoriesForClass!System-Compiler! !
!Kernel.StIdentifierToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitIdentifierToken: self!

isIdentifier
	^true!

isPatternVariable
	^value first == self scannerClass patternVariableCharacter! !
!Kernel.StIdentifierToken categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StIdentifierToken categoriesFor: #isIdentifier!public!testing! !
!Kernel.StIdentifierToken categoriesFor: #isPatternVariable!public!testing! !

