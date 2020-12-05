"Filed out from Dolphin Smalltalk 7"!

Core.Collection subclass: #'Refactory.Browser.RBSmallDictionary'
	instanceVariableNames: 'keys values size'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBSmallDictionary guid: (Core.GUID fromString: '{65ef5a3f-ece9-4966-8d14-b90bf121a5d6}')!
Refactory.Browser.RBSmallDictionary comment: 'RBSmallDictionary is an <abstractDictionary> optimized for small collections. It is part of the Refactoring Browser.
Note that the implementation is similar to <LookupTable> in that RBSmallDictionarys do not store <Association>s.

Instance Variables:
	keys		<Array> of <Object>. The keys.
	values		<Array> of <Object>. The values.
	size		<SmallInteger>. The number of elements.
'!
!Refactory.Browser.RBSmallDictionary categoriesForClass!Refactory-ParseTree Matching! !
!Refactory.Browser.RBSmallDictionary methodsFor!

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
!Refactory.Browser.RBSmallDictionary categoriesFor: #add:!adding!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #associationsDo:!enumerating!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #at:!accessing!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #at:ifAbsent:!accessing!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #at:ifAbsentPut:!accessing!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #at:put:!adding!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #do:!enumerating!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #empty!accessing!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #errorKeyNotFound:!exceptions!private! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #findIndexFor:!private!searching! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #growKeysAndValues!helpers!private! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #growTo:!helpers!private! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #includesKey:!public!testing! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #initialize!initializing!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #keys!accessing!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #keysAndValuesDo:!enumerating!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #keysDo:!enumerating!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #privateAt:put:!helpers!private! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #remove:ifAbsent:!public!removing! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #removeKey:!public!removing! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #removeKey:ifAbsent:!public!removing! !
!Refactory.Browser.RBSmallDictionary categoriesFor: #size!accessing!public! !

!Refactory.Browser.RBSmallDictionary class methodsFor!

new
	^self basicNew initialize!

new: aSize 
	"Ignore the size"

	^self basicNew initialize! !
!Refactory.Browser.RBSmallDictionary class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.RBSmallDictionary class categoriesFor: #new:!instance creation!public! !

