"Filed out from Dolphin Smalltalk X6.2"!

ODBIdentityDictionary subclass: #ODBWeakValueIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBWeakValueIdentityDictionary guid: (GUID fromString: '{8162EE25-0FB8-11D4-B091-000000000000}')!
ODBWeakValueIdentityDictionary comment: ''!
!ODBWeakValueIdentityDictionary categoriesForClass!No category! !
!ODBWeakValueIdentityDictionary methodsFor!

at: anObject 
	"Answer value at anObject, <nil> if absent."

	| index lastIndex key value |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^nil].
			index == lastIndex ifTrue: [index := 0]].
	(value := values at: index) == DeadObject current ifFalse: [^value].
	keys at: index put: DeadObject current.
	^nil!

at: anObject ifAbsent: aBlock 
	| index lastIndex key value |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^aBlock value].
			index == lastIndex ifTrue: [index := 0]].
	(value := values at: index) == DeadObject current ifFalse: [^value].
	keys at: index put: DeadObject current.
	^aBlock value!

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
					(elementCount := elementCount + 1) >= sizeLimit ifTrue: [self grow].
					^anObject].
			(key == DeadObject current or: [(values at: index) == DeadObject current]) 
				ifTrue: 
					[keys at: index put: aKey.
					^values at: index put: anObject].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index put: anObject!

do: aBlock 
	"Evaluate aBlock for each value in dictionary."

	| value key |
	1 to: keys size
		do: 
			[:i | 
			key := keys at: i.
			(key isNil 
				or: [key == DeadObject current or: [(value := values at: i) == DeadObject current]]) 
					ifFalse: [aBlock value: value]]!

initialize: anInteger 
	super initialize: anInteger.
	values beWeak! !
!ODBWeakValueIdentityDictionary categoriesFor: #at:!public! !
!ODBWeakValueIdentityDictionary categoriesFor: #at:ifAbsent:!public! !
!ODBWeakValueIdentityDictionary categoriesFor: #at:put:!public! !
!ODBWeakValueIdentityDictionary categoriesFor: #do:!public! !
!ODBWeakValueIdentityDictionary categoriesFor: #initialize:!private! !

