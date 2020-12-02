"Filed out from Dolphin Smalltalk 7"!

SmalllintContext subclass: #SmalllintCachingContext
	instanceVariableNames: ''
	classVariableNames: 'Literals Mtx Selectors'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SmalllintCachingContext categoriesFor: #computeLiterals!helpers!private! !
!SmalllintCachingContext categoriesFor: #initialize!initialize/release!public! !
!SmalllintCachingContext categoriesFor: #literals!accessing!public! !
!SmalllintCachingContext categoriesFor: #mutex!accessing!private! !
!SmalllintCachingContext categoriesFor: #selectors!accessing!public! !

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
!SmalllintCachingContext class categoriesFor: #clearCache!operations!private! !
!SmalllintCachingContext class categoriesFor: #initialize!class initialization!private! !
!SmalllintCachingContext class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!SmalllintCachingContext class categoriesFor: #systemModel!accessing!private! !
!SmalllintCachingContext class categoriesFor: #uninitialize!class initialization!private! !

