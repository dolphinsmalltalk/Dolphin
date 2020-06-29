"Filed out from Dolphin Smalltalk 7"!

SingletonSearchPolicy subclass: #NeverSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NeverSearchPolicy guid: (GUID fromString: '{f9b07491-78b3-4ef8-a7af-af9c2a556b1a}')!
NeverSearchPolicy comment: ''!
!NeverSearchPolicy categoriesForClass!Collections-Support! !
!NeverSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^false!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^#never! !
!NeverSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!NeverSearchPolicy categoriesFor: #name!accessing!public! !

