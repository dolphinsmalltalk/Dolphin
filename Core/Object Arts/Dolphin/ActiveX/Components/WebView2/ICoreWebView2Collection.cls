"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Collection
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2Collection guid: (OS.COM.IID fromString: '{d7f78fbc-5e73-4009-9f6b-5a822b0a6313}')!
ICoreWebView2Collection isNonInstantiable: true!
ICoreWebView2Collection comment: '`ICoreWebView2Collection` is not defined in the WebView2 IDL, but is defined here for economy of mechanism, providing a common implmentaton of most of the Smalltalk `<collection>` protocol.

Subclasses must implement `do:` only.
'!
!ICoreWebView2Collection categoriesForClass!COM-Interfaces! !
!ICoreWebView2Collection methodsFor!

allSatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for every element of the receiver.
	Implementation Note: The argument is evaluated for every element of the receiver iff it is satisfied for every element."

	self do: [:e | (discriminator value: e) ifFalse: [^false]].
	^true!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for any element of the receiver.
	Implementation Note: The argument is evaluated for every element of the receiver iff it evaluates to false for every element."

	self do: [:e | (discriminator value: e) ifTrue: [^true]].
	^false!

asArray
	"Answer an array of the receiver's elements."

	| elements |
	elements := Array writeStream: 2.
	self do: [:each | elements nextPut: each].
	^elements grabContents!

asBag
	"Answer a <Bag> containing the same elements as the receiver."

	^Bag new
		addAll: self;
		yourself!

asOrderedCollection
	"Answer an <OrderedCollection> of the receiver's elements."

	| elements |
	elements := OrderedCollection new.
	self do: [:each | elements addLast: each].
	^elements!

asSet
	"Answer an <Set> of the receiver's elements."

	| elements |
	elements := Set new.
	self do: [:each | elements add: each].
	^elements!

asSortedCollection
	"Answer a <SortedCollection> of the receiver's header strings."

	^self asArray asSortedCollection!

asSortedCollection: aDyadicValuable
	"Answer a <SortedCollection> of the receiver's header strings."

	^self asArray asSortedCollection: aDyadicValuable!

collect: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's values. Answer a new collection like the receiver containing the same keys, and the values returned by the transformer on each evaluation."

	| answer |
	answer := Array writeStream.
	self do: [:each | answer nextPut: (aMonadicValuable value: each)].
	^answer contents!

countElements
	"Private - Count, and answer, the number of elements in the receiver."

	| tally |
	tally := 0.
	self do: [ :each | tally := tally + 1].
	^tally!

detect: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's elements in the order defined by the receiver's implementation of #do:.
	Answer the first element for which discriminator evaluates to true. If none evaluates to true, report an error."

	^self detect: aMonadicValuable ifNone: [self errorNotFound: aMonadicValuable]!

detect: aMonadicValuable ifNone: aNiladicValuable
	"Evaluate the <monadicValuable> first argument for each of the receiver's elements. Answer the first element (in the #do: order) for which discriminator evaluates to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	second argument."

	self do: [:each | (aMonadicValuable value: each) ifTrue: [^each]].
	^aNiladicValuable value!

do: aMonadicValuable
	self subclassResponsibility!

includes: target
	"Answer whether the <Object> argument, target, is one of the elements of the receiver.
	Implementation Note: The default is to use equality for comparison."

	^self anySatisfy: [:each | target = each]!

inject: anObject into: aDyadicValuable
	"Evaluate the <dyadicValuable> second argument once for each header string in the receiver, with that header as the second argument; and with the first argument as the value of the previous evaluation, starting with the <Object> first argument. The operation must answer the value it wishes to have passed as its first argument the next time it is evaluated. The traversal is in the #do: 
	order. Answer the final value of the operation."

	| nextValue |
	nextValue := anObject.
	self do: [:each | nextValue := aDyadicValuable value: nextValue value: each].
	^nextValue!

isEmpty
	"Answer whether the receiver contains no elements."

	^self size == 0
!

notEmpty
	"Answer whether the receiver contains any elements."

	^self isEmpty not!

occurrencesOf: aString
	"Answer the number of the receiver's values which are equal to the argument."

	| count |
	count := 0.
	self do: [:header | header = aString ifTrue: [count := count + 1]].
	^count!

rehash
	"Part of the <collection> protocol, but a no-op here."!

reject: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's header strings. Answer a new <collection> like the receiver containing only those elements for which the discriminator evaluates to false."

	^self select: [:elem | (aMonadicValuable value: elem) not]!

select: aMonadicValuable
	| answer |
	answer := Array writeStream.
	self do: [:each | (aMonadicValuable value: each) ifTrue: [answer nextPut: each]].
	^answer contents!

size
	"Answer the <integer> number of elements in the receiver.
	Implementation Note: This implementation is rather inefficient, 
	and subclasses will probably want to override it."

	^self countElements! !
!ICoreWebView2Collection categoriesForMethods!
allSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
asArray!converting!public! !
asBag!converting!public! !
asOrderedCollection!converting!public! !
asSet!converting!public! !
asSortedCollection!converting!public! !
asSortedCollection:!converting!public! !
collect:!enumerating!public! !
countElements!accessing!private! !
detect:!public!searching! !
detect:ifNone:!public!searching! !
do:!enumerating!public! !
includes:!public!searching! !
inject:into:!enumerating!public! !
isEmpty!public!testing! !
notEmpty!public!testing! !
occurrencesOf:!public!searching! !
rehash!operations!public! !
reject:!enumerating!public! !
select:!enumerating!public! !
size!accessing!public! !
!

ICoreWebView2Collection methodProtocol: #collection attributes: #(#ansi #readOnly) selectors: #(#allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #select: #size)!

