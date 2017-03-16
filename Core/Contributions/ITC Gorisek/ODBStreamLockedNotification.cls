"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #ODBStreamLockedNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBStreamLockedNotification guid: (GUID fromString: '{8162edf5-0fb8-11d4-b091-000000000000}')!
ODBStreamLockedNotification comment: ''!
!ODBStreamLockedNotification categoriesForClass!No category! !
!ODBStreamLockedNotification methodsFor!

defaultAction
	^OmniBase 
		confirmationMessage: 'File can not be read because it is locked. Do you want to try again ?'! !
!ODBStreamLockedNotification categoriesFor: #defaultAction!public! !

