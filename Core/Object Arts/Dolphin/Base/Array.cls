"Filed out from Dolphin Smalltalk 7"!

ArrayedCollection variableSubclass: #Array
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Array guid: (GUID fromString: '{87b4c510-026e-11d3-9fd7-00a0cc3e4a32}')!
Array comment: 'Array is the class of <ArrayedCollection>s whose elements are arbitraty <Object>s.

Array complies with the ANSI protocols:
	Object
	collection
	sequencedReadableCollection
	sequencedCollection
	Array'!
!Array categoriesForClass!Collections-Arrayed! !
!Array methodsFor!

addAnsweringIndex: newElement
	"Add newElement to the receiver by overwriting the first nil. If there are no nils
	then append it."

	^self replaceIdentity: nil with: newElement!

asArray
	"Answer an instance of <Array> containing the same elements as the receiver.
	In this case, no conversion is required."

	^self!

isLiteral
	"Answer whether the receiver can be represented as a literal (i.e. it has a printed
	representation which can be directly understood by the compiler)."

	^self isLiteral: IdentitySet new!

isLiteral: visitedSet
	"Answer whether the receiver can be represented as a literal (i.e. it has a printed
	representation which can be directly understood by the compiler)."

	^(visitedSet addNewElement: self)
		and: [self class == ##(self) and: [self allSatisfy: [:element | element isLiteral: visitedSet]]]!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^self isSelfEvaluating: IdentitySet new!

isSelfEvaluating: visitedSet
	"Answer whether the receiver can be represented as a literal (i.e. it has a printed
	representation which can be directly understood by the compiler)."

	^(visitedSet addNewElement: self)
		and: [self class == ##(self) and: [self allSatisfy: [:element | element isSelfEvaluating: visitedSet]]]!

printOn: aStream
	"Print an Array in the simplest possible form, ideally as a literal if all elements are literals, or failing that as a brace array if all elements have self-evaluating printStrings, or failing that in general collection printString form."

	| visited |
	visited := IdentitySet new.
	(self allSatisfy: [:element | element isLiteral: visited])
		ifTrue: 
			["Has literal form"
			aStream nextPutAll: '#('.
			self do: [:each | each printOn: aStream] separatedBy: [aStream space].
			aStream nextPut: $)]
		ifFalse: 
			[((visited includes: self) not and: [self allSatisfy: [:element | element isSelfEvaluating]])
				ifTrue: 
					["Can use brace array form"
					aStream nextPut: ${.
					self do: [:each | each printOn: aStream] separatedBy: [aStream nextPutAll: '. '].
					aStream nextPut: $}]
				ifFalse: 
					[aStream print: self
						with: 
							[aStream
								basicPrint: self;
								nextPut: $(.
							self do: [:each | each printOn: aStream] separatedBy: [aStream space].
							aStream nextPut: $)]]]!

refersToLiteral: anObject
	"Private - Answer whether the receiver is a reference to the literal argument."

	self = anObject ifTrue: [^true].
	1 to: self size do: [:i | ((self basicAt: i) refersToLiteral: anObject) ifTrue: [^true]].
	^false!

replaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object,
	anIndexableObject, between startInteger and stopInteger inclusive with elements of the
	receiver starting from startAtInteger. Answers anIndexableObject."

	<primitive: 188>
	| offset |
	offset := startAtInteger - startInteger.
	(anIndexableObject == self and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]].
	^anIndexableObject!

replaceFrom: startInteger to: stopInteger with: aSequencedReadableCollection startingAt: startAtInteger 
	"Destructively replace the elements of the receiver between the <integer> arguments
	startInteger and stopInteger inclusive with the <Object> elements of the
	<sequencedReadableCollection> argument, aSequencedReadableCollection, beginning with its
	element with <integer> index startAtInteger. Answer the receiver. Overlapping moves are
	correctly handled. Unlike #replaceFrom:to:with:, the size of aSequenceableCollection is not
	checked directly (X3J20 does not specify that this should be an error), but an error will be
	raised when an attempt is made to access an out-of-bounds element in replacementElements. It
	is not an error to specify an empty replacement interval, even if startInteger, stopInteger,
	and/or startAtInteger are out-of-bounds (this is compatible with the major
	implementations)."

	aSequencedReadableCollection 
		replaceElementsOf: self
		from: startInteger
		to: stopInteger
		startingAt: startAtInteger!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	"Implementation Note: The receiver has a compact literal form, so use that where possible, otherwise degrade to the brace array form."

	self isLiteral
		ifTrue: 
			[aStream nextPutAll: '#('.
			self do: [:each | each storeOn: aStream] separatedBy: [aStream space].
			aStream nextPut: $)]
		ifFalse: 
			["Use a brace array"
			aStream nextPut: ${.
			self do: [:each | each storeOn: aStream] separatedBy: [aStream nextPutAll: '. '].
			aStream nextPut: $}]! !
!Array categoriesFor: #addAnsweringIndex:!adding!public! !
!Array categoriesFor: #asArray!converting!public! !
!Array categoriesFor: #isLiteral!public!testing! !
!Array categoriesFor: #isLiteral:!public!testing! !
!Array categoriesFor: #isSelfEvaluating!public!testing! !
!Array categoriesFor: #isSelfEvaluating:!public!testing! !
!Array categoriesFor: #printOn:!printing!public! !
!Array categoriesFor: #refersToLiteral:!private!testing! !
!Array categoriesFor: #replaceElementsOf:from:to:startingAt:!private!replacing! !
!Array categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!Array categoriesFor: #storeOn:!printing!public! !

Array methodProtocol: #Array attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #select: #size #with:do:)!

!Array class methodsFor!

empty
	"Answer an empty (zero length) instance of the receiver."

	^#()!

newFromStack: aSmallInteger
	"Private - Answer an instance of the receiver with the specified number of instance
	variables (indexed and fixed), populated from that many entries on the stack. "

	"N.B. This method is part of the implementation of brace arrays, and is intended for use by
	the compiler. If used incorrectly it will corrupt the stack and will likely cause the
	program to fail. The primitive will pop anInteger arguments from the stack in order to
	populate the new object. If that exact number of arguments has not been previously pushed,
	then either extra stack content will be left behind, or preceding content will be eaten
	into. When the method returns this will probably cause a crash. In other words, do not 
	attempt to use this method in normal code."

	"This primitive should not fail for Array class."

	<primitive: 190>
	^self primitiveFailed: _failureCode!

with: element1
	"Answer a new instance of the receiver containing the single <Object> element, element1."

	<primitive: 157>
	^{element1}!

with: element1 with: element2 
	"Answer an instance of the receiver containing the <Object>	arguments as its elements"

	<primitive: 157>
	^{element1. element2}!

with: element1 with: element2 with: element3
	"Answer an instance of the receiver containing the <Object>	arguments as its elements."

	<primitive: 157>
	^{element1. element2. element3}!

with: element1 with: element2 with: element3 with: element4
	"Answer an instance of the receiver containing the <Object>	arguments as its elements."

	<primitive: 157>
	^{element1. element2. element3. element4}!

with: element1 with: element2 with: element3 with: element4 with: element5
	"Answer an instance of the receiver containing the <Object>arguments as its elements."

	"N.B. This is not an ANSI standard method. Up to 4 elements are supported by <Array factory> #with:&c messages, for more one must either #withAll:. Brace arrays are of course neater (and faster), but non-standard."

	<primitive: 157>
	^{element1. element2. element3. element4. element5}! !
!Array class categoriesFor: #empty!instance creation!public! !
!Array class categoriesFor: #newFromStack:!instance creation!must not strip!private! !
!Array class categoriesFor: #with:!instance creation!public! !
!Array class categoriesFor: #with:with:!instance creation!public! !
!Array class categoriesFor: #with:with:with:!instance creation!public! !
!Array class categoriesFor: #with:with:with:with:!instance creation!public! !
!Array class categoriesFor: #with:with:with:with:with:!instance creation!public! !

