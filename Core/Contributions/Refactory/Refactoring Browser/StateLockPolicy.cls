"Filed out from Dolphin Smalltalk 2000 release 4.01"!

CodeModelLockPolicy subclass: #StateLockPolicy
	instanceVariableNames: 'locked'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StateLockPolicy comment: ''!

StateLockPolicy guid: (GUID fromString: '{A8B6C1C7-0E73-11D5-B80B-000102677BBF}')!

!StateLockPolicy categoriesForClass!Unclassified! !
!StateLockPolicy methodsFor!

initialize
	super initialize.
	locked := false!

isLocked
	^locked!

lock
	locked := true!

unlock
	locked := false! !
!StateLockPolicy categoriesFor: #initialize!*-unclassified!public! !
!StateLockPolicy categoriesFor: #isLocked!*-unclassified!public! !
!StateLockPolicy categoriesFor: #lock!*-unclassified!public! !
!StateLockPolicy categoriesFor: #unlock!*-unclassified!public! !

