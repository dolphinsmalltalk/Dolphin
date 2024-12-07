"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Collection
	subclass: #'WebView2.ICoreWebView2Sequence'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Sequence guid: (OS.COM.IID fromString: '{9033689d-5414-4ef0-8f8c-b74e4f485261}')!

WebView2.ICoreWebView2Sequence isNonInstantiable: true!

WebView2.ICoreWebView2Sequence isEgressOnly: true!

WebView2.ICoreWebView2Sequence comment: '`ICoreWebView2Sequence` is not defined in the WebView2 IDL, but is defined here for economy of mechanism, providing a common implementation of most of the Smalltalk `<sequencedReadableCollection>` protocol for the WebView2 collections that support random access by integer index.

Subclasses must provide at least `elementClass` and `GetValueAtIndex:value:` to complete the implementation.'!

!WebView2.ICoreWebView2Sequence categoriesForClass!COM-Interfaces! !

!WebView2.ICoreWebView2Sequence methodsFor!

, aSequencedReadableCollection
	^self asArray , aSequencedReadableCollection!

add: newElement
	"Append, and answer, newElement as the last element of the receiver."

	^self addLast: newElement!

add: anObject beforeIndex: anInteger
	| unk |
	unk := anObject queryInterface: self elementClass.
	self InsertValueAtIndex: anInteger - 1 value: unk.
	^unk!

addAll: aCollection
	"Include all the elements of the <collection> argument as the receiver's elements. 
	Answer the argument. Note that this modifies and answers the receiver, not a copy."

	^self addAllLast: aCollection!

addAllLast: aCollection
	"Append the elements of the <collection> argument to the receiver, in the order that they appear in that collection (as defined by its implementation of #do:). Answer the collection."

	^aCollection collect: [:each | self addLast: each]!

addLast: anObject
	"Insert the argument as the last element of the receiver."

	^self add: anObject beforeIndex: self size + 1!

after: anObject
	"Answer the element after the argument, anObject. Report an error if target is not in the receiver, or if there are no elements after it."

	^self after: anObject ifAbsent: [self errorNotFound: anObject]!

after: target ifAbsent: exceptionHandler
	"Answer the element after target, or if not present the result of evaluating the
	niladic valuable, exceptionHandler."

	| index |
	index := self indexOf: target.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [
			index = self size 
				ifTrue: [self errorLastObject: target]
				ifFalse: [self at: index + 1]]!

at: anInteger
	| answer |
	answer := self elementClass newPointer.
	self GetValueAtIndex: anInteger - 1 value: answer.
	^answer!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	^(index > 0 and: [index <= self size])
		ifTrue: [self at: index]
		ifFalse: [exceptionBlock value]!

at: anInteger put: anObject
	"There is no overwrite operation, so we must remove and insert"

	| added |
	self removeAtIndex: anInteger.
	added := self add: anObject beforeIndex: anInteger.
	^added!

atAll: aCollectionOfIntegers put: anObject
	"Replace the elements of the receiver at each <integer> element of the <collection> first argument with the <Object> last argument."

	aCollectionOfIntegers do: [:index | self at: index put: anObject]!

atAllPut: newElement
	"Replace all the elements of the receiver with the <Object> argument, newElement."

	| count unk |
	count := self size.
	self removeAll.
	unk := newElement queryInterface: self elementClass.
	0 to: count - 1 do: [:i | self InsertValueAtIndex: i value: unk].
	^unk!

basicIndexOfSubCollection: targetSequence startingAt: start
	| firstElement subSize size |
	subSize := targetSequence size.
	subSize == 0 ifTrue: [^0].
	firstElement := targetSequence at: 1.
	size := self size.
	subSize == 1
		ifTrue: 
			[^self
				nextIndexOf: firstElement
				from: start
				to: size].
	start to: size - subSize + 1
		do: 
			[:i |
			(self at: i) = firstElement
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (targetSequence at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

before: target
	"Answer the receiver's element immediately before the argument, target. 
	Raise an exception if target is not an element of the receiver, or if 
	there are no elements before it (i.e. it is the first element)."

	^self before: target ifAbsent: [self errorNotFound: target]!

before: anObject ifAbsent: exceptionHandler
	"Answer the element before the argument, anObject, or if not present the result of evaluating the niladic valuable, exceptionHandler."

	| index |
	index := self indexOf: anObject.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index == 1 ifTrue: [self errorFirstObject: anObject] ifFalse: [self at: index - 1]]!

copyReplaceAll: oldSequencedReadableCollection with: newSequencedReadableCollection
	^self asArray copyReplaceAll: oldSequencedReadableCollection with: newSequencedReadableCollection!

copyReplaceFrom: start to: stop with: replacementElements
	^self asArray copyReplaceFrom: start to: stop with: replacementElements!

copyReplaceFrom: start to: stop withObject: replacementElement
	^self asArray copyReplaceFrom: start to: stop withObject: replacementElement!

copyReplacing: targetElement withObject: replacementElement
	^self asArray copyReplacing: targetElement withObject: replacementElement!

copyWith: newElement
	^self asArray copyWith: newElement!

copyWithout: oldElement
	^self asArray copyWithout: oldElement!

do: aMonadicValuable
	1 to: self size do: [:i | aMonadicValuable value: (self at: i)]!

elementClass
	^self subclassResponsibility!

errorCollectionsOfDifferentSizes
	^self error: 'collections are of different sizes'!

errorLastObject: target
	"Private - Report an error to the effect that an attempt was made to access the object
	after the argument, target, where the latter is the last element of the receiver."

	^self error: ('<1p> is my last object' expandMacrosWith: target)!

findFirst: discriminator
	"Answer the index of the first element of the receiver for which the monadic
	valuable argument, discriminator, evaluates to true. If there are no such elements,
	answer 0."

	1 to: self size do: [:i | (discriminator value: (self at: i)) ifTrue: [^i]].
	^0!

findLast: discriminator
	"Answer the <integer> index of the last element of the receiver for which the 
	<monadicValuable> argument, discriminator, evaluates to true. If there are 
	If there are no such elements, answer 0."

	self size to: 1 by: -1 do: [:i | (discriminator value: (self at: i)) ifTrue: [^i]].
	^0!

first
	"Answer an <Object> which is the first element of the receiver. 
	Raise an exception if the receiver contains no elements."

	^self at: 1!

from: startInteger to: stopInteger do: operation 
	"Evaluate the <monadicValuable>, operation, for each element of the receiver in the
	specified (inclusive) range. A <BoundsError> will be raised if either start or stop index is
	out of bounds."

	startInteger to: stopInteger do: [:i | operation value: (self at: i)]!

from: startInteger to: stopInteger keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments."

	startInteger to: stopInteger do: [:i | operation value: i value: (self at: i)]!

get_Count: value
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 4 uint32*>
	^self invalidCall: _failureCode!

GetValueAtIndex: index value: cookie
	self subclassResponsibility!

indexOf: target
	"Answer the <integer> index of the first element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer 0."

	^self nextIndexOf: target from: 1 to: self size!

indexOf: target ifAbsent: exceptionHandler
	"Answer the <integer> index of the first element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer the result of evaluating 
	the <niladicValuable>, exceptionHandler."

	| index |
	index := self indexOf: target.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index]!

indexOfSubCollection: aSequencedReadableCollection startingAt: startInteger
	"Answer the <integer> index of the next occurrence within the receiver of the <sequencedReadableCollection> sub-sequence, starting at the specified <integer> index. If there are no such occurrences (or the search sequence is empty), answer 0."

	| firstElement subSize size |
	subSize := aSequencedReadableCollection size.
	subSize == 0 ifTrue: [^0].
	firstElement := aSequencedReadableCollection at: 1.
	size := self size.
	subSize == 1
		ifTrue: 
			[^self
				nextIndexOf: firstElement
				from: startInteger
				to: size].
	startInteger to: size - subSize + 1
		do: 
			[:i |
			(self at: i) = firstElement
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (aSequencedReadableCollection at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

indexOfSubCollection: targetSequence startingAt: start ifAbsent: exceptionHandler
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start.
	If no such match is found, answer the result of evaluating the 
	<niladicValuable>, exceptionHandler."

	| index |
	index := self indexOfSubCollection: targetSequence startingAt: start.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index]!

InsertValueAtIndex: anInteger value: anObject
	"Only implemented by writable sequences"

	^self shouldNotImplement!

keys
	"Answer a <collection> containing the receiver's keys."

	^1 to: self size!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments."

	1 to: self size do: [:i | operation value: i value: (self at: i)]!

last
	"Answer the <Object> which is the last element of the receiver. 
	Raise an exception if the receiver contains no elements."

	^self at: self size!

maybeBoundsError: codeInteger atIndex: indexInteger
	((HRESULT decodePrimitiveFailureCode: codeInteger) = E_INVALIDARG
		and: [indexInteger isInteger and: [indexInteger positive]]) ifFalse: [^self].
	(indexInteger between: 0 and: self size - 1)
		ifFalse: [^self errorSubscriptBounds: indexInteger + 1]!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	start to: stop do: [:i | (self at: i) = anElement ifTrue: [^i]].
	^0!

printOn: aPuttableStream
	aPuttableStream
		basicPrint: self;
		nextPut: $(.
	self isNull
		ifTrue: [aPuttableStream nextPutAll: 'NULL']
		ifFalse: [self do: [:each | each printOn: aPuttableStream] separatedBy: [aPuttableStream space]].
	aPuttableStream nextPut: $)!

removeAll
	"Empty the receiver of all contents"

	self size - 1 to: 0
		by: -1
		do: [:i | self RemoveValueAtIndex: i]!

removeAtIndex: anInteger
	"Remove, and answer, the element of the receiver at the specified <integer> index, by shuffling elements which succeed it down one slot.
	Raise a <BoundsError> if there is no element with that index."

	| item |
	item := self at: anInteger.
	self RemoveValueAtIndex: anInteger - 1.
	^item!

removeFirst
	"Remove and answer the first element of the receiver, raising an exception if the receiver is empty."

	^self removeAtIndex: 1!

removeLast
	"Remove and answer the last element of the receiver, raising an exception if the receiver is empty."

	^self removeAtIndex: self size!

RemoveValueAtIndex: anInteger
	"Only implemented by writable sequences"

	^self shouldNotImplement!

replaceFrom: start to: stop with: replacementElements
	"Destructively replace the elements of the receiver between the <integer> arguments
	start and stop with the <Object> elements of the <sequencedReadableCollection> argument, 
	replacementElements. Answer the receiver. Raise an Exception if  replacementElements does 
	not contain the number of elements required to exactly fill the replacement interval in the receiver."

	replacementElements size = (stop - start + 1)
		ifFalse: [^self error: 'size of replacement incorrect'].
	^self replaceFrom: start to: stop with: replacementElements startingAt: 1!

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

	"Implementation Note: The performance of this method is very important to overall 
	system performance. This implementation is mostly inlined by the compiler."

	| offset |
	offset := startAtInteger - startInteger.
	"Perform overlapping moves backwards, otherwise forwards"
	(self == aSequencedReadableCollection and: [startAtInteger < startInteger]) 
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | self at: i put: (aSequencedReadableCollection at: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger
				do: [:i | self at: i put: (aSequencedReadableCollection at: offset + i)]]!

replaceFrom: start to: stop withObject: replacementElement
	"Destructively replace the elements of the receiver between the
	<integer> indices start and stop with the <Object> argument,
	replacementElement. Answer replacementElement."

	start to: stop do: [:i | self at: i put: replacementElement].
	^replacementElement!

reverse
	"Implemented because this is part of the ANSI compatibility sequencedReadableCollection protocols, but discouraged because the use of the present tense implies that the operation happens in place, whereas in fact a new instance is answered. #reversed should be used in preference."

	^self reversed!

reversed
	"Answer a new <sequencedReadableCollection> which contains the same elements as the receiver, but in reverse order."

	^self reversedFrom: 1 to: self size!

reversedFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of the receiver between the <integer> indices startInteger and stopInteger, inclusive, but in reverse order."

	| answer offset len |
	len := stopInteger - startInteger + 1.
	answer := Array new: len.
	offset := len + startInteger.
	startInteger to: stopInteger do: [:i | answer at: offset - i put: (self at: i)].
	^answer!

reverseDo: operation
	"Evaluate the <monadicValuable> argument, operation, against each 
	element of the receiver in reverse order, from end to start."

	self size to: 1 by: -1 do: [:i | operation value: (self at: i)]!

second
	"Answer an <Object> which is the second element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 2!

size
	"Answer the <dword> value of the 'Count' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_Count: answer.
	^answer uint32AtOffset: 0!

third
	"Answer an <Object> which is the third element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 3!

with: otherCollection do: operation
	"Evaluate the <dyadicValuable> argument, operation, with each of 
	the receiver's elements along with the corresponding element from the 
	<sequencedReadableCollection> argument, otherCollection. 
	Raise an exception if otherCollection is not the same size as the receiver."

	self size = otherCollection size ifFalse: [^self error: 'collections are of different sizes'].
	self keysAndValuesDo: [:i :elem | operation value: elem value: (otherCollection at: i)]! !

!WebView2.ICoreWebView2Sequence categoriesForMethods!
,!copying!public! !
add:!adding!public! !
add:beforeIndex:!adding!public! !
addAll:!adding!public! !
addAllLast:!adding!public! !
addLast:!adding!public! !
after:!public!searching! !
after:ifAbsent:!public!searching! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
atAll:put:!accessing!public! !
atAllPut:!accessing!public! !
basicIndexOfSubCollection:startingAt:!private!searching! !
before:!public!searching! !
before:ifAbsent:!public!searching! !
copyReplaceAll:with:!copying!public! !
copyReplaceFrom:to:with:!copying!public! !
copyReplaceFrom:to:withObject:!copying!public! !
copyReplacing:withObject:!copying!public! !
copyWith:!copying!public! !
copyWithout:!copying!public! !
do:!enumerating!public! !
elementClass!constants!private! !
errorCollectionsOfDifferentSizes!enumerating!public! !
errorLastObject:!exceptions!private! !
findFirst:!public!searching! !
findLast:!public!searching! !
first!accessing!public! !
from:to:do:!enumerating!public! !
from:to:keysAndValuesDo:!enumerating!public! !
get_Count:!private! !
GetValueAtIndex:value:!private! !
indexOf:!public!searching! !
indexOf:ifAbsent:!public!searching! !
indexOfSubCollection:startingAt:!public!searching! !
indexOfSubCollection:startingAt:ifAbsent:!public!searching! !
InsertValueAtIndex:value:!adding!private! !
keys!accessing!public! !
keysAndValuesDo:!enumerating!public! !
last!accessing!public! !
maybeBoundsError:atIndex:!accessing!private! !
nextIndexOf:from:to:!public!searching! !
printOn:!printing!public! !
removeAll!public!removing! !
removeAtIndex:!public!removing! !
removeFirst!public!removing! !
removeLast!public!removing! !
RemoveValueAtIndex:!private!removing! !
replaceFrom:to:with:!public!replacing! !
replaceFrom:to:with:startingAt:!public!replacing! !
replaceFrom:to:withObject:!public!replacing! !
reverse!copying!public! !
reversed!copying!public! !
reversedFrom:to:!copying!public! !
reverseDo:!enumerating!public! !
second!accessing!public! !
size!accessing!public! !
third!accessing!public! !
with:do:!enumerating!public! !
!

WebView2.ICoreWebView2Sequence methodProtocol: #sequencedCollection attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #select: #size #with:do:)!
WebView2.ICoreWebView2Sequence methodProtocol: #sequencedContractibleCollection attributes: #(#ansi #readOnly) selectors: #(#allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #removeAtIndex: #removeFirst #removeLast #select: #size)!
WebView2.ICoreWebView2Sequence methodProtocol: #sequencedReadableCollection attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #reverse #reverseDo: #select: #size #with:do:)!

