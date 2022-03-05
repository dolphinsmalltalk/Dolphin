"Filed out from Dolphin Smalltalk"!

SmalllintContext subclass: #SmalllintCachingContext
	instanceVariableNames: ''
	classVariableNames: 'Literals Mtx Selectors'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalllintCachingContext guid: (GUID fromString: '{8dc28c1a-eaf8-479b-9393-8e00da03fc44}')!
SmalllintCachingContext comment: ''!
!SmalllintCachingContext categoriesForClass!Refactory-Lint! !
!SmalllintCachingContext methodsFor!

computeLiterals
	(Literals isNil or: [Selectors isNil]) 
		ifTrue: 
			[self mutex critical: [self primitiveComputeLiterals].
			Selectors := selectors.
			Literals := literals].
	literals := Literals.
	selectors := Selectors!

initialize
	"Not sure why the superclass computes literals/selectors at this point. Anyawy we choose not to do it."

!

literals
	literals isNil ifTrue: [self computeLiterals].
	^literals
!

mutex
	^Mtx!

selectors
	selectors isNil ifTrue: [self computeLiterals].
	^selectors
! !
!SmalllintCachingContext categoriesForMethods!
computeLiterals!helpers!private! !
initialize!initialize/release!public! !
literals!accessing!public! !
mutex!accessing!private! !
selectors!accessing!public! !
!

!SmalllintCachingContext class methodsFor!

clearCache
	Literals := Selectors := nil!

initialize
	"Private - Initialize the receiver. Monitor the devlopment environment to see if the cache has been invalidated

	self initialize
	"

	Mtx := Mutex new.
	(self systemModel)
		removeEventsTriggeredFor: self;
		when: #methodAdded:
			send: #clearCache
			to: self;
		when: #methodUpdated:
			send: #clearCache
			to: self;
		when: #methodRemoved:
			send: #clearCache
			to: self;
		when: #classRemoved:
			send: #clearCache
			to: self!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application."

	"When selectors are being removed following encryption our #clearCache method get's called"

	^false!

systemModel
	^Smalltalk developmentSystem!

uninitialize
	self clearCache.
	self systemModel removeEventsTriggeredFor: self! !
!SmalllintCachingContext class categoriesForMethods!
clearCache!operations!private! !
initialize!class initialization!private! !
isSafeToEncryptWithProductProtection!constants!public!testing! !
systemModel!accessing!private! !
uninitialize!class initialization!private! !
!

