"Filed out from Dolphin Smalltalk"!

Kernel.StToken
	subclass: #'Kernel.StEofToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StEofToken guid: (Core.GUID fromString: '{0bce1c26-bdfc-4d18-bba2-99d89eeea71a}')!

Kernel.StEofToken comment: ''!

!Kernel.StEofToken categoriesForClass!System-Compiler! !

!Kernel.StEofToken methodsFor!

acceptVisitor: aTokenVisitor 
	self error: 'End of token stream'!

isEof
	^true!

length
	^0! !

!Kernel.StEofToken categoriesForMethods!
acceptVisitor:!public!visitor! !
isEof!public!testing! !
length!accessing!public! !
!

