"Filed out from Dolphin Smalltalk 7"!

SingletonSearchPolicy subclass: #NeverSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NeverSearchPolicy guid: (GUID fromString: '{F9B07491-78B3-4EF8-A7AF-AF9C2A556B1A}')!
NeverSearchPolicy comment: ''!
!NeverSearchPolicy categoriesForClass!Collections-Support! !
!NeverSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^false! !
!NeverSearchPolicy categoriesFor: #compare:with:!comparing!public! !

