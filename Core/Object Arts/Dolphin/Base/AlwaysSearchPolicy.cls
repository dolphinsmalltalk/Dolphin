"Filed out from Dolphin Smalltalk 7"!

SingletonSearchPolicy subclass: #AlwaysSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AlwaysSearchPolicy guid: (GUID fromString: '{2E18D23B-3270-41B5-8ABE-ACAAF5D21A3C}')!
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

	^1! !
!AlwaysSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!AlwaysSearchPolicy categoriesFor: #hash:!comparing!public! !

