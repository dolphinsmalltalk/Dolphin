"Filed out from Dolphin Smalltalk"!

Core.Dictionary
	variableSubclass: #'Core.LookupTable'
	instanceVariableNames: 'values'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.LookupTable guid: (Core.GUID fromString: '{87b4c529-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.LookupTable comment: 'A LookupTable is a form of <Dictionary> that does not actually store <Assocation>s, but instead maintains parallel vectors of keys and values. This has the advantage of consuming less space and generally offering higher performance. 

Dictionary behaviour involving <Assocation>s (e.g. #associationsDo:, #associationAt:) is implemented by dynamically generating associations as required. This may adversely affect performance where such behaviour is used extensively, and the transient nature of the associations may not always be appropriate. In these (rare) cases a standard Dictionary should be used.

LookupTable itself uses equality-based hashing and comparisons. The subclass IdentityDictionary and its subclasses employ identity-based hashing and comparisons.

Instance Variables:
	values	<Array> of values associated with the same numbered keys in the indexable instance variables of the LookupTable.'!
!Core.LookupTable categoriesForClass!Collections-Unordered! !
!Core.LookupTable methodsFor!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation. Unlike Dictionaries, 
	LookupTables do not actually store Associations, therefore we must 
	reimplement this in terms of #at:put:."

	self at: anAssociation key put: anAssociation value.
	^anAssociation
!

allKeysAndValuesSatisfy: aDyadicValuable
	"Answer whether the <dyadicValuable> argument evaluates to true for all of the receiver's key and value pairs."

	tally == 0 ifTrue: [^true].
	1 to: self basicSize
		do: 
			[:i |
			(self basicAt: i)
				ifNotNil: [:key | (aDyadicValuable value: key value: (values at: i)) ifFalse: [^false]]].
	^true!

anyKeysAndValuesSatisfy: aDyadicValuable
	"Answer whether the <dyadicValuable> argument evaluates to true for any of the receiver's key and value pairs."

	tally == 0 ifTrue: [^false].
	1 to: self basicSize
		do: 
			[:i |
			(self basicAt: i)
				ifNotNil: [:key | (aDyadicValuable value: key value: (values at: i)) ifTrue: [^true]]].
	^false!

anySatisfy: aMonadicValuable
	"Answer whether the <monadicValuable> argument evaluates to true for any element of the receiver."

	tally == 0 ifTrue: [^false].
	1 to: self basicSize do: [:i | (self basicAt: i) ifNotNil: [(aMonadicValuable value: (values at: i)) ifTrue: [^true]]].
	^false!

associationAt: anObject ifAbsent: aNiladicValuable
	"Answer a new <Association> between the key and value of the receiver at the first argument.
	If the key is not found, answer the result of evaluating the <niladicValuable> exception
	handler."

	"Implementation Note: LookupTables do not actually store key-value pairs in Associations, so
	the answer is not state information."

	| value |
	value := self at: anObject ifAbsent: AbsentCookie.
	^value == AbsentCookie
		ifTrue: [aNiladicValuable value]
		ifFalse: [self newAssociation: anObject value: value]!

associationsDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's 
	key/value associations.
	Implementation Note: We must override because the receiver does not 
	actually contain Associations."

	self keysAndValuesDo: [:k :v | 
		operation value: (self associationClass key: k value: v)]!

at: anObject ifAbsent: aNiladicValuable
	"Answer the value named by the key argument, anObject.  If the key is not found, 
	answer the result of evaluating the <niladicValuable> argument."

	| index |
	^(self basicAt: (index := self findKeyOrNil: anObject)) 
		ifNil: [aNiladicValuable value]
		ifNotNil: [values at: index]!

at: keyObject ifAbsentPutClean: aNiladicValuable
	"Answer the value of the receiver keyed by the first <Object> argument. If key is not one of the receiver's keys, then add the result of evaluating  the <niladicValuable> 2nd argument and answer that result.
	Note that unlike #at:ifAbsentPut:, this method assumes that the valuable does not modify the receiver, and therefore it only looks up the key position once. Thus it is more efficient but less general purpose."

	| index |
	^(self basicAt: (index := self findKeyOrNil: (keyObject ifNil: [^self error: 'key cannot be nil'])))
		ifNil: 
			[| value |
			values at: index put: (value := aNiladicValuable value).
			self privateAt: index put: keyObject.
			value]
		ifNotNil: [values at: index]!

at: keyObject put: valueObject
	"Store the <Object> argument valueObject at the <Object> keyObject, in the receiver. Answer valueObject."

	| index |
	"We must store the value first, as a resize may occur during privateAt:put:"
	values at: (index := self findKeyOrNil: (keyObject ifNil: [^self error: 'key cannot be nil'])) put: valueObject.
	(self basicAt: index) ifNil: [self privateAt: index put: keyObject].
	^valueObject!

basicValues
	"Private - Answer the <ArrayedCollection> of values in the receiver."

	^values!

copyElementsInto: newMe
	"Private - Add the receiver's elements into the argument, newMe.
	Private part of the implementation of hashed collection resizing."

	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [:key | newMe uncheckedAt: key put: (values at: i)]]!

do: aMonadicValuable
	"Evaluate <monadicValuable> argument, for each of the elements (values) 
	of the receiver. Answers the receiver."

	"Implementation Note: We could implement in terms of #keyAndValuesDo:, but 
	performance is important here."

	tally == 0 ifTrue: [^self].
	1 to: self basicSize do: [:i | (self basicAt: i) ifNotNil: [aMonadicValuable value: (values at: i)]]!

findElementOrNil: anObject
	"Private - Answer the index of the specified key object in the receiver, 
	or nil if not present.
	Implementation Note: The directly held elements of a LookupTable
	are the keys. The values are held in a separate values <Array>."

	^self findKeyOrNil: anObject!

findKeyOrNil: anObject
	"Private - Answer the index of the given key in the receiver, or, if not found,
	the index of the first empty slot including and after that to which 
	the key hashes."

	"Implementation Note: Similar to Dictionary>>findKeyOrNil:, except that the 
	private elements of the receiver are not associations, but the keys themselves.
	Subclasses which use identity for key comparison and hashing MUST override this method."

	| capacity index |
	index := anObject hash \\ (capacity := self basicSize) + 1.

	[| key |
	(key := self basicAt: index) isNil or: [key = anObject]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

identityIncludes: comperand
	"Answer whether the <Object> argument, comperand, is one of the receiver's elements.
	Implementation Note: Override for improved performance."

	^values identityIncludes: comperand!

includesAssociation: anAssociation
	"Answer whether the receiver contains the key/value pair in anAssociation"

	| index |
	index := self findKeyOrNil: anAssociation key.
	^(self basicAt: index) notNil
		and: [(values at: index) = anAssociation value]
!

initialize
	"Private - Initialize the receiver."

	super initialize.
	values := self valuesClass new: self basicSize
!

isImmutable: aBoolean 
	values isImmutable: aBoolean.
	^super isImmutable: aBoolean!

isSelfEvaluating: visitedSet
	"Private - Answer whether the receiver can be represented as a literal (i.e. it has a printed representation which can be directly understood by the compiler)."

	^(visitedSet addNewElement: self) and: 
			[self allKeysAndValuesSatisfy: 
					[:eachKey :eachValue |
					(eachKey isSelfEvaluating: visitedSet) and: [eachValue isSelfEvaluating: visitedSet]]]!

keyAtEqualValue: value ifAbsent: exceptionHandler
	"Answer the name of the argument, value. If there is no such value, answer
	the result of evaluating the niladic valuable, exceptionHandler.
	Equality is used for comparison of the values (this increases the chances of 
	returning any duplicates the Dictionary might contain).
	Implementation Note: Override the superclass implementation which is
	slow for LookupTables as they don't actually contain Associations.
	Lookup tables are implemented as a pair of parallel arrays, so we can
	do much better by a fast serial search through the value array."

	| i |
	i := values indexOf: value.
	^i == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [self basicAt: i]!

keyAtValue: value ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value. 
	If there is no such value, answer the result of evaluating the 
	<niladicValuable>, operation. Identity is used for comparison of the values.
	Implementation Note: Override superclass implementation to use the fast
	primitive identity search search through the values Array. This makes keyAtValue:
	several times faster in LookupTables than it is in Dictionaries."

	| index |
	index := values basicIdentityIndexOf: value from: 1 to: values basicSize.
	^index == 0
		ifTrue: [operation value]
		ifFalse: [self basicAt: index]!

keysAndValuesDo: operation
	"Evaluate the dyadic valuable, operation, for each key/value pair in the receiver.
	Implementation Note: As LookupTables do not store Associations, we must
	override superclass implementation."

	tally == 0 ifTrue: [^self].
	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [:key | operation value: key value: (values at: i)]]!

keysDo: operation 
	"Evaluate the <monadicValuable>, operation, for each of the receiver's keys."

	tally == 0 ifTrue: [^self].
	1 to: self basicSize do: [:i | (self basicAt: i) ifNotNil: [:key | operation value: key]]!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver."

	| index |
	^(self basicAt: (index := self findKeyOrNil: keyObject)) ifNotNil: [values at: index]!

moveFrom: fromIndex to: toIndex
	"Private - Destructively move the element at index, fromIndex, over
	the element (normally nil) at index, toIndex. Overridden to
	move both key and value which are stored separately in LookupTables"

	self basicAt: toIndex put: (self basicAt: fromIndex).
	values at: toIndex put: (values at: fromIndex).
	self basicAt: fromIndex put: nil.
	values at: fromIndex put: nil
!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a LookupTable we need to copy the values array too."

	values := values copy.
	^self!

removeAssociationAt: anObject ifAbsent: aNiladicValuable
	"Remove the key and value association with the specified key from the receiver. Answer the removed <Association>."

	| value |
	value := self removeKey: anObject ifAbsent: AbsentCookie.
	^value == AbsentCookie
		ifTrue: [aNiladicValuable value]
		ifFalse: [self associationClass key: anObject value: value]!

removeKey: key ifAbsent: exceptionHandler 
	"Remove the key (and its associated value), from the receiver. If key is not in the 
	receiver, answer the result of evaluating the niladic valuable, exceptionHandler.
	Otherwise, answer the value named by key."

	| index |
	index := self findKeyOrNil: key.
	^(self basicAt: index) isNil 
		ifTrue: [exceptionHandler value]
		ifFalse: 
			[| value |
			value := values at: index.
			values at: index put: nil.
			self removeIndex: index.
			value]!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements.
	Answer a new <collection> like the receiver (i.e. an <abstractDictionary>) containing only 
	those elements for which the discriminator evaluates to true.
	Implementation Note: Override for better performance (#associationsDo: is slow against
	LookupTables)."

	| answer |
	answer := self newSelection.
	self 
		keysAndValuesDo: [:k :v | (discriminator value: v) ifTrue: [answer at: k put: v]].
	^answer!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types.
	Weak types are generally considered as of the same species as their equivalent strong type."

	^LookupTable!

uncheckedAdd: newObject 
	"Private - Add newObject to the receiver, without checking to see if it is already present.
	We also assume the receiver is large enough to accommodate the new element, and so do not
	attempt to maintain the load factor."

	self uncheckedAt: newObject key put: newObject value!

uncheckedAt: key put: anObject
	"Private - Store the argument anObject with the external key, key, in the 
	receiver without checking to see if it is already an element of the receiver.
	Also, does not attempt to maintain the optimal load factor. Answer anObject.
	This is part of the implementation of resizing of hashed collections."

	| index |
	index := self findKeyOrNil: key.
	tally := tally + 1.
	self basicAt: index put: key.
	^values at: index put: anObject.
!

valuesClass
	"Answer the class of Collection to use to hold the values of the receiver's elements
	(N.B. This is a different concept from #keysClass, which is used for copying the keys of 
	the receiver)."

	^Array! !
!Core.LookupTable categoriesForMethods!
add:!adding!public! !
allKeysAndValuesSatisfy:!enumerating!public! !
anyKeysAndValuesSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
associationAt:ifAbsent:!accessing!public! !
associationsDo:!enumerating!public! !
at:ifAbsent:!accessing!public! !
at:ifAbsentPutClean:!accessing!public! !
at:put:!accessing!public! !
basicValues!accessing!private! !
copyElementsInto:!adding!private! !
do:!debugger-step through!enumerating!public! !
findElementOrNil:!private!searching! !
findKeyOrNil:!private!searching! !
identityIncludes:!public!searching! !
includesAssociation:!public!searching! !
initialize!initializing!private! !
isImmutable:!initializing!public! !
isSelfEvaluating:!private!testing! !
keyAtEqualValue:ifAbsent:!accessing!public! !
keyAtValue:ifAbsent:!accessing!public! !
keysAndValuesDo:!enumerating!public! !
keysDo:!enumerating!public! !
lookup:!accessing!public! !
moveFrom:to:!private!removing! !
postCopy!copying!public! !
removeAssociationAt:ifAbsent:!public!removing! !
removeKey:ifAbsent:!public!removing! !
select:!enumerating!public! !
species!accessing!public! !
uncheckedAdd:!adding!private! !
uncheckedAt:put:!accessing!private! !
valuesClass!constants!public! !
!

