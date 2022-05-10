"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.PostedActionWindow'
	instanceVariableNames: 'handle actions'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.PostedActionWindow guid: (Core.GUID fromString: '{426dfeaf-6677-40d5-b9ce-713b6f048cc8}')!
Kernel.PostedActionWindow comment: 'PostedActionWindow is a private class used by <InputState> to represent the special message only window created by the VM. This window is used to synchronise with the message queue.

A queue of niladic valuable actions is maintained. When a new action is posted to this queue, a windows message is posted to the message window. When this is picked up by the message pump, it sends #preTranslateMessage:, and if the message was a posted action (and there are posted actions in the queue) then the next posted action is processed. The effect is that posted actions are processed in synchronisation with the message queue by the main UI thread. The mechanism is unlike the old deferred actions mechanism in that it will work even when a modal message loop implemented outside Dolphin is active (e.g. the menu processing loop), and that it will fire actions interspersed with windows messages in the queue on a FIFO basis, rather than processing all windows messages before processing all deferred actions.'!
!Kernel.PostedActionWindow categoriesForClass!System-Support! !
!Kernel.PostedActionWindow methodsFor!

asParameter
	^handle!

dispatchMessage: msgInteger wParam: wParam lParam: lParam
	msgInteger == WM_TIMER
		ifTrue: 
			[SessionManager.Current onTimer: wParam.
			^0].
	^msgInteger == WM_USER
		ifTrue: 
			[self evaluateNextAction.
			0]!

evaluateNextAction
	"Private - Evaluate the next pending action, if any. Answer whether an action was evaluated."

	^actions nextNoWait
		ifNotNil: 
			[:action |
			action value.
			true]
		ifNil: [false]!

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

killTimer: anInteger
	^User32 killTimer: handle uIDEvent: anInteger!

onStartup
	"Private - Ensure that the handle of the receiver is set to nil at startup."

	handle := nil!

postAction: aNiladicValuable
	"Post the <niladicValuable> argument to the queue, to be evaluated in sync with the Windows
	message queue (after any Windows messages currently in the queue), and by the main UI
	thread."

	actions nextPut: aNiladicValuable.
	User32
		postMessage: handle
		msg: WM_USER
		wParam: 0
		lParam: 0!

preTranslateMessage: aMSG
	"Private - Dispatch any posted action requests on the message loop side - we don't want to do this inside a callback."

	| msg |
	msg := aMSG message.
	msg == WM_USER
		ifTrue: 
			[self evaluateNextAction.
			^true].
	^false!

setTimer: idInteger interval: integerOrDuration
	^User32
		setTimer: handle
		nIDEvent: idInteger
		uElapse: integerOrDuration asParameter
		lpTimerFunc: nil! !
!Kernel.PostedActionWindow categoriesForMethods!
asParameter!converting!public! !
dispatchMessage:wParam:lParam:!dispatching!private! !
evaluateNextAction!helpers!private! !
evaluatePendingActions!helpers!private! !
handle:!accessing!private! !
isPersistentView!private!testing! !
isView!accessing!private!testing! !
killTimer:!private!timers! !
onStartup!event handling!private! !
postAction:!operations!private! !
preTranslateMessage:!dispatching!private! !
setTimer:interval:!private!timers! !
!

