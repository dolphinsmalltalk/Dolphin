"Filed out from Dolphin Smalltalk X6"!

ArrayedCollection variableSubclass: #Array
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Array guid: (GUID fromString: '{87B4C510-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	^self class == ##(self) and: [self allSatisfy: [:element | element isLiteral]]!

printPrefixOn: aStream
	"Private - Print a prefix string for the debug representation of the receiver on aStream."

	aStream nextPutAll: '#('!

refersToLiteral: anObject 
	"Private - Answer whether the receiver is a reference to the literal argument."

	self = anObject ifTrue: [^true].
	self do: [:each | (each refersToLiteral: anObject) ifTrue: [^true]].
	^false!

storeOn: aStream 
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	"Implementation Note: The receiver has a compact literal form, so use that. Any
	elements that are not themselves representable as literals are embedded as 
	expressions to be evaluated at compile time, i.e. using ##()."

	aStream nextPutAll: '#('.
	self do: 
			[:each | 
			each isLiteral 
				ifTrue: [each storeOn: aStream]
				ifFalse: 
					[aStream nextPutAll: '##('.
					each storeOn: aStream.
					aStream nextPut: $)]]
		separatedBy: 
			[aStream
				cr;
				space].
	aStream nextPut: $)! !
!Array categoriesFor: #addAnsweringIndex:!adding!public! !
!Array categoriesFor: #asArray!converting!public! !
!Array categoriesFor: #isLiteral!public!testing! !
!Array categoriesFor: #printPrefixOn:!printing!private! !
!Array categoriesFor: #refersToLiteral:!private!testing! !
!Array categoriesFor: #storeOn:!printing!public! !

Array methodProtocol: #Array attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #select: #size #with:do:)!

!Array class methodsFor!

with: element1 
	"Answer a new instance of the receiver containing the single 
	<Object> element, element1."

	<primitive: 157>
	^super with: element1!

with: element1 with: element2 
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements"

	<primitive: 157>
	^super with: element1 with: element2!

with: element1 with: element2 with: element3 
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	<primitive: 157>
	^super 
		with: element1
		with: element2
		with: element3!

with: element1 with: element2 with: element3 with: element4 
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	<primitive: 157>
	^super 
		with: element1
		with: element2
		with: element3
		with: element4!

with: element1 with: element2 with: element3 with: element4 with: element5 
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	"N.B. This is not an ANSI standard method (up to 4 elements are supported
	by <Array factory> #with:&c messages, for more one must use #withAll:)."

	<primitive: 157>
	^super 
		with: element1
		with: element2
		with: element3
		with: element4
		with: element5! !
!Array class categoriesFor: #with:!instance creation!public! !
!Array class categoriesFor: #with:with:!instance creation!public! !
!Array class categoriesFor: #with:with:with:!instance creation!public! !
!Array class categoriesFor: #with:with:with:with:!instance creation!public! !
!Array class categoriesFor: #with:with:with:with:with:!instance creation!public! !

