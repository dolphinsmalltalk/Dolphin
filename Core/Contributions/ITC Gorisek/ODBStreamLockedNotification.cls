"Filed out from Dolphin Smalltalk X6.2"!

Notification subclass: #ODBStreamLockedNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBStreamLockedNotification guid: (GUID fromString: '{8162EDF5-0FB8-11D4-B091-000000000000}')!
ODBStreamLockedNotification comment: ''!
!ODBStreamLockedNotification categoriesForClass!No category! !
!ODBStreamLockedNotification methodsFor!

defaultAction
	^OmniBase 
		confirmationMessage: 'File can not be read because it is locked. Do you want to try again ?'! !
!ODBStreamLockedNotification categoriesFor: #defaultAction!public! !

