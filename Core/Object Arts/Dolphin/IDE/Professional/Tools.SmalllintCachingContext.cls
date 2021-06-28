"Filed out from Dolphin Smalltalk"!

Refactory.Browser.SmalllintContext subclass: #'Tools.SmalllintCachingContext'
	instanceVariableNames: ''
	classVariableNames: 'Literals Mtx Selectors'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalllintCachingContext guid: (Core.GUID fromString: '{8dc28c1a-eaf8-479b-9393-8e00da03fc44}')!
Tools.SmalllintCachingContext comment: ''!
!Tools.SmalllintCachingContext categoriesForClass!Refactory-Lint! !
!Tools.SmalllintCachingContext methodsFor!

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
!Tools.SmalllintCachingContext categoriesFor: #computeLiterals!helpers!private! !
!Tools.SmalllintCachingContext categoriesFor: #initialize!initialize/release!public! !
!Tools.SmalllintCachingContext categoriesFor: #literals!accessing!public! !
!Tools.SmalllintCachingContext categoriesFor: #mutex!accessing!private! !
!Tools.SmalllintCachingContext categoriesFor: #selectors!accessing!public! !

!Tools.SmalllintCachingContext class methodsFor!

clearCache
	Literals := Selectors := nil!

initialize
	"Private - Initialize the receiver. Monitor the devlopment environment to see if the cache has been invalidated

	self initialize
	"

	Mtx := Mutex new.
	self systemModel
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
	^SmalltalkSystem current!

uninitialize
	self clearCache.
	self systemModel removeEventsTriggeredFor: self! !
!Tools.SmalllintCachingContext class categoriesFor: #clearCache!operations!private! !
!Tools.SmalllintCachingContext class categoriesFor: #initialize!class initialization!private! !
!Tools.SmalllintCachingContext class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!Tools.SmalllintCachingContext class categoriesFor: #systemModel!accessing!private! !
!Tools.SmalllintCachingContext class categoriesFor: #uninitialize!class initialization!private! !

