"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBIdentityDictionary
	instanceVariableNames: 'keys values elementCount sizeLimit emptySlotMarker'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBIdentityDictionary guid: (GUID fromString: '{8162EDDC-0FB8-11D4-B091-000000000000}')!
ODBIdentityDictionary comment: ''!
!ODBIdentityDictionary categoriesForClass!No category! !
!ODBIdentityDictionary methodsFor!

associationsDo: aBlock 
	"Evaluate aBlock for each value in dictionary."

	| key |
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) 
				ifFalse: [aBlock value: (Association key: key value: (values at: i))]]!

at: anObject 
	"Answer value at anObject, <nil> if absent."

	| index lastIndex key |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^nil].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index!

at: anObject ifAbsent: aBlock 
	| index lastIndex key |
	anObject isNil ifTrue: [^aBlock value].
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^aBlock value].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index!

at: anObject ifAbsentPut: aBlock 
	^self at: anObject ifAbsent: [self at: anObject put: aBlock value]!

at: aKey ifAbsentPutValue: anObject 
	^self at: aKey ifAbsent: [self at: aKey put: anObject]!

at: aKey put: anObject 
	"Answer anObject. If aKey exists in the receiver,
	replace the corresponding value with anObject, else
	add the aKey/anObject pair to the receiver."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[aKey == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil 
				ifTrue: 
					[keys at: index put: aKey.
					values at: index put: anObject.
					(elementCount := elementCount + 1) < sizeLimit ifFalse: [self grow].
					^anObject].
			key == emptySlotMarker 
				ifTrue: 
					[keys at: index put: aKey.
					^values at: index put: anObject].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index put: anObject!

do: aBlock 
	"Evaluate aBlock for each value in dictionary."

	| key |
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) ifFalse: [aBlock value: (values at: i)]]!

grow
	"Private - Grow the receiver to double size to accomodate more key/value pairs."

	| oldSize oldValues oldKeys key value |
	oldKeys := keys.
	oldSize := keys size.
	oldValues := values.
	self initialize: oldSize * 2.
	1 to: oldSize
		do: 
			[:index | 
			key := oldKeys at: index.
			(key isNil 
				or: [key == emptySlotMarker or: [(value := oldValues at: index) == emptySlotMarker]]) 
					ifFalse: [self at: key put: value]]!

includesKey: anObject 
	| index lastIndex key |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^false].
			index == lastIndex ifTrue: [index := 0]].
	^true!

initialize: anInteger 
	elementCount := 0.
	keys := Array new: anInteger.
	values := Array new: anInteger.
	sizeLimit := (anInteger - 2) * 11 // 23.
	emptySlotMarker := DeadObject current!

isEmpty
	^self size == 0!

keysAndValuesDo: aBlock 
	"Evaluate aBlock for each value in dictionary."

	| key |
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) 
				ifFalse: [aBlock value: key value: (values at: i)]]!

removeKey: aKey 
	"Remove aKey from receiver. Do nothing if absent."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[aKey == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^self].
			index == lastIndex ifTrue: [index := 0]].
	keys at: index put: emptySlotMarker.
	^values at: index put: nil!

removeKey: aKey ifAbsent: aBlock 
	"Remove aKey from receiver. Evaluate aBlock if absent."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[aKey == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^aBlock value].
			index == lastIndex ifTrue: [index := 0]].
	keys at: index put: emptySlotMarker.
	^values at: index put: nil!

size
	"Answer number of elements in dictionary."

	| count key |
	count := 0.
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) ifFalse: [count := count + 1]].
	^count!

values
	| coll key |
	coll := OrderedCollection new: elementCount.
	1 to: values size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil or: [key == emptySlotMarker]) ifFalse: [coll add: (values at: i)]].
	^coll! !
!ODBIdentityDictionary categoriesFor: #associationsDo:!public! !
!ODBIdentityDictionary categoriesFor: #at:!public! !
!ODBIdentityDictionary categoriesFor: #at:ifAbsent:!public! !
!ODBIdentityDictionary categoriesFor: #at:ifAbsentPut:!public! !
!ODBIdentityDictionary categoriesFor: #at:ifAbsentPutValue:!public! !
!ODBIdentityDictionary categoriesFor: #at:put:!public! !
!ODBIdentityDictionary categoriesFor: #do:!public! !
!ODBIdentityDictionary categoriesFor: #grow!private! !
!ODBIdentityDictionary categoriesFor: #includesKey:!public! !
!ODBIdentityDictionary categoriesFor: #initialize:!private! !
!ODBIdentityDictionary categoriesFor: #isEmpty!public! !
!ODBIdentityDictionary categoriesFor: #keysAndValuesDo:!public! !
!ODBIdentityDictionary categoriesFor: #removeKey:!public! !
!ODBIdentityDictionary categoriesFor: #removeKey:ifAbsent:!public! !
!ODBIdentityDictionary categoriesFor: #size!public! !
!ODBIdentityDictionary categoriesFor: #values!public! !

!ODBIdentityDictionary class methodsFor!

new
	^self new: 30!

new: anInteger 
	^super new initialize: anInteger * 2 + 1!

odbDeserialize: deserializer 
	| size dict key |
	size := deserializer stream getPositiveInteger.
	dict := self new: size.
	deserializer register: dict.
	size timesRepeat: 
			[key := deserializer odbNextObject.
			dict at: key put: deserializer odbNextObject].
	^dict! !
!ODBIdentityDictionary class categoriesFor: #new!instance creation!public! !
!ODBIdentityDictionary class categoriesFor: #new:!instance creation!public! !
!ODBIdentityDictionary class categoriesFor: #odbDeserialize:!public!serialization! !

