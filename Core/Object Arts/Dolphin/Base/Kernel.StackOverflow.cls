"Filed out from Dolphin Smalltalk 7"!

Core.Exception subclass: #'Kernel.StackOverflow'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StackOverflow guid: (Core.GUID fromString: '{8d4d9414-edd2-4a90-a4fb-2886ec495d39}')!
Kernel.StackOverflow comment: 'Exception signalled when the VM detects an unrecoverable stack overflow in a process. Note that this is not a subclass of <Error> in order that it is not trapped by generic error handlers.'!
!Kernel.StackOverflow categoriesForClass!Kernel-Exception Handling! !
!Kernel.StackOverflow methodsFor!

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
!Kernel.StackOverflow categoriesFor: #_descriptionArguments!displaying!public! !
!Kernel.StackOverflow categoriesFor: #defaultAction!handling!public! !
!Kernel.StackOverflow categoriesFor: #hresult!accessing!public! !

