"Filed out from Dolphin Smalltalk 7"!

Core.Set variableSubclass: #'Core.Dictionary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Dictionary guid: (Core.GUID fromString: '{87b4c526-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Dictionary comment: 'Class Dictionary represents a set of associations between keys and values. The values can be randomly accessed using the associated key. 

The elements of a Dictionary are instances of <Association>, a simple data structure for storing and retrieving the members of a key-value pair.

Conforms to the following ANSI protocols:
	collection
	abstractDictionary
	Dictionary'!
!Core.Dictionary categoriesForClass!Collections-Unordered! !
!Core.Dictionary methodsFor!

_deepCopyElementsInto: aDictionary trail: anIdentityDictionary 
	self 
		associationsDo: [:element | aDictionary uncheckedAdd: (element _deepCopy: anIdentityDictionary)]!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand. Dictionaries are
	equal to other dictionary-like objects with the equal keys and values."

	comperand == self ifTrue: [^true].
	(comperand class conformsToProtocol: #abstractDictionary) ifFalse: [^false].
	comperand size == self size ifFalse: [^false].
	self
		keysAndValuesDo: [:key :value | (comperand at: key ifAbsent: [^false]) = value ifFalse: [^false]].
	^true!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation.
	Although very similar to at:put:, we store the actual association passed
	as an argument here in order to maintain its references."

	| index element |
	index := self findKeyOrNil: anAssociation key.
	element := self basicAt: index.
	element isNil
		ifTrue: [self privateAt: index put: anAssociation]
		ifFalse: [element value: anAssociation value].
	^anAssociation!

addNewElement: anAssociation
	"Include the <Association> newElement as one of the elements of the receiver, or update the value of the existing association with the same key.
	Answer true if the association was not already a member of the set (i.e. it was really added), else false (the existing association was updated)."

	| index |
	index := self findKeyOrNil: anAssociation key.
	^(self basicAt: index)
		ifNil: 
			[self privateAt: index put: anAssociation.
			true]
		ifNotNil: 
			[:element |
			element value: anAssociation value.
			false]!

asSet
	"Answer a Set whose elements are the values stored in the receiver (any 
	duplicates are therefore eliminated).
	Revert to the Collection implementation."

	^(Set new: self size)
		addAll: self;
		yourself!

associationAt: key
	"Answer the association named by the argument, key.  If key is not found,
	raise an exception."

	^(self associationAt: key ifAbsent: [])
		ifNil: [self errorKeyNotFound: key]
		ifNotNil: [:assoc | assoc]!

associationAt: key ifAbsent: exceptionHandler 
	"Answer the association named by the argument, key. If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler."

	^(self basicAt: (self findKeyOrNil: key)) ifNil: [exceptionHandler value]!

associationAt: key ifPresent: operation
	"Answer the result of evaluating the monadic valuable, operation, if
	the argument, key, is the key of an element in the receiver, with that
	key and element pair as its argument. If the key is not present, then 
	answer nil."

	^(self associationAt: key ifAbsent: []) ifNotNil: [:assoc | operation value: assoc]!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."

	^Association!

associations
	"Answer an OrderedCollection containing the receiver's associations"

	| answer |
	answer := OrderedCollection new: self size.
	self associationsDo: [:assoc | answer addLast: assoc].
	^answer!

associationsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument, for each of the receiver's key/value mappings."

	tally == 0 ifTrue: [^self].
	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [:element | aMonadicValuable value: element]]!

associationsDo: aMonadicValuable separatedBy: aNiladicValuable 
	"Evaluate the <monadicValuable> operation argument for each of the 
	{key,value} associations in the receiver, interspersed with evaluations of 
	the <niladicValuable> separator argument. The separator is first evaluated after the first
	association, and is not evaluated after the last association (i.e. it is not evaluated
	at all if there are less than two associations)."

	| separator |
	separator := [separator := aNiladicValuable].	"Switch to the real separator after first eval."
	self associationsDo: 
			[:each | 
			separator value.
			aMonadicValuable value: each]!

at: anObject 
	"Answer the value at the specified <Object> key in the receiver, or if the key
	is not found raise a <NotFoundError>."

	"Implementation Note: This is not the obvious implementation, but is ~20% 
	faster since it the ifAbsent: argument is a static rather than a copying block.
	This is a worthwhile gain in such a commonly used method."

	| answer |
	answer := self at: anObject ifAbsent: [AbsentCookie].
	^answer == AbsentCookie ifTrue: [self errorKeyNotFound: anObject] ifFalse: [answer]!

at: key ifAbsent: operation 
	"Answer the value named by the <Object> argument, key.  If key is not found,
	answer the result of evaluating the <niladicValuable>, operation."

	^(self basicAt: (self findKeyOrNil: key)) 
		ifNil: [operation value]
		ifNotNil: [:element | element value]!

at: key ifAbsentPut: operation 
	"Answer the value of the receiver keyed by the <Object> argument, key.
	If key is not one of the receiver's keys, then add the result of evaluating 
	the <niladicValuable>, operation, at key, and answer that result."

	"Implementation Note: The operation might modify the collection, therefore we can't optimize
	but must perform the hash key lookup twice."

	| preexisting |
	preexisting := self at: key ifAbsent: [AbsentCookie].
	^preexisting == AbsentCookie ifTrue: [self at: key put: operation value] ifFalse: [preexisting]!

at: keyObject ifAbsentPutClean: aMonadicValuable
	"Answer the value of the receiver keyed by the first <Object> argument. If key is not one of the receiver's keys, then add the result of evaluating  the <niladicValuable> 2nd argument and answer that result.
	Note that unlike #at:ifAbsentPut:, this method assumes that the valuable does not modify the receiver, and therefore it only looks up the key position once. Thus it is more efficient but less general purpose."

	| index |
	keyObject isNil ifTrue: [^self error: 'key cannot be nil'].
	index := self findKeyOrNil: keyObject.
	^((self basicAt: index)
		ifNil: [self privateAt: index put: (self newAssociation: keyObject value: aMonadicValuable value)])
			value!

at: keyObject ifAbsentPutValue: valueObject
	"Answer the value of the receiver keyed by the <Object> argument, keyObject.
	If keyObject is not one of the receiver's keys, then add the <Object>, valueObject,
	at keyObject, and answer valueObject."

	| preexisting |
	preexisting := self at: keyObject ifAbsent: [AbsentCookie].
	^preexisting == AbsentCookie ifTrue: [self at: keyObject put: valueObject] ifFalse: [preexisting]!

at: key ifPresent: operation 
	"Answer the result of evaluating the monadic valuable, operation, if
	the argument, key, is the key of an element in the receiver, with that
	element as its argument. If the key is not present, then answer nil."

	| value |
	value := self at: key ifAbsent: [AbsentCookie].
	^value == AbsentCookie ifFalse: [operation value: value]!

at: keyObject put: valueObject
	"Store the <Object> argument valueObject at the <Object> keyObject, in the receiver. Answer
	valueObject."

	| index |
	keyObject isNil ifTrue: [^self error: 'key cannot be nil'].
	index := self findKeyOrNil: keyObject.
	(self basicAt: index)
		ifNil: [self privateAt: index put: (self newAssociation: keyObject value: valueObject)]
		ifNotNil: [:assoc | assoc value: valueObject].
	^valueObject!

atAll: keys put: newElement
	"Replace the elements of the receiver at each of the keys in the <collection> 
	argument, keys, with the <Object> argument, newElement."

	keys do: [:key | self at: key put: newElement]!

bestSlotFor: element boundedBy: capacity
	^self hash: element key max: capacity!

bindingFor: aString
	"Answer the association in the receiver whose key is equal to the argument, or nil if there is no association with that key."

	^self basicAt: (self findKeyOrNil: aString)!

bindingsDo: aMonadicValuable
	self associationsDo: aMonadicValuable!

changeKey: key to: newKey 
	"Private - Change the key of the element of the receiver with key, key, to
	newKey (e.g. rename a variable). Answer the <Association> whose
	whose key was changed."

	| assoc |
	assoc := self associationAt: key.
	self removeKey: key.
	assoc setKey: newKey.
	"We want to preserve the association of the element we're renaming, so we must
	 remove any existing element with the same name"
	self removeKey: newKey ifAbsent: [].
	self add: assoc.
	^assoc!

collect: transformer
	"Evaluate the monadic valuable argument, transformer, for each of the receiver's values.
	Answer a new collection like the receiver containing the same keys, and the values returned 
	by the transformer on each evaluation.
	N.B. Most Smalltalks implement this differently (each with their own, inconsistent, approaches)
	This is the ANSI Smalltalk definition."

	| answer |
	answer := self copyLike.
	self keysAndValuesDo: [:key :value | answer at: key put: (transformer value: value)].
	^answer!

copyElementsInto: newMe
	"Private - Add the receiver's elements into the argument, newMe.
	Part of the implementation of hashed collection resizing. Override
	to use associationsDo: to preserve the existing associations."

	self associationsDo: [:element | newMe uncheckedAdd: element]!

do: operation 
	"Evaluate <monadicValuable> argument, operation, for each of the element of the 
	receiver. Answers the receiver.
	Implementation Note: Could use #associationsDo: (or keysAndValuesDo:), but 
	performance important here."

	1 to: self basicSize
		do: 
			[:i | 
			| element |
			(element := self basicAt: i) isNil ifFalse: [operation value: element value]]!

errorKeyNotFound: aKey
	"Private - Report that an attempt was made to look up a key which was not in the receiver"

	^self errorNotFound: aKey
!

findElementOrNil: anAssociation
	"Private - Answer the index of the element with the a key equivalent to that
	of anAssociation. The elements of the receiver are Associations, so we look up
	by anAssociation's key."

	^self findKeyOrNil: anAssociation key!

findKeyOrNil: anObject
	"Private - Answer the index of the given key in the receiver, or, if not found,
	the index of the first empty slot including and after that to which the key hashes"

	| capacity index |
	capacity := self basicSize.
	index := anObject hash \\ capacity + 1.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject = element key]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

identityIncludes: anObject 
	"Answer whether the argument, anObject, is one of the receiver's elements."

	"Implementation Note: Set implementation will not work because the elements 
	are <Association>s, and we want to find an identitcal value."

	^self anySatisfy: [:each | anObject == each]!

includes: anObject 
	"Answer whether the argument, target, is one of the elements of the receiver."

	"Implementation Note: Set implementation will not work because the elements 
	are <Association>s, and we want to find an equal value."

	^self anySatisfy: [:each | anObject = each]!

includesAssociation: anAssociation 
	"Answer whether the receiver has an element (association between a key
	and a value) that is equal to the argument, anAssociation"

	| assoc |
	assoc := self associationAt: anAssociation key ifAbsent: [AbsentCookie].
	^assoc ~~ AbsentCookie and: [assoc value = anAssociation value]!

includesKey: anObject 
	"Answer whether the receiver has a key equal to the <Object> argument."

	^(self basicAt: (self findKeyOrNil: anObject)) notNil!

keyAtEqualValue: anObject ifAbsent: aNiladicValuable 
	"Answer the key of the <Object> value argument. If there is no such value, answer
	the result of evaluating the <niladicValuable> argument.
	Equality is used for comparison of the values (this increases the chances of 
	returning any duplicates the Dictionary might contain)."

	self keysAndValuesDo: [:eachKey :eachValue | anObject = eachValue ifTrue: [^eachKey]].
	^aNiladicValuable value!

keyAtValue: value 
	"Answer the <Object> key of the <Object> argument, value. 
	If there is no such value, send #errorValueNotFound: to the receiver with 
	value as its argument.
	N.B. Since values are not necessarily unique, answer the name of the first 
	one encountered in the search."

	| key |
	key := self keyAtValue: value ifAbsent: [AbsentCookie].
	^key == AbsentCookie ifTrue: [self errorValueNotFound: value] ifFalse: [key]!

keyAtValue: anObject ifAbsent: aNiladicValuable 
	"Answer the <Object> key of the <Object> value argument. 
	If there is no such value, answer the result of evaluating the 
	<niladicValuable> argument.
	N.B. Identity is used for comparison of the values, but see also
	#keyAtEqualValue:ifAbsent:"

	#todo.	"ANSI standard states that #= be used rather than #==, but long established standard is the latter"
	self keysAndValuesDo: [:eachKey :eachValue | eachValue == anObject ifTrue: [^eachKey]].
	^aNiladicValuable value!

keys
	"Answer a <collection> containing the receiver's keys.
	Implementation Note: We answer a <Set>, but that should
	not be relied upon in portable code."

	| aSet |
	aSet := self keysClass new: self size.
	self keysDo: [:key | aSet add: key].
	^aSet!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver.
	The key/values pairs are visited in an arbitray order.
	Implementation Note: Could use #associationsDo:, but performance important here."

	1 to: self basicSize
		do: 
			[:i | 
			| element |
			(element := self basicAt: i) isNil 
				ifFalse: [operation value: element key value: element value]]!

keysClass
	"Private - Answer the class of Collection to be used for collecting the keys of the receiver"

	^Set!

keysDo: operation
	"Evaluate the <monadicValuable>, operation, for each of the receiver's keys."

	self keysAndValuesDo: [:key :value | operation value: key]!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver.
	Clearly if the receiver can contain nil values then it will not be possible to distinguish between the absence
	of the key and the key being associated with a nil value. However, this method expresses the
	very common pattern of passing an empty block as absent handler to #at:ifAbsent:, e.g.
		(dict at: key ifAbsent: []) ifNotNil: [:value | value ...]"

	^(self basicAt: (self findKeyOrNil: keyObject)) ifNotNil: [:element | element value]!

newAssociation: keyObject value: valueObject 
	^self associationClass key: keyObject value: valueObject!

occurrencesOf: anObject 
	"Answer the number of the receiver's values which are equal to the argument."

	"Implementation Note: Override back to the Collection implementation as 
	dictionaries can contain duplicate values."

	| count |
	count := 0.
	self do: [:element | element = anObject ifTrue: [count := count + 1]].
	^count!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. For dictionaries this
	requires that we make copies of the associations as otherwise modifications to the source
	dictionary will affect the copy, and vice versa"

	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [:assoc | self basicAt: i put: assoc copy]]!

printOn: aStream
	"Print a string representation of self on aStream. 
	We must override because we'd like to print out the associations as this
	is more useful, otherwise this is the same as the superclass implementation."

	aStream visit: self
		do: 
			[aStream
				basicPrint: self;
				nextPut: $(.
			self associationsDo: [:each | each printOn: aStream] separatedBy: [aStream space].
			aStream nextPut: $)]!

remove: anObject ifAbsent: aBlock
	"Elements of Dictionaries must be removed by key."

	^self shouldNotImplement
!

removeAllKeys: keys
	"Remove any elements from the receiver with the keys in the <collection> argument, keys.
	If any of the keys are not present in the receiver, or there are duplicates in
	keys, then raise an exception."

	keys do: [:k | self removeKey: k]!

removeAllKeys: keys ifAbsent: operation
	"Remove any elements from the receiver with the keys in the <collection> argument, keys. If any of the keys are not present in the receiver, or there are duplicates in keys, then evaluate the <niladicValuable>|<monadicValuable> argument, operation, but do not stop the enumeration."

	keys do: [:k | self removeKey: k ifAbsent: [operation cull: k]]!

removeAssociation: anAssociation
	"Remove the key and value association, anAssociation, from the receiver. Answer anAssociation."

	self removeKey: anAssociation key.
	^anAssociation
!

removeAssociation: anAssociation ifAbsent: aNiladicValuable
	"Remove the <association> from the receiver with the same key as the <association> argument.
	Answer anAssociation. If there is no such association in the receiver, answer the result of
	evaluating the <niladicValuable>, operation."

	^(self removeKey: anAssociation key ifAbsent: [AbsentCookie]) == AbsentCookie
		ifTrue: [aNiladicValuable value]
		ifFalse: [anAssociation]!

removeKey: key 
	"Remove the <Object> key (and its associated value), from the receiver. 
	If key is not in the receiver, report an error. Otherwise, answer the value 
	named by key."

	| removed |
	removed := self removeKey: key ifAbsent: [AbsentCookie].
	^removed == AbsentCookie ifTrue: [self errorKeyNotFound: key] ifFalse: [removed]!

removeKey: key ifAbsent: operation 
	"Remove the <Object> key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the <niladicValuable>,
	operation. Otherwise, answer the value named by key."

	| index |
	index := self findKeyOrNil: key.
	^(self basicAt: index) 
		ifNil: [operation value]
		ifNotNil: 
			[:element | 
			self removeIndex: index.
			element value]!

searchPolicy
	"Answer the receiver's <searchPolicy>."

	^SearchPolicy equality!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements.
	Answer a new Collection like the receiver containing only those elements for which 
	the discriminator evaluates to true.
	Implementation Note: Override to maintain both keys and values, and to use the same
	Associations where possible."

	| answer |
	answer := self newSelection.
	self associationsDo: 
			[:assoc | 
			(discriminator value: assoc value) ifTrue: [answer add: assoc]].
	^answer!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self
		as: (STBCollectionProxy class: self class array: self associations asArray)!

storeOn: aStream 
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	| first |
	aStream nextPutAll: '(('.
	self class storeOn: aStream.
	aStream nextPutAll: ' new)'.
	first := true.
	self keysAndValuesDo: [:key :value |
		first
			ifTrue: [first := false]
			ifFalse: [aStream nextPut: $;].
		aStream nextPutAll: ' at: '.
		key storeOn: aStream.
		aStream nextPutAll: ' put: '.
		value storeOn: aStream].
	first ifFalse: [aStream nextPutAll: '; yourself'].
	aStream nextPut: $)!

values
	"Answer a <collection> containing the receiver's values (includes any duplicates)."

	| answer |
	answer := OrderedCollection new: self size.
	self do: [:value | answer addLast: value].
	^answer! !
!Core.Dictionary categoriesFor: #_deepCopyElementsInto:trail:!copying!private! !
!Core.Dictionary categoriesFor: #=!comparing!public! !
!Core.Dictionary categoriesFor: #add:!adding!public! !
!Core.Dictionary categoriesFor: #addNewElement:!adding!public! !
!Core.Dictionary categoriesFor: #asSet!converting!public! !
!Core.Dictionary categoriesFor: #associationAt:!accessing!public! !
!Core.Dictionary categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!Core.Dictionary categoriesFor: #associationAt:ifPresent:!accessing!public! !
!Core.Dictionary categoriesFor: #associationClass!constants!private! !
!Core.Dictionary categoriesFor: #associations!accessing!public! !
!Core.Dictionary categoriesFor: #associationsDo:!enumerating!public! !
!Core.Dictionary categoriesFor: #associationsDo:separatedBy:!enumerating!public! !
!Core.Dictionary categoriesFor: #at:!accessing!public! !
!Core.Dictionary categoriesFor: #at:ifAbsent:!accessing!public! !
!Core.Dictionary categoriesFor: #at:ifAbsentPut:!accessing!public! !
!Core.Dictionary categoriesFor: #at:ifAbsentPutClean:!accessing!public! !
!Core.Dictionary categoriesFor: #at:ifAbsentPutValue:!accessing!public! !
!Core.Dictionary categoriesFor: #at:ifPresent:!accessing!public! !
!Core.Dictionary categoriesFor: #at:put:!accessing!public! !
!Core.Dictionary categoriesFor: #atAll:put:!accessing!public! !
!Core.Dictionary categoriesFor: #bestSlotFor:boundedBy:!development!private!statistics! !
!Core.Dictionary categoriesFor: #bindingFor:!binding!public! !
!Core.Dictionary categoriesFor: #bindingsDo:!enumerating!public! !
!Core.Dictionary categoriesFor: #changeKey:to:!accessing!private! !
!Core.Dictionary categoriesFor: #collect:!enumerating!public! !
!Core.Dictionary categoriesFor: #copyElementsInto:!adding!private! !
!Core.Dictionary categoriesFor: #do:!enumerating!public! !
!Core.Dictionary categoriesFor: #errorKeyNotFound:!exceptions!private! !
!Core.Dictionary categoriesFor: #findElementOrNil:!private!searching! !
!Core.Dictionary categoriesFor: #findKeyOrNil:!private!searching! !
!Core.Dictionary categoriesFor: #identityIncludes:!public!searching! !
!Core.Dictionary categoriesFor: #includes:!public!searching! !
!Core.Dictionary categoriesFor: #includesAssociation:!public!searching! !
!Core.Dictionary categoriesFor: #includesKey:!public!searching! !
!Core.Dictionary categoriesFor: #keyAtEqualValue:ifAbsent:!accessing!public! !
!Core.Dictionary categoriesFor: #keyAtValue:!accessing!public! !
!Core.Dictionary categoriesFor: #keyAtValue:ifAbsent:!accessing!public! !
!Core.Dictionary categoriesFor: #keys!accessing!public! !
!Core.Dictionary categoriesFor: #keysAndValuesDo:!enumerating!public! !
!Core.Dictionary categoriesFor: #keysClass!constants!private! !
!Core.Dictionary categoriesFor: #keysDo:!enumerating!public! !
!Core.Dictionary categoriesFor: #lookup:!accessing!public! !
!Core.Dictionary categoriesFor: #newAssociation:value:!helpers!private! !
!Core.Dictionary categoriesFor: #occurrencesOf:!public!searching! !
!Core.Dictionary categoriesFor: #postCopy!copying!public! !
!Core.Dictionary categoriesFor: #printOn:!printing!public! !
!Core.Dictionary categoriesFor: #remove:ifAbsent:!public!removing! !
!Core.Dictionary categoriesFor: #removeAllKeys:!public!removing! !
!Core.Dictionary categoriesFor: #removeAllKeys:ifAbsent:!public!removing! !
!Core.Dictionary categoriesFor: #removeAssociation:!public!removing! !
!Core.Dictionary categoriesFor: #removeAssociation:ifAbsent:!public!removing! !
!Core.Dictionary categoriesFor: #removeKey:!public!removing! !
!Core.Dictionary categoriesFor: #removeKey:ifAbsent:!public!removing! !
!Core.Dictionary categoriesFor: #searchPolicy!constants!public! !
!Core.Dictionary categoriesFor: #select:!enumerating!public! !
!Core.Dictionary categoriesFor: #stbSaveOn:!binary filing!public! !
!Core.Dictionary categoriesFor: #storeOn:!printing!public! !
!Core.Dictionary categoriesFor: #values!accessing!public! !

Core.Dictionary methodProtocol: #abstractDictionary attributes: #(#ansi #readOnly) selectors: #(#addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:ifAbsentPut: #at:put: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #includesKey: #inject:into: #isEmpty #keyAtValue: #keyAtValue:ifAbsent: #keys #keysAndValuesDo: #keysDo: #notEmpty #occurrencesOf: #rehash #reject: #removeAllKeys: #removeAllKeys:ifAbsent: #removeKey: #removeKey:ifAbsent: #select: #size #values)!
Core.Dictionary methodProtocol: #Dictionary attributes: #(#ansi #readOnly) selectors: #(#addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:ifAbsentPut: #at:put: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #includesKey: #inject:into: #isEmpty #keyAtValue: #keyAtValue:ifAbsent: #keys #keysAndValuesDo: #keysDo: #notEmpty #occurrencesOf: #rehash #reject: #removeAllKeys: #removeAllKeys:ifAbsent: #removeKey: #removeKey:ifAbsent: #select: #size #values)!

Core.Dictionary class methodProtocol: #'Dictionary factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #withAll:)!

