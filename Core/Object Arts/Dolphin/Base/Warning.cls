"Filed out from Dolphin Smalltalk X6.1"!

Notification subclass: #Warning
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Warning guid: (GUID fromString: '{87B4C571-026E-11D3-9FD7-00A0CC3E4A32}')!
Warning comment: 'Warning is the class of <Notification>s which represent exceptional conditions that are not considered errors, but which should still be reported to the user with the option to continue or abort the computation.'!
!Warning categoriesForClass!Kernel-Exception Handling! !
!Warning methodsFor!

defaultAction
	"Perform the default action for the receiver if it is not handled
	(forward to the SessionManager for application specific handling).
	N.B. The ANSI standard states that the user should be given the option to
	either continue or abort the computation, and indeed that is what the
	standard SessionManager implementation does.	"

	"Will not return unless execution is to be resumed"
	^SessionManager current onUnhandledWarning: self! !
!Warning categoriesFor: #defaultAction!handling!public! !

Warning methodProtocol: #Warning attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Warning class methodsFor!

mbIconId
	^MB_ICONWARNING!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Warning! !
!Warning class categoriesFor: #mbIconId!parping!public! !
!Warning class categoriesFor: #severityClass!constants!public! !

