"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBSortedDictionary
	instanceVariableNames: 'keys values elementCount currentIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSortedDictionary guid: (GUID fromString: '{8162EDE3-0FB8-11D4-B091-000000000000}')!
ODBSortedDictionary comment: ''!
!ODBSortedDictionary categoriesForClass!No category! !
!ODBSortedDictionary methodsFor!

at: aKey 
	| index |
	(index := self findKey: aKey) > 0 ifTrue: [^values at: index].
	^nil!

at: aKey put: value 
	| index |
	(index := self findKey: aKey) > 0 ifTrue: [^values at: index put: value].
	index := 0 - index.
	elementCount = keys size 
		ifTrue: 
			[keys := (Array new: elementCount * 2) 
						replaceFrom: 1
						to: elementCount
						with: keys
						startingAt: 1.
			values := (Array new: elementCount * 2) 
						replaceFrom: 1
						to: elementCount
						with: values
						startingAt: 1].
	elementCount := elementCount + 1.
	keys 
		replaceFrom: index + 1
		to: elementCount
		with: keys
		startingAt: index.
	values 
		replaceFrom: index + 1
		to: elementCount
		with: values
		startingAt: index.
	keys at: index put: aKey.
	^values at: index put: value!

do: aBlock 
	1 to: elementCount do: [:i | aBlock value: (values at: i)]!

findKey: aKey 
	"Private - Answer index of aKey. If aKey does not 
        exist answer its index as negative integer."

	| a b key i |
	elementCount == 0 ifTrue: [^-1].
	a := 1.
	b := elementCount + 1.
	
	[key := keys at: (i := (a + b) // 2).
	(aKey odbIsLessOrEqualTo: key) 
		ifTrue: 
			[key = aKey ifTrue: [^i].
			b := i]
		ifFalse: [a := i + 1].
	a == b] 
			whileFalse: [].
	^0 - a!

getCurrent
	currentIndex < 1 ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: currentIndex)
		value: (values at: currentIndex)!

getFirst
	currentIndex := 1.
	^ODBBTreeDictionaryAssociation new setKey: (keys at: 1) value: (values at: 1)!

getLast
	currentIndex := elementCount.
	^ODBBTreeDictionaryAssociation new setKey: (keys at: currentIndex)
		value: (values at: currentIndex)!

goTo: aKey 
	currentIndex := self findKey: aKey!

goToNext
	currentIndex := (currentIndex < 1 ifTrue: [0 - currentIndex] ifFalse: [currentIndex + 1]) 
				min: elementCount!

goToPrevious
	currentIndex := currentIndex abs - 1 max: 1!

includes: aKey 
	^(self findKey: aKey) > 0!

initialize
	keys := Array new: 128.
	values := Array new: 128.
	elementCount := 0!

keysAndValuesDo: aBlock 
	1 to: elementCount do: [:i | aBlock value: (keys at: i) value: (values at: i)]!

peekNext
	| i |
	currentIndex < 1 ifTrue: [i := 0 - currentIndex] ifFalse: [i := currentIndex + 1].
	i > elementCount ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: i) value: (values at: i)!

peekPrevious
	| i |
	i := currentIndex abs - 1.
	i < 1 ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: i) value: (values at: i)! !
!ODBSortedDictionary categoriesFor: #at:!public! !
!ODBSortedDictionary categoriesFor: #at:put:!public! !
!ODBSortedDictionary categoriesFor: #do:!public! !
!ODBSortedDictionary categoriesFor: #findKey:!private! !
!ODBSortedDictionary categoriesFor: #getCurrent!enumerating!public! !
!ODBSortedDictionary categoriesFor: #getFirst!enumerating!public! !
!ODBSortedDictionary categoriesFor: #getLast!enumerating!public! !
!ODBSortedDictionary categoriesFor: #goTo:!enumerating!public! !
!ODBSortedDictionary categoriesFor: #goToNext!enumerating!public! !
!ODBSortedDictionary categoriesFor: #goToPrevious!enumerating!public! !
!ODBSortedDictionary categoriesFor: #includes:!public! !
!ODBSortedDictionary categoriesFor: #initialize!private! !
!ODBSortedDictionary categoriesFor: #keysAndValuesDo:!public! !
!ODBSortedDictionary categoriesFor: #peekNext!enumerating!public! !
!ODBSortedDictionary categoriesFor: #peekPrevious!enumerating!public! !

!ODBSortedDictionary class methodsFor!

new
	^super new initialize! !
!ODBSortedDictionary class categoriesFor: #new!instance creation!public! !

