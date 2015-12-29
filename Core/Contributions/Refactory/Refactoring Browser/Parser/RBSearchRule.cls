"Filed out from Dolphin Smalltalk XP 2002 release 5.02"!

RBParseTreeRule subclass: #RBSearchRule
	instanceVariableNames: 'answerBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBSearchRule guid: (GUID fromString: '{47F7B2B8-BDD2-449F-866D-E373A574DC60}')!
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
!RBSearchRule categoriesFor: #canMatch:!public!testing! !
!RBSearchRule categoriesFor: #searchFor:thenDo:!initialize/release!public! !
!RBSearchRule categoriesFor: #searchForMethod:thenDo:!initialize/release!public! !
!RBSearchRule categoriesFor: #searchForTree:thenDo:!initialize/release!public! !

!RBSearchRule class methodsFor!

searchFor: aString thenDo: aBlock 
	^self new searchFor: aString thenDo: aBlock!

searchForMethod: aString thenDo: aBlock 
	^self new searchForMethod: aString thenDo: aBlock!

searchForTree: aBRProgramNode thenDo: aBlock 
	^self new searchForTree: aBRProgramNode thenDo: aBlock! !
!RBSearchRule class categoriesFor: #searchFor:thenDo:!instance creation!public! !
!RBSearchRule class categoriesFor: #searchForMethod:thenDo:!instance creation!public! !
!RBSearchRule class categoriesFor: #searchForTree:thenDo:!instance creation!public! !

