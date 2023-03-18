"Filed out from Dolphin Smalltalk"!

Core.Exception
	subclass: #'Core.Notification'
	instanceVariableNames: 'isSuppressible'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Notification guid: (Core.GUID fromString: '{87b4c556-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Notification comment: 'Notification is the class of exceptional conditions which are not considered errors.'!
!Core.Notification categoriesForClass!Kernel-Exception Handling! !
!Core.Notification methodsFor!

defaultAction
	"The receiver is an unhandled notification, perform the default action
	(forward to the SessionManager for application customisation).
	N.B. The ANSI standard states that no action is taken, which seems a little
	lacking in imagination."

	^SessionManager.Current
		ifNil: [OS.Kernel32 outputDebugString: self description , String lineDelimiter]
		ifNotNil: [:session | session onUnhandledNotification: self]!

hresult
	"Answer the <HRESULT> error/status code associated with the receiver."

	^OS.HRESULT ok!

initialize
	super initialize.
	isSuppressible := false!

isResumable
	"Answer whether the receiver represents a resumable exception. 
	Notifications are almost always resumable."

	^true!

isSuppressible
	^isSuppressible!

isSuppressible: aBoolean
	isSuppressible := aBoolean! !
!Core.Notification categoriesForMethods!
defaultAction!handling!public! !
hresult!accessing!public! !
initialize!initializing!public! !
isResumable!public!testing! !
isSuppressible!accessing!public! !
isSuppressible:!accessing!public! !
!

Core.Notification methodProtocol: #Notification attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Core.Notification class methodsFor!

deprecated
	"Raise a warning to the effect that the sender is a deprecated method."

	| sender |
	sender := Processor activeProcess topFrame sender.
	^self signal: 'Deprecated message sent: ', sender method printString, ' from: ', sender sender method printString!

iconStyle
	"Answer an exception class describing the severity of the notification."

	^#notify!

mbIconId
	^MB_ICONINFORMATION!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Notification! !
!Core.Notification class categoriesForMethods!
deprecated!instance creation!public! !
iconStyle!constants!public! !
mbIconId!parping!public! !
severityClass!constants!public! !
!

Core.Notification class methodProtocol: #'Notification class' attributes: #(#ansi #readOnly) selectors: #(#, #allSubclasses #allSuperclasses #handles: #name #new #signal #signal: #subclasses #superclass)!

