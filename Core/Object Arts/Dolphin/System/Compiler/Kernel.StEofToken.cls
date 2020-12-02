"Filed out from Dolphin Smalltalk 7"!

StToken subclass: #StEofToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StEofToken guid: (GUID fromString: '{0bce1c26-bdfc-4d18-bba2-99d89eeea71a}')!
StEofToken comment: ''!
!StEofToken categoriesForClass!System-Compiler! !
!StEofToken methodsFor!

acceptVisitor: aTokenVisitor 
	self error: 'End of token stream'!

isEof
	^true!

length
	^0! !
!StEofToken categoriesFor: #acceptVisitor:!public!visitor! !
!StEofToken categoriesFor: #isEof!public!testing! !
!StEofToken categoriesFor: #length!accessing!public! !

