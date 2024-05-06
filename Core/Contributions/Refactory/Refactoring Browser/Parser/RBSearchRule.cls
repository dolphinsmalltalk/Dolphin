"Filed out from Dolphin Smalltalk"!

RBParseTreeRule subclass: #RBSearchRule
	instanceVariableNames: 'answerBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBSearchRule guid: (GUID fromString: '{47f7b2b8-bdd2-449f-866d-e373a574dc60}')!

RBSearchRule comment: ''!

!RBSearchRule categoriesForClass!Refactory-ParseTree Matching! !

!RBSearchRule methodsFor!

canMatch: aProgramNode 
	owner answer: (answerBlock value: aProgramNode value: owner answer).
	^true!

searchFor: aString thenDo: aBlock 
	self searchString: aString.
	answerBlock := aBlock!

searchForMethod: aString thenDo: aBlock 
	self methodSearchString: aString.
	answerBlock := aBlock!

searchForTree: aBRProgramNode thenDo: aBlock 
	searchTree := aBRProgramNode.
	answerBlock := aBlock! !

!RBSearchRule categoriesForMethods!
canMatch:!public!testing! !
searchFor:thenDo:!initialize/release!public! !
searchForMethod:thenDo:!initialize/release!public! !
searchForTree:thenDo:!initialize/release!public! !
!

!RBSearchRule class methodsFor!

searchFor: aString thenDo: aBlock 
	^self new searchFor: aString thenDo: aBlock!

searchForMethod: aString thenDo: aBlock 
	^self new searchForMethod: aString thenDo: aBlock!

searchForTree: aBRProgramNode thenDo: aBlock 
	^self new searchForTree: aBRProgramNode thenDo: aBlock! !

!RBSearchRule class categoriesForMethods!
searchFor:thenDo:!instance creation!public! !
searchForMethod:thenDo:!instance creation!public! !
searchForTree:thenDo:!instance creation!public! !
!

