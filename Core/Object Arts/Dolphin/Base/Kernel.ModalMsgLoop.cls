"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.ModalMsgLoop'
	instanceVariableNames: 'loop'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ModalMsgLoop guid: (Core.GUID fromString: '{9fe23040-75a9-11d3-b376-080046056106}')!
Kernel.ModalMsgLoop comment: 'ModalMsgLoop is a special process synchronisation object that can be used to block the main UI process while still servicing the message queue, without having to start a new UI process.

For example:

	sync := ModalMsgLoop new.
	[(Delay forSeconds: 10) wait. sync signal] fork.
	sync wait.
	Sound bell.

This will ring the bell after 10 seconds, without preventing the UI from updating. Of course this is a contrived example, since this could be achieved more easily by performing the delayed operation from the background process forked off to wait on the delay, however the mechanism is useful where one really wants to block the main UI process temporarily. Note that while the modal loop is active the <InputState>''s message pump will continue to dispatch all arriving Windows messages. If the requirement is that the application stop accepting further input while the modal loop is active (i.e. one just wants it to keep painting, not respond to further commands) it will be necessary to explicitly disable the application''s Windows.

Instance Variables:
	loop		<boolean>. Used to control termination of the modal loop.

'!
!Kernel.ModalMsgLoop categoriesForClass!Kernel-Processes! !
!Kernel.ModalMsgLoop methodsFor!

initialize
	"Private - Initialize the receiver's instance variables."

	loop := true!

signal
	"Terminate the modal loop, and return control to the sender of #wait."

	loop := false.
	SessionManager.Current inputState prod!

wait
	"Start the modal loop, returning when the receiver is signalled. While waiting the Windows
	message loop continues to be serviced, but keyboard and mouse input is discarded."

	SessionManager.Current inputState loopWhile: [loop]! !
!Kernel.ModalMsgLoop categoriesForMethods!
initialize!initializing!private! !
signal!process synchronisation!public! !
wait!process synchronisation!public! !
!

!Kernel.ModalMsgLoop class methodsFor!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !
!Kernel.ModalMsgLoop class categoriesForMethods!
new!instance creation!public! !
!

