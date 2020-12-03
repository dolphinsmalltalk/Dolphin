"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Core.SearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SearchPolicy guid: (Core.GUID fromString: '{123a1501-7cb8-11d3-93ca-00a024ca708a}')!
Core.SearchPolicy isNonInstantiable: true!
Core.SearchPolicy comment: 'SearchPolicy is for configuring pluggable collections and models to use different searching policies, e.g. equality vs. identity. SearchPolicy itself implements an equality based policy using #= and #hash, etc.

SearchPolicy is the canonical implementation of the <searchPolicy> and <comparisonPolicy> protocols (the latter is really a subset of the former).

The <comparisonPolicy> protocol can be used to compare two objects in order to determine if they are the "same". Different comparison policies can be employed which, for example, consider that two objects are the same iff they are the exact same identical object (i.e. ''''obj1 == obj2'''' is true), or on the other hand if they are of equal value (i.e. ''''obj1 = obj2'''' is true).

SearchPolicy maintains a number of prebuilt instances which implement popular search/comparison policies. These are accessible via class side methods in the ''''instance creation'''' category.

Class Variables:
	Always		<AlwaysSearchPolicy>. Maintains that two objects are always equal.
	Identity		<IdentitySearchPolicy>. Singleton instance for identity searching.
	Equality		<SearchPolicy>. Singleton instance for equality searching.
	Never		<NeverSearchPolicy>. Maintains that two objects are never equal.

'!
!Core.SearchPolicy categoriesForClass!Collections-Support! !
!Core.SearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^self subclassResponsibility
!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand hash!

hash: operand max: maximum
	"Answer a suitable hash value for the <Object>, operand, under this search policy, 
	between 1 and the <integer>, maximum. If maximum is a significant proportion
	of the range of hash values generated, then the result should be scaled to distribute
	evenly between 1 and maximum in order to avoid generating excessive collisions at
	the low end of the range."

	^(self hash: operand) \\ maximum + 1!

isEquality
	"Answer whether or not the receiver is a search policy that compares by object equality (i.e. uses #= for comparison and #hash for hashing)."

	^false!

isIdentity
	"Answer whether or not the receiver is a search policy that compares by object identity (i.e. uses #== for comparison and #identityHash for hashing)."

	^false!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^self name notNil!

keyAtValue: value in: collection ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value in the keyed
	collection, collection, using the receiver's search policy. If there is no such 
	value, answer the result of evaluating the <niladicValuable>, operation."

	collection keysAndValuesDo: [:k :v | (self compare: v with: value) ifTrue: [^k]].
	^operation value!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^nil!

newLookupTable
	"Answer a new <LookupTable> with a search policy equivalent to the receiver."

	^PluggableLookupTable searchPolicy: self!

newSet
	"Answer a new <Set> with a search policy equivalent to the receiver."

	^PluggableSet searchPolicy: self!

nextIndexOf: anElement in: sequence from: start to: stop
	"Answer the index of the next occurrence of anElement in the <sequencedReadableCollection>
	argument,  collection, between startIndex and stopIndex inclusive. If there are no such occurrences, 
	answer 0."

	sequence from: start to: stop keysAndValuesDo: [:i :elem | (self compare: elem with: anElement) ifTrue: [^i]].
	^0!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are the same as those which would result from sending a #printString message to the receiver."

	self name
		ifNotNil: 
			[:symbol |
			aPuttableStream
				print: SearchPolicy;
				space;
				display: symbol]
		ifNil: [super printOn: aPuttableStream]! !
!Core.SearchPolicy categoriesFor: #compare:with:!comparing!public! !
!Core.SearchPolicy categoriesFor: #hash:!comparing!public! !
!Core.SearchPolicy categoriesFor: #hash:max:!comparing!public! !
!Core.SearchPolicy categoriesFor: #isEquality!public!testing! !
!Core.SearchPolicy categoriesFor: #isIdentity!public!testing! !
!Core.SearchPolicy categoriesFor: #isSelfEvaluating!public!testing! !
!Core.SearchPolicy categoriesFor: #keyAtValue:in:ifAbsent:!public!searching! !
!Core.SearchPolicy categoriesFor: #name!accessing!public! !
!Core.SearchPolicy categoriesFor: #newLookupTable!operations!public! !
!Core.SearchPolicy categoriesFor: #newSet!operations!public! !
!Core.SearchPolicy categoriesFor: #nextIndexOf:in:from:to:!public!searching! !
!Core.SearchPolicy categoriesFor: #printOn:!public! !

Core.SearchPolicy methodProtocol: #comparisonPolicy attributes: #(#readOnly) selectors: #(#compare:with:)!
Core.SearchPolicy methodProtocol: #searchPolicy attributes: #(#readOnly) selectors: #(#compare:with: #hash: #hash:max: #keyAtValue:in:ifAbsent: #nextIndexOf:in:from:to:)!

!Core.SearchPolicy class methodsFor!

always
	"Answers the singleton instance of the receiver that always answers 
	true to #compare:with: (i.e. under this comparison policy two objects 
	are always considered equal)."

	^AlwaysSearchPolicy current!

caseInsensitive
	"Answer the singleton sub-instance of the receiver which supports a search policy
	based on case-insensitive string comparisons."

	^CaseInsensitiveSearchPolicy current!

equality
	"Answer the singleton sub-instance of the receiver which supports a search policy
	based on equality."

	^EqualitySearchPolicy current!

identity
	"Answer the singleton sub-instance of the receiver which supports a search policy
	based on identity."

	^IdentitySearchPolicy current!

never
	"Answers the singleton instance of the receiver that always answers 
	false to #compare:with: (i.e. under this comparison policy two objects 
	are never considered equal)."

	^NeverSearchPolicy current! !
!Core.SearchPolicy class categoriesFor: #always!instance creation!public! !
!Core.SearchPolicy class categoriesFor: #caseInsensitive!instance creation!public! !
!Core.SearchPolicy class categoriesFor: #equality!instance creation!public! !
!Core.SearchPolicy class categoriesFor: #identity!instance creation!public! !
!Core.SearchPolicy class categoriesFor: #never!instance creation!public! !

