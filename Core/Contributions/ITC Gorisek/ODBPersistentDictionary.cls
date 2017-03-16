"Filed out from Dolphin Smalltalk 7"!

LookupTable variableSubclass: #ODBPersistentDictionary
	instanceVariableNames: 'transaction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBPersistentDictionary guid: (GUID fromString: '{8162edec-0fb8-11d4-b091-000000000000}')!
ODBPersistentDictionary comment: ''!
!ODBPersistentDictionary categoriesForClass!No category! !
!ODBPersistentDictionary methodsFor!

add: anAssociation 
	| t |
	t := transaction.
	anAssociation key isODBReference ifTrue: [self error: 'Invalid key!!'].
	super add: anAssociation.
	transaction := t.
	transaction isNil ifTrue: [^anAssociation].
	anAssociation value isImmediate 
		ifFalse: [transaction makePersistent: anAssociation value].
	transaction markDirty: self.
	^anAssociation!

asDictionary
	| dict |
	dict := Dictionary new.
	self associationsDo: [:assoc | dict add: assoc].
	^dict!

at: key ifAbsentPut: operation 
	^self at: key ifAbsent: [self at: key put: operation value]!

at: key put: value 
	| oldValue |
	key isODBReference ifTrue: [self error: 'Invalid key!!'].
	oldValue := super at: key ifAbsent: [].
	value == oldValue ifTrue: [^value].
	oldValue := transaction.
	super at: key put: value.
	transaction := oldValue.
	transaction isNil ifTrue: [^value].
	transaction markDirty: self.
	(value isImmediate or: [value == key]) ifFalse: [transaction makePersistent: value].
	^value!

odbBasicSerialize: serializer 
	(serializer stream)
		putByte: 83;
		putPositiveInteger: self size.
	self keysAndValuesDo: 
			[:key :value | 
			key odbSerialize: serializer.
			value odbSerialize: serializer]!

odbLoadedIn: anOmniBaseTransaction 
	"This method is sent when the object is loaded from the database."

	transaction := anOmniBaseTransaction!

odbMadePersistentIn: anOmniBaseTransaction 
	"This method is sent when the object is made persistent."

	transaction notNil 
		ifTrue: [self error: 'Object is already persistent in another transaction'].
	transaction := anOmniBaseTransaction.
	self do: [:each | each isImmediate ifFalse: [transaction makePersistent: each]]!

removeKey: aKey ifAbsent: aBlock 
	| t |
	t := transaction.
	super removeKey: aKey ifAbsent: [^aBlock value].
	transaction := t.
	transaction isNil ifFalse: [transaction markDirty: self]!

superAt: key put: value 
	^super at: key put: value!

transaction
	^transaction! !
!ODBPersistentDictionary categoriesFor: #add:!public! !
!ODBPersistentDictionary categoriesFor: #asDictionary!public! !
!ODBPersistentDictionary categoriesFor: #at:ifAbsentPut:!public! !
!ODBPersistentDictionary categoriesFor: #at:put:!public! !
!ODBPersistentDictionary categoriesFor: #odbBasicSerialize:!public! !
!ODBPersistentDictionary categoriesFor: #odbLoadedIn:!private! !
!ODBPersistentDictionary categoriesFor: #odbMadePersistentIn:!private! !
!ODBPersistentDictionary categoriesFor: #removeKey:ifAbsent:!public! !
!ODBPersistentDictionary categoriesFor: #superAt:put:!public! !
!ODBPersistentDictionary categoriesFor: #transaction!public! !

!ODBPersistentDictionary class methodsFor!

odbDeserialize: deserializer 
	| size dict key |
	size := deserializer stream getPositiveInteger.
	dict := self new: size.
	deserializer register: dict.
	size timesRepeat: 
			[key := deserializer odbNextObject.
			dict superAt: key put: deserializer odbNextObject].
	^dict! !
!ODBPersistentDictionary class categoriesFor: #odbDeserialize:!public! !

