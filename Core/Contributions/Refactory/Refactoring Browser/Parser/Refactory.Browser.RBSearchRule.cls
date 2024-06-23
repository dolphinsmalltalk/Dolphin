"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBParseTreeRule
	subclass: #'Refactory.Browser.RBSearchRule'
	instanceVariableNames: 'answerBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RBSearchRule guid: (Core.GUID fromString: '{47f7b2b8-bdd2-449f-866d-e373a574dc60}')!

Refactory.Browser.RBSearchRule comment: ''!

!Refactory.Browser.RBSearchRule categoriesForClass!Refactory-ParseTree Matching! !

!Refactory.Browser.RBSearchRule methodsFor!

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

!Refactory.Browser.RBSearchRule categoriesForMethods!
canMatch:!public!testing! !
searchFor:thenDo:!initialize/release!public! !
searchForMethod:thenDo:!initialize/release!public! !
searchForTree:thenDo:!initialize/release!public! !
!

!Refactory.Browser.RBSearchRule class methodsFor!

searchFor: aString thenDo: aBlock 
	^self new searchFor: aString thenDo: aBlock!

searchForMethod: aString thenDo: aBlock 
	^self new searchForMethod: aString thenDo: aBlock!

searchForTree: aBRProgramNode thenDo: aBlock 
	^self new searchForTree: aBRProgramNode thenDo: aBlock! !

!Refactory.Browser.RBSearchRule class categoriesForMethods!
searchFor:thenDo:!instance creation!public! !
searchForMethod:thenDo:!instance creation!public! !
searchForTree:thenDo:!instance creation!public! !
!

