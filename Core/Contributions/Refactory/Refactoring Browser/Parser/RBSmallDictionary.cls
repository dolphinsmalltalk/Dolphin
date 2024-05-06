"Filed out from Dolphin Smalltalk"!

Collection subclass: #RBSmallDictionary
	instanceVariableNames: 'keys values size'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBSmallDictionary guid: (GUID fromString: '{65ef5a3f-ece9-4966-8d14-b90bf121a5d6}')!

RBSmallDictionary comment: 'RBSmallDictionary is an <abstractDictionary> optimized for small collections. It is part of the Refactoring Browser.
Note that the implementation is similar to <LookupTable> in that RBSmallDictionarys do not store <Association>s.

Instance Variables:
	keys		<Array> of <Object>. The keys.
	values		<Array> of <Object>. The values.
	size		<SmallInteger>. The number of elements.
'!

!RBSmallDictionary categoriesForClass!Refactory-ParseTree Matching! !

!RBSmallDictionary methodsFor!

add: anAssociation 
	self at: anAssociation key put: anAssociation value.
	^anAssociation!

associationsDo: aBlock 
	self keysAndValuesDo: [:key :value | aBlock value: key -> value]!

at: key
	"Answer the value at the <Object> key in the receiver.  If not found report an error.
	It is important that the exception block passed as the parameter with the
	#ifAbsent: keyword does not contain an explicit (^) return, as this may
	upset some subclasses."

	^self at: key ifAbsent: [self errorKeyNotFound: key]!

at: key ifAbsent: aBlock 
	| index |
	index := self findIndexFor: key.
	^index == 0 ifTrue: [aBlock value] ifFalse: [values at: index]!

at: key ifAbsentPut: aBlock 
	| index |
	index := self findIndexFor: key.
	^index == 0 
		ifTrue: [self privateAt: key put: aBlock value]
		ifFalse: [values at: index]!

at: key put: value 
	| index |
	index := self findIndexFor: key.
	^index == 0 
		ifTrue: [self privateAt: key put: value]
		ifFalse: [values at: index put: value]!

do: aBlock 
	1 to: size do: [:i | aBlock value: (values at: i)]!

empty
	size := 0!

errorKeyNotFound: aKey
	"Private - Report that an attempt was made to look up a key which was not in the receiver"

	^self errorNotFound: aKey
!

findIndexFor: aKey 
	1 to: size do: [:i | (keys at: i) = aKey ifTrue: [^i]].
	^0!

growKeysAndValues
	self growTo: size * 2!

growTo: aSize 
	| newKeys newValues |
	newKeys := Array new: aSize.
	newValues := Array new: aSize.
	1 to: size
		do: 
			[:i | 
			newKeys at: i put: (keys at: i).
			newValues at: i put: (values at: i)].
	keys := newKeys.
	values := newValues!

includesKey: aKey 
	^(self findIndexFor: aKey) ~~ 0!

initialize
	keys := Array new: 2.
	values := Array new: 2.
	size := 0!

keys
	"Answer a <collection> containing the receiver's keys.
	Implementation Note: We answer a <Set>, but that should
	not be relied upon in portable code."

	| aSet |
	aSet := Set new: self size.
	self keysDo: [:key | aSet add: key].
	^aSet!

keysAndValuesDo: aBlock 
	1 to: size do: [:i | aBlock value: (keys at: i) value: (values at: i)]!

keysDo: aBlock 
	1 to: size do: [:i | aBlock value: (keys at: i)]!

postCopy
	super postCopy.
	keys := keys copy.
	values := values copy.
	^self!

privateAt: key put: value 
	size == keys size ifTrue: [self growKeysAndValues].
	size := size + 1.
	keys at: size put: key.
	^values at: size put: value!

remove: oldObject ifAbsent: anExceptionBlock 
	self removeKey: oldObject key ifAbsent: anExceptionBlock.
	^oldObject!

removeKey: key
	"Remove the <Object> key (and its associated value), from the receiver. 
	If key is not in the receiver, report an error. Otherwise, answer the value 
	named by key."

	^self removeKey: key ifAbsent: [self errorKeyNotFound: key]!

removeKey: key ifAbsent: aBlock 
	| index value |
	index := self findIndexFor: key.
	index == 0 ifTrue: [^aBlock value].
	value := values at: index.
	index to: size - 1
		do: 
			[:i | 
			keys at: i put: (keys at: i + 1).
			values at: i put: (values at: i + 1)].
	keys at: size put: nil.
	values at: size put: nil.
	size := size - 1.
	^value!

size
	^size! !

!RBSmallDictionary categoriesForMethods!
add:!adding!public! !
associationsDo:!enumerating!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:ifAbsentPut:!accessing!public! !
at:put:!adding!public! !
do:!enumerating!public! !
empty!accessing!public! !
errorKeyNotFound:!exceptions!private! !
findIndexFor:!private!searching! !
growKeysAndValues!helpers!private! !
growTo:!helpers!private! !
includesKey:!public!testing! !
initialize!initializing!public! !
keys!accessing!public! !
keysAndValuesDo:!enumerating!public! !
keysDo:!enumerating!public! !
postCopy!copying!public! !
privateAt:put:!helpers!private! !
remove:ifAbsent:!public!removing! !
removeKey:!public!removing! !
removeKey:ifAbsent:!public!removing! !
size!accessing!public! !
!

!RBSmallDictionary class methodsFor!

new
	^self basicNew initialize!

new: aSize 
	"Ignore the size"

	^self basicNew initialize! !

!RBSmallDictionary class categoriesForMethods!
new!instance creation!public! !
new:!instance creation!public! !
!

