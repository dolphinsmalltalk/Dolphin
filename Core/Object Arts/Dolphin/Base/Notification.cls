"Filed out from Dolphin Smalltalk"!

Exception subclass: #Notification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!
Notification guid: (GUID fromString: '{87b4c556-026e-11d3-9fd7-00a0cc3e4a32}')!
Notification comment: 'Notification is the class of exceptional conditions which are not considered errors.'!
!Notification categoriesForClass!Kernel-Exception Handling! !
!Notification methodsFor!

defaultAction
	"The receiver is an unhandled notification, perform the default action
	(forward to the SessionManager for application customisation).
	N.B. The ANSI standard states that no action is taken, which seems a little
	lacking in imagination."

	^SessionManager current 
		ifNil: [KernelLibrary default outputDebugString: self description , String lineDelimiter]
		ifNotNil: [:session | session onUnhandledNotification: self]!

hresult
	"Answer the <HRESULT> error/status code associated with the receiver."

	^HRESULT ok!

isResumable
	"Answer whether the receiver represents a resumable exception. 
	Notifications are almost always resumable."

	^true! !
!Notification categoriesForMethods!
defaultAction!handling!public! !
hresult!accessing!public! !
isResumable!public!testing! !
!

Notification methodProtocol: #Notification attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Notification class methodsFor!

deprecated
	"Raise a warning to the effect that the sender is a deprecated method."

	| sender |
	sender := Processor activeProcess topFrame sender.
	^self signal: 'Deprecated message sent: ', sender method printString, ' from: ', sender sender method printString!

mbIconId
	^MB_ICONINFORMATION!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Notification! !
!Notification class categoriesForMethods!
deprecated!instance creation!public! !
mbIconId!parping!public! !
severityClass!constants!public! !
!

Notification class methodProtocol: #'Notification class' attributes: #(#ansi #readOnly) selectors: #(#, #allSubclasses #allSuperclasses #handles: #name #new #signal #signal: #subclasses #superclass)!

