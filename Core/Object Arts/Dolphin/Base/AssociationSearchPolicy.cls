"Filed out from Dolphin Smalltalk 7"!

EqualitySearchPolicy subclass: #AssociationSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AssociationSearchPolicy guid: (GUID fromString: '{F7FA3E66-A3EC-48A8-A083-DEFDF8679834}')!
AssociationSearchPolicy comment: 'AssocationSearchPolicy is a specialized <EqualitySearchPolicy> for searching homogeneous collections of Associations by equality.

Association has traditionally implemented #hash as the has of its key only, and this leads to poor lookup performance in a standard <Set> where there are a lot of Associations with equal keys. This search policy can be used with <PluggableSet> and <PluggableLookupTable> to ameliorate this problem.'!
!AssociationSearchPolicy categoriesForClass!Unclassified! !
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

	^(operand key hash bitXor: operand value hash) \\ maximum + 1! !
!AssociationSearchPolicy categoriesFor: #hash:!comparing!public! !
!AssociationSearchPolicy categoriesFor: #hash:max:!comparing!public! !

