"Filed out from Dolphin Smalltalk 7"!

Core.Notification subclass: #'Core.Warning'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Warning guid: (Core.GUID fromString: '{87b4c571-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Warning comment: 'Warning is the class of <Notification>s which represent exceptional conditions that are not considered errors, but which should still be reported to the user with the option to continue or abort the computation.'!
!Core.Warning categoriesForClass!Kernel-Exception Handling! !
!Core.Warning methodsFor!

defaultAction
	"Perform the default action for the receiver if it is not handled
	(forward to the SessionManager for application specific handling).
	N.B. The ANSI standard states that the user should be given the option to
	either continue or abort the computation, and indeed that is what the
	standard SessionManager implementation does.	"

	"Will not return unless execution is to be resumed"

	^SessionManager current onUnhandledWarning: self! !
!Core.Warning categoriesFor: #defaultAction!handling!public! !

Core.Warning methodProtocol: #Warning attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Core.Warning class methodsFor!

mbIconId
	^MB_ICONWARNING!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Warning! !
!Core.Warning class categoriesFor: #mbIconId!parping!public! !
!Core.Warning class categoriesFor: #severityClass!constants!public! !

