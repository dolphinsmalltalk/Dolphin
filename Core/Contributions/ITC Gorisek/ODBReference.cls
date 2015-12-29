"Filed out from Dolphin Smalltalk X6.2"!

ProtoObject subclass: #ODBReference
	instanceVariableNames: 'transactionObject demandLoader'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBReference guid: (GUID fromString: '{8162EDCA-0FB8-11D4-B091-000000000000}')!
ODBReference comment: ''!
!ODBReference categoriesForClass!No category! !
!ODBReference methodsFor!

= anObject 
	(self isIdenticalTo: anObject) == true ifTrue: [^true].
	^demandLoader perform: #= withArguments: (Array with: anObject)!

doesNotUnderstand: aMessage 
	^demandLoader perform: aMessage selector withArguments: aMessage arguments!

inspect
	^demandLoader perform: #inspect withArguments: #()!

instVarAt: index 
	^demandLoader perform: #instVarAt: withArguments: (Array with: index)!

isIdenticalTo: anObject 
	"Answer true if anObject is identical to receiver. This is necessary since with database
	proxies the real object identity is lost because while the object is not yet loaded from the
	database it is represented by its proxy. Later when the real object is loaded this proxy still
	represents the identical object but the #== identity check will answer false because it is not
	aware of this. It is implemented in this way because the #== method is inlined and can not
	be overridden."

	anObject isODBReference ifTrue: [^self odbObjectID = anObject odbObjectID].
	(anObject isNil or: [self odbNotLoaded]) ifTrue: [^false].
	^self odbTransactionObject value == anObject!

isImmediate
	"Private - Answer whether the receiver has an immediate representation (that is it is entirely
	encoded in an object pointer, e.g. SmallIntegers. Most objects are not immediate."

	^false!

isKindOf: candidateClass 
	^demandLoader perform: #isKindOf: withArguments: (Array with: candidateClass)!

isNil
	^false!

isODBReference
	"Answer <true> if receiver is kind of ODReference."

	^true!

makePersistent
	"Do nothing, object is already persistent."

	!

markDirty
	self odbNotLoaded ifFalse: [self odbGetTransaction markDirty: self odbResolve]!

notNil
	^true!

odbGetOID
	transactionObject == nil ifTrue: [^demandLoader odbObjectID].
	^transactionObject objectID!

odbGetTransaction
	"Answer transaction that owns the reference."

	transactionObject isNil ifTrue: [^demandLoader transaction].
	^transactionObject transaction!

odbNotLoaded
	"Answer <true> if the referenced object has not been loaded yet."

	transactionObject notNil ifTrue: [^false].
	^(demandLoader transaction cachedObjectAt: demandLoader odbObjectID) isNil!

odbObjectID
	transactionObject == nil ifTrue: [^demandLoader odbObjectID].
	^transactionObject objectID!

odbResolve
	"See Object>>#odbResolve for comment."

	^transactionObject isNil 
		ifTrue: [demandLoader getObject]
		ifFalse: [transactionObject value]!

odbSerialize: serializer 
	^demandLoader odbSerialize: serializer!

odbSetLoader: aDemandLoader 
	demandLoader := aDemandLoader!

odbSetTransactionObject: anODBTransactionObject 
	"Private - Set transaction object and answer its value."

	transactionObject := anODBTransactionObject.
	^demandLoader := transactionObject value!

odbTransaction
	"Answer transaction that owns the reference."

	transactionObject isNil ifTrue: [^demandLoader transaction].
	^transactionObject transaction!

odbTransactionObject
	transactionObject isNil ifTrue: [demandLoader getObject].
	^transactionObject! !
!ODBReference categoriesFor: #=!message dispatching!public! !
!ODBReference categoriesFor: #doesNotUnderstand:!message dispatching!public! !
!ODBReference categoriesFor: #inspect!message dispatching!public! !
!ODBReference categoriesFor: #instVarAt:!message dispatching!private! !
!ODBReference categoriesFor: #isIdenticalTo:!accessing!public! !
!ODBReference categoriesFor: #isImmediate!public! !
!ODBReference categoriesFor: #isKindOf:!message dispatching!public! !
!ODBReference categoriesFor: #isNil!message dispatching!public! !
!ODBReference categoriesFor: #isODBReference!accessing!public! !
!ODBReference categoriesFor: #makePersistent!accessing!public! !
!ODBReference categoriesFor: #markDirty!accessing!public! !
!ODBReference categoriesFor: #notNil!message dispatching!public! !
!ODBReference categoriesFor: #odbGetOID!accessing!public! !
!ODBReference categoriesFor: #odbGetTransaction!accessing!public! !
!ODBReference categoriesFor: #odbNotLoaded!accessing!private! !
!ODBReference categoriesFor: #odbObjectID!accessing!private! !
!ODBReference categoriesFor: #odbResolve!accessing!public! !
!ODBReference categoriesFor: #odbSerialize:!public!serialization! !
!ODBReference categoriesFor: #odbSetLoader:!accessing!private! !
!ODBReference categoriesFor: #odbSetTransactionObject:!accessing!private! !
!ODBReference categoriesFor: #odbTransaction!accessing!private! !
!ODBReference categoriesFor: #odbTransactionObject!accessing!private! !

