"Filed out from Dolphin Smalltalk"!

SearchPolicy subclass: #PluggableSearchPolicy
	instanceVariableNames: 'compareBlock hashBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableSearchPolicy guid: (GUID fromString: '{916f2071-ed60-40eb-9152-d25fc0567f6f}')!
PluggableSearchPolicy comment: 'PluggableSearchPolicy is for configuring pluggable collections and models to use pluggable search and comparison operations, i.e. one can define new search policies as instances of this class without writing a new <SearchPolicy> class, however performance will suffer slightly.'!
!PluggableSearchPolicy categoriesForClass!Collections-Support! !
!PluggableSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^compareBlock value: operand1 value: operand2
!

compareBlock: discriminator hashBlock: hasher
	"Set the <dynadicValuable> used by receiver to compare object to the
	argument, discriminator. The discriminator should answer true if its two
	arguments are considered equivalent under this search policy, else false.
	Also set the <monadicValuable> used by the receiver to calculate hash values to the
	argument, hasher. Answer the receiver."

	compareBlock := discriminator.
	hashBlock := hasher.
	^self!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^hashBlock value: operand! !
!PluggableSearchPolicy categoriesForMethods!
compare:with:!comparing!public! !
compareBlock:hashBlock:!accessing!initializing!public! !
hash:!comparing!public! !
!

!PluggableSearchPolicy class methodsFor!

new
	"Instances of the receiver require that hashing and comparison valuables
	be supplied - use newCompareBlock:hashBlock:"

	^self shouldNotImplement!

newCompareBlock: discriminator hashBlock: hasher
	"Answer a new instance of the receiver configured with the <dyadicValuable comparison block,
	discriminator, and the <monadicValuable> hashing block, hasher."

	^super new
		compareBlock: discriminator hashBlock: hasher! !
!PluggableSearchPolicy class categoriesForMethods!
new!instance creation!public! !
newCompareBlock:hashBlock:!instance creation!public! !
!

