"Filed out from Dolphin Smalltalk 7"!

Core.Dictionary variableSubclass: #'Core.LookupTable'
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

anySatisfy: aMonadicValuable
	"Answer whether the <monadicValuable> argument evaluates to true for any element of the receiver."

	"Implementation note: Override to avoid superclass full-block implementation."

	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [(aMonadicValuable value: (values at: i)) ifTrue: [^true]]].
	^false!

associationAt: anObject ifAbsent: aNiladicValuable 
	"Answer a new <Association> between the key and value of the receiver at the first argument.
	If the key is not found, answer the result of evaluating the <niladicValuable> exception
	handler."

	"Implementation Note: LookupTables do not actually store key-value pairs in Associations, so
	the answer is not state information."

	| value |
	value := self at: anObject ifAbsent: [AbsentCookie].
	^value == AbsentCookie 
		ifTrue: [aNiladicValuable value]
		ifFalse: [self newAssociation: anObject value: value]!

associationsDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's 
	key/value associations.
	Implemenation Note: We must override because the receiver does not 
	actually contain Associations."

	self keysAndValuesDo: [:k :v | 
		operation value: (self associationClass key: k value: v)]!

at: anObject ifAbsent: aNiladicValuable 
	"Answer the value named by the key argument, anObject.  If the key is not found, 
	answer the result of evaluating the <niladicValuable> argument."

	| index |
	index := self findKeyOrNil: anObject.
	^(self basicAt: index) isNil ifTrue: [aNiladicValuable value] ifFalse: [values at: index]!

at: keyObject ifAbsentPutClean: aMonadicValuable
	"Answer the value of the receiver keyed by the first <Object> argument. If key is not one of the receiver's keys, then add the result of evaluating  the <niladicValuable> 2nd argument and answer that result.
	Note that unlike #at:ifAbsentPut:, this method assumes that the valuable does not modify the receiver, and therefore it only looks up the key position once. Thus it is more efficient but less general purpose."

	| index |
	keyObject isNil ifTrue: [^self error: 'key cannot be nil'].
	index := self findKeyOrNil: keyObject.
	^(self basicAt: index)
		ifNil: 
			[| value |
			value := aMonadicValuable value.
			values at: index put: value.
			self privateAt: index put: keyObject.
			value]
		ifNotNil: [values at: index]!

at: key put: newElement 
	"Store the argument newElement with the external key, key,
	in the receiver. Answer newElement."

	| index |
	key isNil ifTrue: [^self error: 'key cannot be nil'].
	index := self findKeyOrNil: key.
	"We must store the value first, as a resize may occur during privateAt:put:"
	values at: index put: newElement.
	(self basicAt: index) isNil ifTrue: [self privateAt: index put: key].
	^newElement!

basicValues
	"Private - Answer the <ArrayedCollection> of values in the receiver."

	^values!

bestSlotFor: element boundedBy: capacity
	^self hash: element max: capacity!

copyElementsInto: newMe
	"Private - Add the receiver's elements into the argument, newMe.
	Private part of the implementation of hashed collection resizing. Override
	to use keysAndValuesDo: to enumerate through the keys as well as the values."

	self keysAndValuesDo: [:key :value | newMe uncheckedAt: key put: value]
!

do: aMonadicValuable 
	"Evaluate <monadicValuable> argument, for each of the elements (values) 
	of the receiver. Answers the receiver."

	"Implementation Note: We could implement in terms of #keyAndValuesDo:, but 
	performance is important here."

	1 to: self basicSize
		do: [:i | (self basicAt: i) isNil ifFalse: [aMonadicValuable value: (values at: i)]]!

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

	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [:key | operation value: key value: (values at: i)]]!

keysDo: operation 
	"Evaluate the <monadicValuable>, operation, for each of the receiver's keys."

	1 to: self basicSize do: [:i | (self basicAt: i) ifNotNil: [:key | operation value: key]]!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver.
	Override for a small efficiency improvement that will only have any significant impact on performance in
	algorithms that rely heavily on dictionary lookup (which is fairly common)."

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

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self as: (STBIdentityDictionaryProxy forCollection: self)!

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
!Core.LookupTable categoriesFor: #add:!adding!public! !
!Core.LookupTable categoriesFor: #anySatisfy:!enumerating!public! !
!Core.LookupTable categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!Core.LookupTable categoriesFor: #associationsDo:!enumerating!public! !
!Core.LookupTable categoriesFor: #at:ifAbsent:!accessing!public! !
!Core.LookupTable categoriesFor: #at:ifAbsentPutClean:!accessing!public! !
!Core.LookupTable categoriesFor: #at:put:!accessing!public! !
!Core.LookupTable categoriesFor: #basicValues!accessing!private! !
!Core.LookupTable categoriesFor: #bestSlotFor:boundedBy:!development!private!statistics! !
!Core.LookupTable categoriesFor: #copyElementsInto:!adding!private! !
!Core.LookupTable categoriesFor: #do:!debugger-step through!enumerating!public! !
!Core.LookupTable categoriesFor: #findElementOrNil:!private!searching! !
!Core.LookupTable categoriesFor: #findKeyOrNil:!private!searching! !
!Core.LookupTable categoriesFor: #identityIncludes:!public!searching! !
!Core.LookupTable categoriesFor: #includesAssociation:!public!searching! !
!Core.LookupTable categoriesFor: #initialize!initializing!private! !
!Core.LookupTable categoriesFor: #isImmutable:!initializing!public! !
!Core.LookupTable categoriesFor: #keyAtEqualValue:ifAbsent:!accessing!public! !
!Core.LookupTable categoriesFor: #keyAtValue:ifAbsent:!accessing!public! !
!Core.LookupTable categoriesFor: #keysAndValuesDo:!enumerating!public! !
!Core.LookupTable categoriesFor: #keysDo:!enumerating!public! !
!Core.LookupTable categoriesFor: #lookup:!accessing!public! !
!Core.LookupTable categoriesFor: #moveFrom:to:!private!removing! !
!Core.LookupTable categoriesFor: #postCopy!copying!public! !
!Core.LookupTable categoriesFor: #removeKey:ifAbsent:!public!removing! !
!Core.LookupTable categoriesFor: #select:!enumerating!public! !
!Core.LookupTable categoriesFor: #species!accessing!public! !
!Core.LookupTable categoriesFor: #stbSaveOn:!binary filing!public! !
!Core.LookupTable categoriesFor: #uncheckedAdd:!adding!private! !
!Core.LookupTable categoriesFor: #uncheckedAt:put:!accessing!private! !
!Core.LookupTable categoriesFor: #valuesClass!constants!public! !

