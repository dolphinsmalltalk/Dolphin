"Filed out from Dolphin Smalltalk X6.2"!

Notification subclass: #ODBLockNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLockNotification guid: (GUID fromString: '{8162EDF4-0FB8-11D4-B091-000000000000}')!
ODBLockNotification comment: ''!
!ODBLockNotification categoriesForClass!No category! !
!ODBLockNotification methodsFor!

defaultAction
	"Display a notifier and then continue."

	^OmniBase confirmationMessage: 'File can not be locked. Do you want to try again?'! !
!ODBLockNotification categoriesFor: #defaultAction!public! !

