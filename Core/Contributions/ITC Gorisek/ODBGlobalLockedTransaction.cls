"Filed out from Dolphin Smalltalk X6.2"!

ODBLocalTransaction subclass: #ODBGlobalLockedTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGlobalLockedTransaction guid: (GUID fromString: '{8162EE2D-0FB8-11D4-B091-000000000000}')!
ODBGlobalLockedTransaction comment: ''!
!ODBGlobalLockedTransaction categoriesForClass!No category! !
!ODBGlobalLockedTransaction methodsFor!

addLock: aLock 
	"Private - Add aLock to receiver."

	OmniBase signalError: 'Global transaction should not set locks'!

isGlobalLocked
	"Answer <true> if transaction was started in a global locked database session."

	^true!

removeLock: aLock 
	"Private - Remove aLock from receiver."

	OmniBase signalError: 'Global transaction should not set locks'! !
!ODBGlobalLockedTransaction categoriesFor: #addLock:!private! !
!ODBGlobalLockedTransaction categoriesFor: #isGlobalLocked!public! !
!ODBGlobalLockedTransaction categoriesFor: #removeLock:!private! !

