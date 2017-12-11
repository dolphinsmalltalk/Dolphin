"Filed out from Dolphin Smalltalk 7"!

Collection subclass: #IniFileAbstract
	instanceVariableNames: 'filename'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IniFileAbstract guid: (GUID fromString: '{581771ef-b10d-40c8-a590-a926f4a57f5c}')!
IniFileAbstract comment: ''!
!IniFileAbstract categoriesForClass!Unclassified! !
!IniFileAbstract methodsFor!

= comparand
	^comparand class == self class
		and: [comparand filename sameAs: filename]!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation."

	^self at: anAssociation key put: anAssociation value!

at: anObject
	"Answer the value at the specified <String> key in the receiver, or if the key
	is not found raise a <NotFoundError>."

	| answer |
	answer := self at: anObject ifAbsent: [].
	^answer isNil ifTrue: [self errorKeyNotFound: anObject] ifFalse: [answer]!

at: key ifAbsent: operation
	self subclassResponsibility!

at: arg1 ifAbsentPut: arg2
	self subclassResponsibility!

at: keyString put: value
	self subclassResponsibility!

collect: transformer
	"Evaluate the monadic valuable argument, transformer, for each of the receiver's values.
	Answer a new collection like the receiver containing the same keys, and the values returned 
	by the transformer on each evaluation."

	| answer |
	answer := self copyLike.
	self keysAndValuesDo: [:key :value | answer at: key put: (transformer value: value)].
	^answer!

copySize
	"Private - Answer the size of empty copy to create when performing various
	copying/collecting transformations against the receiver. Can be overridden
	by subclasses for which #size is a slow operation."

	^self approxSize!

countElements
	"Private - Count, and answer, the number of elements in the receiver."

	| tally |
	tally := 0.
	self keysDo: [:each | tally := tally + 1].
	^tally!

do: operation
	"Evaluate <monadicValuable> argument, operation, for each of the sections of the 
	initialization file. Answers the receiver."

	self keysDo: [:each | operation value: (self getValue: each)]!

errorKeyNotFound: aKey
	"Private - Report that an attempt was made to look up a key which was not in the receiver"

	^self errorNotFound: aKey
!

errorValueNotFound: aValue
	"Private - Report that an attempt was made to look up the key for a value which was not
	in receiver"

	^self error: ('value not found: <1p>' expandMacrosWith: aValue)
!

filename
	"Answer the filename of the initialization file."

	^filename!

filename: aString
	filename := aString!

getValue: aString
	^self subclassResponsibility!

hash
	^filename hash!

includesKey: anObject 
	"Answer whether the receiver has a key equal to the <Object>
	argument."

	^(self at: anObject ifAbsent: []) notNil!

isEmpty
	^self keys isEmpty!

keyAtValue: value 
	"Answer the <Object> key of the <Object> argument, value. 
	If there is no such value, send #errorValueNotFound: to the receiver with 
	value as its argument.
	N.B. Since values are not necessarily unique, answer the name of the first 
	one encountered in the search."

	| key |
	key := self keyAtValue: value ifAbsent: [].
	^key isNil ifTrue: [self errorValueNotFound: value] ifFalse: [key]!

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
	"Answer a <sequencedReadableCollection> containing the names of the the sections in the receiver's initialization file."

	| answer |
	answer := Array writeStream.
	self keysDo: [:key | answer nextPut: key].
	^answer contents!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each section in the initialization file.
	The key/values pairs are visited in the section order of that file."

	self keysDo: [:each | operation value: each value: (self getValue: each)]!

keysDo: operation
	"Evaluate the <monadicValuable>, operation, for each of the receiver's keys."

	^self subclassResponsibility!

removeAllKeys: keys
	"Remove any elements from the receiver with the keys in the <collection> argument, keys.
	If any of the keys are not present in the receiver, or there are duplicates in
	keys, then raise an exception."

	keys do: [:k | self removeKey: k]!

removeAllKeys: keys ifAbsent: operation
	"Remove any elements from the receiver with the keys in the <collection>
	argument, keys. If any of the keys are not present in the receiver, or there 
	are duplicates in keys, then evaluate the <niladicValuable> argument, 
	operation, but do not stop the enumeration."

	keys do: [:k | self removeKey: k ifAbsent: operation]!

removeKey: keyString
	"Remove the <String> key (and its associated value), from the receiver. 
	If key is not in the receiver, report an error. Otherwise, answer the value 
	named by the key."

	| removed |
	removed := self removeKey: keyString ifAbsent: [].
	^removed isNil ifTrue: [self errorKeyNotFound: keyString] ifFalse: [removed]!

removeKey: keyString ifAbsent: aNiladicValuable
	"Remove the <Object> key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the <niladicValuable>,
	operation. Otherwise, answer the value named by key."

	^self subclassResponsibility!

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
	^LookupTable!

values
	"Answer a <collection> containing the receiver's <IniFileSection> values in the order in
	which they appear in the file."

	| values |
	values := Array writeStream.
	self do: [:each | values nextPut: each].
	^values contents! !
!IniFileAbstract categoriesFor: #=!comparing!public! !
!IniFileAbstract categoriesFor: #add:!public! !
!IniFileAbstract categoriesFor: #at:!accessing!public! !
!IniFileAbstract categoriesFor: #at:ifAbsent:!accessing!public! !
!IniFileAbstract categoriesFor: #at:ifAbsentPut:!public! !
!IniFileAbstract categoriesFor: #at:put:!adding!public! !
!IniFileAbstract categoriesFor: #collect:!enumerating!public! !
!IniFileAbstract categoriesFor: #copySize!copying!private! !
!IniFileAbstract categoriesFor: #countElements!accessing!private! !
!IniFileAbstract categoriesFor: #do:!enumerating!public! !
!IniFileAbstract categoriesFor: #errorKeyNotFound:!exceptions!private! !
!IniFileAbstract categoriesFor: #errorValueNotFound:!exceptions!private! !
!IniFileAbstract categoriesFor: #filename!accessing!public! !
!IniFileAbstract categoriesFor: #filename:!initializing!private! !
!IniFileAbstract categoriesFor: #getValue:!helpers!private! !
!IniFileAbstract categoriesFor: #hash!comparing!public! !
!IniFileAbstract categoriesFor: #includesKey:!public!searching! !
!IniFileAbstract categoriesFor: #isEmpty!public! !
!IniFileAbstract categoriesFor: #keyAtValue:!accessing!public! !
!IniFileAbstract categoriesFor: #keyAtValue:ifAbsent:!accessing!public! !
!IniFileAbstract categoriesFor: #keys!accessing!public! !
!IniFileAbstract categoriesFor: #keysAndValuesDo:!enumerating!public! !
!IniFileAbstract categoriesFor: #keysDo:!public! !
!IniFileAbstract categoriesFor: #removeAllKeys:!public!removing! !
!IniFileAbstract categoriesFor: #removeAllKeys:ifAbsent:!public!removing! !
!IniFileAbstract categoriesFor: #removeKey:!public!removing! !
!IniFileAbstract categoriesFor: #removeKey:ifAbsent:!public! !
!IniFileAbstract categoriesFor: #select:!enumerating!public! !
!IniFileAbstract categoriesFor: #species!accessing!public! !
!IniFileAbstract categoriesFor: #values!accessing!public! !

IniFileAbstract methodProtocol: #abstractDictionary attributes: #(#ansi #readOnly) selectors: #(#addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:ifAbsentPut: #at:put: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #includesKey: #inject:into: #isEmpty #keyAtValue: #keyAtValue:ifAbsent: #keys #keysAndValuesDo: #keysDo: #notEmpty #occurrencesOf: #rehash #reject: #removeAllKeys: #removeAllKeys:ifAbsent: #removeKey: #removeKey:ifAbsent: #select: #size #values)!

!IniFileAbstract class methodsFor!

open: aString
	"Answer the the new instance of the receiver for reading/writing the .ini file 
	with the specified path."

	^self new 
		filename: aString! !
!IniFileAbstract class categoriesFor: #open:!instance creation!public! !

