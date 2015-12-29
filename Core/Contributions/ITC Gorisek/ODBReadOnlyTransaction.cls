"Filed out from Dolphin Smalltalk X6.2"!

ODBLocalTransaction subclass: #ODBReadOnlyTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBReadOnlyTransaction guid: (GUID fromString: '{D1EB92FD-3F84-11D4-B102-000000000000}')!
ODBReadOnlyTransaction comment: ''!
!ODBReadOnlyTransaction categoriesForClass!Unclassified! !
!ODBReadOnlyTransaction methodsFor!

addLock: aLock 
	"Private - Add anODBLock to receiver."

	OmniBase signalError: 'Read-only transaction should not set locks'!

checkpoint
	"Do nothing."

	!

commit
	"Do nothing."

	self abort!

isChanged
	^false!

isReadOnly
	"Answer <true> if this is a read-only transaction."

	^true!

lock: anObject 
	^true!

makePersistent: anObject in: aContainerOrContainerName 
	"Do nothing."

	^anObject!

markDirty: anObject 
	"Do nothing."

	!

removeLock: aLock 
	"Private - Remove anODBLock from receiver."

	OmniBase signalError: 'Read-only transaction should not set locks'!

store: anObject in: containerName ifLocked: aBlock 
	"Do nothing."

	^anObject!

unlock: anObject 
	^true! !
!ODBReadOnlyTransaction categoriesFor: #addLock:!private! !
!ODBReadOnlyTransaction categoriesFor: #checkpoint!public! !
!ODBReadOnlyTransaction categoriesFor: #commit!public! !
!ODBReadOnlyTransaction categoriesFor: #isChanged!public! !
!ODBReadOnlyTransaction categoriesFor: #isReadOnly!public! !
!ODBReadOnlyTransaction categoriesFor: #lock:!public! !
!ODBReadOnlyTransaction categoriesFor: #makePersistent:in:!public! !
!ODBReadOnlyTransaction categoriesFor: #markDirty:!public! !
!ODBReadOnlyTransaction categoriesFor: #removeLock:!private! !
!ODBReadOnlyTransaction categoriesFor: #store:in:ifLocked:!public! !
!ODBReadOnlyTransaction categoriesFor: #unlock:!public! !

