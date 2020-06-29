"Filed out from Dolphin Smalltalk 7"!

Collection subclass: #IniFileAbstract
	instanceVariableNames: 'filename'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IniFileAbstract guid: (GUID fromString: '{581771ef-b10d-40c8-a590-a926f4a57f5c}')!
IniFileAbstract isAbstract: true!
IniFileAbstract comment: ''!
!IniFileAbstract categoriesForClass!Unclassified! !
!IniFileAbstract methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, are considered equivalent."

	^comparand class == self class
		and: [comparand filename sameAs: filename]!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation."

	self at: anAssociation key put: anAssociation value.
	^anAssociation!

associationAt: aString
	"Answer an <Association> with the specified key and the associated value from the receiver.
	If the key is not found, raise an exception."

	^(self associationAt: aString ifAbsent: [])
		ifNil: [self errorKeyNotFound: aString]
		ifNotNil: [:assoc | assoc]!

associationAt: anObject ifAbsent: aNiladicValuable
	"Answer a new <Association> between the key and value of the receiver at the first argument.
	If the key is not found, answer the result of evaluating the <niladicValuable> exception
	handler."

	"Implementation Note: IniFiles do not actually store key-value pairs in Associations, so
	the answer is not state information."

	| value |
	value := self at: anObject ifAbsent: [AbsentCookie].
	^value == AbsentCookie ifTrue: [aNiladicValuable value] ifFalse: [anObject -> value]!

associations
	"Answer a <sequencedReadableCollection> of <Association>s representing the key-value pairs in the receiver."

	| stream |
	stream := Array writeStream.
	self associationsDo: [:assoc | stream nextPut: assoc].
	^stream contents!

associationsDo: aMonadicValuable
	"Evalue the <MonadicValuable> argument for each of the receiver's key-value pairs."

	self keysAndValuesDo: [:eachKey :eachValue | aMonadicValuable value: eachKey -> eachValue]!

at: aString
	"Answer the value at the specified <String> key in the receiver, or if the key
	is not found raise a <NotFoundError>."

	| answer |
	answer := self at: aString ifAbsent: [AbsentCookie].
	^answer == AbsentCookie ifTrue: [self errorKeyNotFound: aString] ifFalse: [answer]!

at: aString ifAbsent: aNiladicValuable
	"Answer the value of the receiver named by the key argument, aString.  If the key is not found, 
	answer the result of evaluating the <niladicValuable> argument."

	^self subclassResponsibility!

at: aString ifAbsentPut: aNiladicValuable
	"Answer the value of the receiver keyed by the <String> argument, or if not found add and
	answer the result of result of evaluating the <niladicValuable>, argument."

	| preexisting |
	preexisting := self at: aString ifAbsent: [AbsentCookie].
	^preexisting == AbsentCookie
		ifTrue: [self at: aString put: aNiladicValuable value]
		ifFalse: [preexisting]!

at: aString put: value
	^self subclassResponsibility!

collect: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's values. Answer a new
	collection like the receiver containing the same keys, and the values returned by the
	transformer on each evaluation."

	| answer |
	answer := self copyLike.
	self keysAndValuesDo: [:key :value | answer at: key put: (aMonadicValuable value: value)].
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

includesKey: aString
	"Answer whether the receiver has a key equal to the <Object>
	argument."

	^(self at: aString ifAbsent: [AbsentCookie]) ~~ AbsentCookie!

isEmpty
	"Answer whether the receiver contains no elements."

	^self keys isEmpty!

keyAtValue: value
	"Answer the <String> key of the <Object> argument, value. 
	If there is no such value, send #errorValueNotFound: to the receiver with 
	value as its argument.
	N.B. Since values are not necessarily unique, answer the name of the first 
	one encountered in the search."

	| key |
	key := self keyAtValue: value ifAbsent: [AbsentCookie].
	^key == AbsentCookie ifTrue: [self errorValueNotFound: value] ifFalse: [key]!

keyAtValue: anObject ifAbsent: aNiladicValuable
	"Answer the <String> key of the <Object> value argument. 
	If there is no such value, answer the result of evaluating the 
	<niladicValuable> argument.
	N.B. Identity is used for comparison of the values, but see also
	#keyAtEqualValue:ifAbsent:"

	self keysAndValuesDo: [:eachKey :eachValue | eachValue == anObject ifTrue: [^eachKey]].
	^aNiladicValuable value!

keys
	"Answer a <sequencedReadableCollection> of <String> being the receiver's keys."

	| answer |
	answer := Array writeStream.
	self keysDo: [:key | answer nextPut: key].
	^answer contents!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable> arguemnt for each of the receiver's key-value pairs."

	self keysDo: [:each | aDyadicValuable value: each value: (self getValue: each)]!

keysDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's keys."

	^self subclassResponsibility!

lookup: aString
	"Answer the <String> value named by the <String> argument, or nil if there is no such key in the receiver."

	^self getValue: aString shallowCopy!

removeAllKeys: keys
	"Remove any elements from the receiver with the keys in the <collection> argument, keys.
	If any of the keys are not present in the receiver, or there are duplicates in
	keys, then raise an exception."

	keys do: [:k | self removeKey: k]!

removeAllKeys: keys ifAbsent: operation
	"Remove any elements from the receiver with the keys in the <collection> argument, keys. If
	any of the keys are not present in the receiver, or there are duplicates in keys, then
	evaluate the <niladicValuable>|<monadicValuable> argument, operation, but do not stop the
	enumeration."

	keys do: [:k | self removeKey: k ifAbsent: [operation cull: k]]!

removeKey: keyString
	"Remove the <String> key (and its associated value), from the receiver. 
	If key is not in the receiver, report an error. Otherwise, answer the value 
	named by the key."

	| removed |
	removed := self removeKey: keyString ifAbsent: [AbsentCookie].
	^removed == AbsentCookie ifTrue: [self errorKeyNotFound: keyString] ifFalse: [removed]!

removeKey: aString ifAbsent: aNiladicValuable
	"Remove the <String> key (and its associated value), from the receiver. If key is
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
	"Answer the preferred class of the receiver for returning the results of projections, etc."

	^LookupTable!

values
	"Answer a <seequencedReadableCollection> containing the receiver's values."

	| values |
	values := Array writeStream.
	self do: [:each | values nextPut: each].
	^values contents! !
!IniFileAbstract categoriesFor: #=!comparing!public! !
!IniFileAbstract categoriesFor: #add:!adding!public! !
!IniFileAbstract categoriesFor: #associationAt:!accessing!public! !
!IniFileAbstract categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!IniFileAbstract categoriesFor: #associations!accessing!public! !
!IniFileAbstract categoriesFor: #associationsDo:!enumerating!public! !
!IniFileAbstract categoriesFor: #at:!accessing!public! !
!IniFileAbstract categoriesFor: #at:ifAbsent:!accessing!public! !
!IniFileAbstract categoriesFor: #at:ifAbsentPut:!accessing!public! !
!IniFileAbstract categoriesFor: #at:put:!adding!public! !
!IniFileAbstract categoriesFor: #collect:!enumerating!public! !
!IniFileAbstract categoriesFor: #copySize!copying!private! !
!IniFileAbstract categoriesFor: #countElements!accessing!private! !
!IniFileAbstract categoriesFor: #do:!enumerating!public! !
!IniFileAbstract categoriesFor: #errorKeyNotFound:!exceptions!private! !
!IniFileAbstract categoriesFor: #errorValueNotFound:!exceptions!private! !
!IniFileAbstract categoriesFor: #filename!accessing!public! !
!IniFileAbstract categoriesFor: #filename:!initializing!private! !
!IniFileAbstract categoriesFor: #getValue:!accessing!private! !
!IniFileAbstract categoriesFor: #hash!comparing!public! !
!IniFileAbstract categoriesFor: #includesKey:!public!searching! !
!IniFileAbstract categoriesFor: #isEmpty!public!testing! !
!IniFileAbstract categoriesFor: #keyAtValue:!accessing!public! !
!IniFileAbstract categoriesFor: #keyAtValue:ifAbsent:!accessing!public! !
!IniFileAbstract categoriesFor: #keys!accessing!public! !
!IniFileAbstract categoriesFor: #keysAndValuesDo:!enumerating!public! !
!IniFileAbstract categoriesFor: #keysDo:!enumerating!public! !
!IniFileAbstract categoriesFor: #lookup:!accessing!public! !
!IniFileAbstract categoriesFor: #removeAllKeys:!accessing!public! !
!IniFileAbstract categoriesFor: #removeAllKeys:ifAbsent:!public!removing! !
!IniFileAbstract categoriesFor: #removeKey:!public!removing! !
!IniFileAbstract categoriesFor: #removeKey:ifAbsent:!public!removing! !
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

