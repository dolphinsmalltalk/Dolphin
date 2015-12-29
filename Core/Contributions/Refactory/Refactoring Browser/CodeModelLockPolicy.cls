"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Object subclass: #CodeModelLockPolicy
	instanceVariableNames: ''
	classVariableNames: 'WindowHandleCache'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CodeModelLockPolicy comment: ''!

CodeModelLockPolicy guid: (GUID fromString: '{A8B6C1C6-0E73-11D5-B80B-000102677BBF}')!

!CodeModelLockPolicy categoriesForClass!Unclassified! !
!CodeModelLockPolicy methodsFor!

initialize!

isLocked
	^false!

lock!

on: aCodeTool!

unlock! !
!CodeModelLockPolicy categoriesFor: #initialize!*-unclassified!public! !
!CodeModelLockPolicy categoriesFor: #isLocked!*-unclassified!public! !
!CodeModelLockPolicy categoriesFor: #lock!*-unclassified!public! !
!CodeModelLockPolicy categoriesFor: #on:!*-unclassified!public! !
!CodeModelLockPolicy categoriesFor: #unlock!*-unclassified!public! !

!CodeModelLockPolicy class methodsFor!

flushCache
	WindowHandleCache := nil!

on: aCodeTool 
	^(self new)
		initialize;
		on: aCodeTool;
		yourself! !
!CodeModelLockPolicy class categoriesFor: #flushCache!*-unclassified!public! !
!CodeModelLockPolicy class categoriesFor: #on:!*-unclassified!public! !

