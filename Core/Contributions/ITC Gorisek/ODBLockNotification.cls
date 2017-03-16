"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #ODBLockNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLockNotification guid: (GUID fromString: '{8162edf4-0fb8-11d4-b091-000000000000}')!
ODBLockNotification comment: ''!
!ODBLockNotification categoriesForClass!No category! !
!ODBLockNotification methodsFor!

defaultAction
	"Display a notifier and then continue."

	^OmniBase confirmationMessage: 'File can not be locked. Do you want to try again?'! !
!ODBLockNotification categoriesFor: #defaultAction!public! !

