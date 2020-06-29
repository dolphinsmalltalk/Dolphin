"Filed out from Dolphin Smalltalk 7"!

Exception subclass: #StackOverflow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StackOverflow guid: (GUID fromString: '{8d4d9414-edd2-4a90-a4fb-2886ec495d39}')!
StackOverflow comment: 'Exception signalled when the VM detects an unrecoverable stack overflow in a process. Note that this is not a subclass of <Error> in order that it is not trapped by generic error handlers.'!
!StackOverflow categoriesForClass!Kernel-Exception Handling! !
!StackOverflow methodsFor!

_descriptionArguments
	"Answer the arguments to be substituted into the receiver's Win32 description format String."

	^{self hresult displayString}!

defaultAction
	"Perform the default action for the receiver if it is not handled
	(forward to the SessionManager for application specific handling."

	^SessionManager current onUnhandledError: self!

hresult
	"Answer the <HRESULT> error/status code associated with the receiver."

	^HRESULT win32Error: ERROR_STACK_OVERFLOW! !
!StackOverflow categoriesFor: #_descriptionArguments!displaying!public! !
!StackOverflow categoriesFor: #defaultAction!handling!public! !
!StackOverflow categoriesFor: #hresult!accessing!public! !

