"Filed out from Dolphin Smalltalk"!

EqualitySearchPolicy subclass: #AssociationSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AssociationSearchPolicy guid: (GUID fromString: '{f7fa3e66-a3ec-48a8-a083-defdf8679834}')!
AssociationSearchPolicy comment: 'AssocationSearchPolicy is a specialized <EqualitySearchPolicy> for searching homogeneous collections of Associations by equality.

Association has traditionally implemented #hash as the has of its key only, and this leads to poor lookup performance in a standard <Set> where there are a lot of Associations with equal keys. This search policy can be used with <PluggableSet> and <PluggableLookupTable> to ameliorate this problem.'!
!AssociationSearchPolicy categoriesForClass!Collections-Support! !
!AssociationSearchPolicy methodsFor!

hash: operand
	"Answer a hash value for the <Assocation>, operand, which takes account
	of the value as well as the key (historically Association>>hash has answered the
	hash of its key only, which makes it a poor Set element if a lot of the keys are the
	same)."

	^operand key hash bitXor: operand value hash!

hash: operand max: maximum
	"Answer a suitable hash value for the <Object>, operand, under this search policy, 
	between 1 and the <integer>, maximum. If maximum is a significant proportion
	of the range of hash values generated, then the result should be scaled to distribute
	evenly between 1 and maximum in order to avoid generating excessive collisions at
	the low end of the range."

	^(operand key hash bitXor: operand value hash) \\ maximum + 1!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^#association! !
!AssociationSearchPolicy categoriesForMethods!
hash:!comparing!public! !
hash:max:!comparing!public! !
name!accessing!public! !
!

