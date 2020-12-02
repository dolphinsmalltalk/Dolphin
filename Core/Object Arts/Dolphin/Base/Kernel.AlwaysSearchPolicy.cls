"Filed out from Dolphin Smalltalk 7"!

SingletonSearchPolicy subclass: #AlwaysSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AlwaysSearchPolicy guid: (GUID fromString: '{2e18d23b-3270-41b5-8abe-acaaf5d21a3c}')!
AlwaysSearchPolicy comment: ''!
!AlwaysSearchPolicy categoriesForClass!Collections-Support! !
!AlwaysSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^true!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy.
	Implementation Note: Since the objects compared are always considered equal, 
	we must use the same hash value for all objects."

	^1!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^#always! !
!AlwaysSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!AlwaysSearchPolicy categoriesFor: #hash:!comparing!public! !
!AlwaysSearchPolicy categoriesFor: #name!accessing!public! !

