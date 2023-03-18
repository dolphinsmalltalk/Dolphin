"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Collection subclass: #'WebView2.ICoreWebView2Sequence'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Sequence guid: (OS.COM.IID fromString: '{9033689d-5414-4ef0-8f8c-b74e4f485261}')!
WebView2.ICoreWebView2Sequence isNonInstantiable: true!
WebView2.ICoreWebView2Sequence comment: '`ICoreWebView2Sequence` is not defined in the WebView2 IDL, but is defined here for economy of mechanism, providing a common implementation of most of the Smalltalk `<sequencedReadableCollection>` protocol for the WebView2 collections that support random access by integer index.

Subclasses must provide at least `elementClass` and `GetValueAtIndex:value:` to complete the implementation.'!
!WebView2.ICoreWebView2Sequence categoriesForClass!COM-Interfaces! !
!WebView2.ICoreWebView2Sequence methodsFor!

, aSequencedReadableCollection
	^self asArray , aSequencedReadableCollection!

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

	<virtual stdcall: hresult 4 dword*>
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

isEmpty
	"Answer whether the receiver contains any elements."

	^self size == 0!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments."

	1 to: self size do: [:i | operation value: i value: (self at: i)]!

last
	"Answer the <Object> which is the last element of the receiver. 
	Raise an exception if the receiver contains no elements."

	^self at: self size!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	start to: stop do: [:i | (self at: i) = anElement ifTrue: [^i]].
	^0!

reverse
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

size
	"Answer the <dword> value of the 'Count' property of the receiver."

	| answer |
	answer := UInt32 new.
	self get_Count: answer.
	^answer asObject!

with: otherCollection do: operation
	"Evaluate the <dyadicValuable> argument, operation, with each of 
	the receiver's elements along with the corresponding element from the 
	<sequencedReadableCollection> argument, otherCollection. 
	Raise an exception if otherCollection is not the same size as the receiver."

	self size = otherCollection size ifFalse: [^self error: 'collections are of different sizes'].
	self keysAndValuesDo: [:i :elem | operation value: elem value: (otherCollection at: i)]! !
!WebView2.ICoreWebView2Sequence categoriesForMethods!
,!copying!public! !
after:!public!searching! !
after:ifAbsent:!public!searching! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
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
get_Count:!COM Interfaces-ICoreWebView2ClientCertificateCollection!COM Interfaces-ICoreWebView2ContextMenuItemCollection!COM Interfaces-ICoreWebView2CookieList!COM Interfaces-ICoreWebView2ProcessInfoCollection!COM Interfaces-ICoreWebView2StringCollection!private! !
GetValueAtIndex:value:!COM Interfaces-ICoreWebView2CookieList!private! !
indexOf:!public!searching! !
indexOf:ifAbsent:!public!searching! !
indexOfSubCollection:startingAt:!public!searching! !
indexOfSubCollection:startingAt:ifAbsent:!public!searching! !
isEmpty!public!testing! !
keysAndValuesDo:!enumerating!public! !
last!accessing!public! !
nextIndexOf:from:to:!public!searching! !
reverse!copying!public! !
reversedFrom:to:!copying!public! !
reverseDo:!enumerating!public! !
size!accessing!public! !
with:do:!enumerating!public! !
!

WebView2.ICoreWebView2Sequence methodProtocol: #sequencedReadableCollection attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #reverse #reverseDo: #select: #size #with:do:)!

