"Filed out from Dolphin Smalltalk X6"!

SingletonSearchPolicy subclass: #IdentitySearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdentitySearchPolicy guid: (GUID fromString: '{123A1503-7CB8-11D3-93CA-00A024CA708A}')!
IdentitySearchPolicy comment: 'IdentitySearchPolicy is for configuring pluggable collections and models to use identity based search and comparisons, i.e. using #== and #identityHash, etc. Using an instance of this search policy a <PluggableSet> will behave in the same way as an <IdentitySet>.'!
!IdentitySearchPolicy categoriesForClass!Collections-Support! !
!IdentitySearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^operand1 == operand2!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand identityHash!

hash: operand max: maximum
	"Answer a suitable hash value for the <Object>, operand, under this search policy, 
	between 1 and the <integer>, maximum.
	Implementation Note: The identityHash range is limited to 16-bits, so we must scale for large 
	collections to avoid excessive collisions causing a dramatic fall off in performance."

	^maximum < 8192
		ifTrue: [operand identityHash \\ maximum + 1]
		ifFalse: [(operand identityHash * (maximum bitShift: -12)) \\ maximum + 1]!

keyAtValue: value in: collection ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value in the keyed
	collection, collection, using the receiver's search policy. If there is no such 
	value, answer the result of evaluating the <niladicValuable>, operation.
	The reverse mapping identity search operation is used: The collection argument
	must respond to #keyAtValue:ifAbsent: (there is no keyedCollection protocol
	defined at present)."

	^collection keyAtValue: value ifAbsent: operation!

newLookupTable
	"Answer a new <LookupTable> with the receiver as its search policy."

	^IdentityDictionary new!

nextIndexOf: anElement in: collection from: start to: stop
	"Answer the index of the next occurrence of anElement in the <sequencedReadableCollection>
	argument,  collection, between startIndex and stopIndex inclusive. If there are no such occurrences, 
	answer 0."

	^collection nextIdentityIndexOf: anElement from: start to: stop! !
!IdentitySearchPolicy categoriesFor: #compare:with:!comparing!public! !
!IdentitySearchPolicy categoriesFor: #hash:!comparing!public! !
!IdentitySearchPolicy categoriesFor: #hash:max:!comparing!public! !
!IdentitySearchPolicy categoriesFor: #keyAtValue:in:ifAbsent:!public!searching! !
!IdentitySearchPolicy categoriesFor: #newLookupTable!operations!public! !
!IdentitySearchPolicy categoriesFor: #nextIndexOf:in:from:to:!public!searching! !

!IdentitySearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^self identity! !
!IdentitySearchPolicy class categoriesFor: #current!instance creation!public! !

