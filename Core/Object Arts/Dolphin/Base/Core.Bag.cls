"Filed out from Dolphin Smalltalk 7"!

Collection subclass: #Bag
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Bag guid: (GUID fromString: '{87b4c509-026e-11d3-9fd7-00a0cc3e4a32}')!
Bag comment: 'A Bag is a variable sized, unordered, collection which is extensible and contractible, but not accesssible using external keys. Bag is similar to Set, but can contain duplicate elements (which it counts). Elements are considered to  be duplicates if they compare as equal using #=.

Bag conforms to the ANSI protocols:
	Object
	collection
	extensibleCollection
	Bag'!
!Bag categoriesForClass!Collections-Unordered! !
!Bag methodsFor!

= anObject
	"Answer whether the receiver and the <Object> comparand, are considered equivalent (in whatever respect is appropriate for the class of the receiver)."

	"Two Bags are considered equal if
		(a) they are the same object; or
		(b) they are the same 'kind' of thing, and they have the same elements occuring the same number of times in each."

	self == anObject ifTrue: [^true].
	(anObject species == self species and: [self size == anObject size]) ifFalse: [^false].
	contents keysAndValuesDo: [:key :value | (anObject occurrencesOf: key) = value ifFalse: [^false]].
	^true!

add: newElement
	"Include the <Object> argument, newElement, as an element of the receiver, once.
	newElement must not be nil. Answer newElement."

	^self add: newElement withOccurrences: 1.!

add: anObject withOccurrences: anInteger 
	"Include the argument, anObject, as an element of the receiver, anInteger number of times.
	The new element must not be nil. Answer the new element."

	"Implementation Note: Although nil is not a valid value for bag elements the ANSI standard
	specifies that the result is undefined if nil is added, so we do not explicitly test for it
	here."

	contents at: anObject put: anInteger + (self occurrencesOf: anObject).
	^anObject!

asBag
	"Answer a <Bag> containing the same elements as the receiver."

	^self!

asSet
	"Answer a <Set> containing each of the unique elements of the receiver.
	Implementation Note: Reimplement for efficiency only."

	^contents keys asSet!

at: index
	"Generate an error to the effect that Bag's are not keyed 
	(they're like Sets with duplicates)."

	^self errorNotKeyed!

at: index put: value
	"Generate an error to the effect that Bag's are not keyed 
	(they're like Sets with duplicates)"

	^self errorNotKeyed!

contents: initialContents
	"Private - Set the receiver's contents to be the
	<abstractDictionary>, initialContents."

	contents := initialContents!

do: operation
	"Evaluate <monadicValuable> argument, operation, for each of the element of the 
	receiver. Answers the receiver.
	Implementation Note: Bags need to perform the operation repeatedly for each element, 
	depending on the number of occurrences."

	contents keysAndValuesDo: [:elem :count |
		count timesRepeat: [operation value: elem]]!

elements
	"Private - Answers the contents of the receiver as an OrderedCollection"

	^self asOrderedCollection!

elements: anOrderedCollection
	"Private - Sets the contents of the receiver from anOrderedCollection"

	contents := contents class new: anOrderedCollection size.
	self addAll: anOrderedCollection!

includes: target
	"Answer whether the <Object> argument, target, 
	is one of the elements of the receiver."

	^contents includesKey: target!

occurrencesOf: target
	"Answer the <integer> number of the receiver's elements which are 
	equal to the <Object> argument, target."

	^contents at: target ifAbsent: [0]!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver.

	In the case of a Bag we need a completely new dictionary because it is part of the
	implementation of the Bag, rather than a public characteristic of the data structure."

	| original |
	super postCopy.
	original := contents.
	contents := original copyEmpty.
	original keysAndValuesDo: [:k :v | contents at: k put: v].
	^self!

remove: oldElement ifAbsent: exceptionHandler
	"Decrement the number of occurrences of the <Object> argument, 
	oldObject, in the receiver, and if it reaches zero remove oldElement 
	completely. If oldElement is not an element of the receiver, answer 
	the result of evaluating the <niladicValuable>, exceptionHandler, 
	else answer oldElement."

	| count |
	(count := contents at: oldElement ifAbsent: [^exceptionHandler value]) == 1
		ifTrue:  [contents removeKey: oldElement]
		ifFalse: [contents at: oldElement put: count - 1].
	^oldElement!

removeAll
	"Remove each element from the receiver and leave it empty."

	contents := contents copyEmpty!

removeAllOccurrencesOf: target ifAbsent: exceptionHandler
	"Remove all the occurrences of the <Object> target from the receiver. 
	If target is not an element of the receiver, answer the result of evaluating 
	the <niladicValuable>, exceptionHandler."

	^contents removeKey: target ifAbsent: exceptionHandler!

size
	"Answer the <integer> number of elements in the receiver, counting duplicates as the
	number of times which they occur.
	Implementation Note: Could implement more elegantly with #inject:into:, but
	this implementation is faster."

	| tally |
	tally := 0.
	contents do: [:elemCount | tally := tally + elemCount].
	^tally!

valuesAndCountsDo: aBlock 
	contents keysAndValuesDo: aBlock! !
!Bag categoriesFor: #=!comparing!public! !
!Bag categoriesFor: #add:!adding!public! !
!Bag categoriesFor: #add:withOccurrences:!adding!public! !
!Bag categoriesFor: #asBag!converting!public! !
!Bag categoriesFor: #asSet!converting!public! !
!Bag categoriesFor: #at:!accessing!public! !
!Bag categoriesFor: #at:put:!accessing!public! !
!Bag categoriesFor: #contents:!accessing!private! !
!Bag categoriesFor: #do:!enumerating!public! !
!Bag categoriesFor: #elements!accessing!private! !
!Bag categoriesFor: #elements:!accessing!private! !
!Bag categoriesFor: #includes:!public!searching! !
!Bag categoriesFor: #occurrencesOf:!public!searching! !
!Bag categoriesFor: #postCopy!copying!public! !
!Bag categoriesFor: #remove:ifAbsent:!public!removing! !
!Bag categoriesFor: #removeAll!public! !
!Bag categoriesFor: #removeAllOccurrencesOf:ifAbsent:!public!removing! !
!Bag categoriesFor: #size!accessing!public! !
!Bag categoriesFor: #valuesAndCountsDo:!enumerating!public! !

Bag methodProtocol: #Bag attributes: #(#ansi #readOnly) selectors: #(#add: #add:withOccurrences: #addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #remove: #remove:ifAbsent: #removeAll: #select: #size)!

!Bag class methodsFor!

identityNew
	"Answer a new instance of the receiver with default initial capacity, which uses identity 
	as the comparison for identifying duplicate elements."

	^self identityNew: 3
!

identityNew: anInteger
	"Answer a new instance of the receiver with sufficient initial capacity for anInteger unique
	elements, which uses identity as the comparison for identifying duplicate elements."

	^super new contents: (IdentityDictionary new: anInteger)
!

new
	"Answer a new instance of the receiver with default initial capacity, 
	which uses equality as the comparison for identifying duplicate elements."

	^self new: 3!

new: count
	"Answer a new instance of the receiver with sufficient initial capacity for 
	the number of elements specified by the <integer> argument, count,
	which uses equality as the comparison for identifying duplicate elements."

	^super new 
		contents: (LookupTable new: count)! !
!Bag class categoriesFor: #identityNew!instance creation!public! !
!Bag class categoriesFor: #identityNew:!instance creation!public! !
!Bag class categoriesFor: #new!instance creation!public! !
!Bag class categoriesFor: #new:!instance creation!public! !

Bag class methodProtocol: #'Bag factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

