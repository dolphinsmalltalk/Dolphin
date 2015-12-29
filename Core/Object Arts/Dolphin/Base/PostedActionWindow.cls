"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #PostedActionWindow
	instanceVariableNames: 'handle actions'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
PostedActionWindow guid: (GUID fromString: '{426DFEAF-6677-40D5-B9CE-713B6F048CC8}')!
PostedActionWindow comment: 'PostedActionWindow is a private class used by <InputState> to represent the special message only window created by the VM. This window is used to synchronise with the message queue.

A queue of niladic valuable actions is maintained. When a new action is posted to this queue, a windows message is posted to the message window. When this is picked up by the message pump, it sends #preTranslateMessage:, and if the message was a posted action (and there are posted actions in the queue) then the next posted action is processed. The effect is that posted actions are processed in synchronisation with the message queue by the main UI thread. The mechanism is unlike the old deferred actions mechanism in that it will work even when a modal message loop implemented outside Dolphin is active (e.g. the menu processing loop), and that it will fire actions interspersed with windows messages in the queue on a FIFO basis, rather than processing all windows messages before processing all deferred actions.'!
!PostedActionWindow categoriesForClass!System-Support! !
!PostedActionWindow methodsFor!

asParameter
	^handle!

dispatchMessage: msgInteger wParam: wParam lParam: lParam 
	^msgInteger == WM_USER 
		ifTrue: 
			[self evaluateNextAction.
			0]!

evaluateNextAction
	"Private - Evaluate the next pending action, if any. Answer whether an action was evaluated."

	^actions nextNoWait 
		ifNil: [false]
		ifNotNil: 
			[:action | 
			action value.
			true]!

evaluatePendingActions
	"Private - Evaluate  all pending actions, if any. Answer whether any actions were evaluated."

	| activity |
	activity := false.
	[self evaluateNextAction] whileTrue: [activity := true].
	^activity!

handle: anObject
	actions := SharedQueue new.
	handle := anObject!

isPersistentView
	"Private - Answer whether the receiver has persistent state which can and should
	be persistent in the image (i.e. top-level windows which answer true
	to this will be sent #state and #state: messages by the 
	SessionManager before the image is saved, and on session startup, respectively)."

	^false!

isView
	"Private - Answer whether the receiver is a View."

	^false!

onStartup
	"Private - Ensure that the handle of the receiver is set to nil at startup."

	handle := nil!

postAction: aNiladicValuable 
	"Post the <niladicValuable> argument to the queue, to be evaluated in sync with the Windows
	message queue (after any Windows messages currently in the queue), and by the main UI
	thread."

	actions nextPut: aNiladicValuable.
	UserLibrary default 
		postMessage: handle
		msg: WM_USER
		wParam: 0
		lParam: 0!

preTranslateMessage: aMSG 
	"Private - Dispatch any posted action requests on the message loop side - we don't want to
	do this inside a callback. Also the window belongs to the VM, and messages are not
	dispatched into the image anyway."

	^aMSG message == WM_USER and: 
			[self evaluateNextAction.
			true]! !
!PostedActionWindow categoriesFor: #asParameter!converting!public! !
!PostedActionWindow categoriesFor: #dispatchMessage:wParam:lParam:!dispatching!private! !
!PostedActionWindow categoriesFor: #evaluateNextAction!helpers!private! !
!PostedActionWindow categoriesFor: #evaluatePendingActions!helpers!private! !
!PostedActionWindow categoriesFor: #handle:!accessing!private! !
!PostedActionWindow categoriesFor: #isPersistentView!private!testing! !
!PostedActionWindow categoriesFor: #isView!accessing!private!testing! !
!PostedActionWindow categoriesFor: #onStartup!event handling!private! !
!PostedActionWindow categoriesFor: #postAction:!operations!private! !
!PostedActionWindow categoriesFor: #preTranslateMessage:!dispatching!private! !

