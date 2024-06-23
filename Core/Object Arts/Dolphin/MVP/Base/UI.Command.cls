"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Command'
	instanceVariableNames: 'commandDescription receiver undoAction redoAction isBenign'
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Command guid: (Core.GUID fromString: '{87b4c468-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Command comment: 'A Command is used to perform a user interface command as part of the MVP framework. It is effectively a <CommandDescription> that is bound to a particular receiver and its operation can be performed by sending it a #value message.

Command objects come with the additional capablity of being able to optionally undo and redo the command''s action. We assume that the target responsible for executing the command will also have sufficient information to specify how the command should be undone all re-done. The target may get hold of the currently executing command using:

Command current.

An undo operation may be specified using #undoWith: supplying a <nildadicValuable> as its parameter. This valuable is evaluated when #undo is requested. It is important to understand that a redo operation, if required, cannot just be performed by re-executing a Command using #value. This is because many command operations depend on the state of the target that exists when the command is executed (e.g. current selections etc.) and this state may certainly have changed by the time the redo is required. Consequently, if redo support is required, it is necessary for the target to specify exactly how this should be achieved using Command>>#undoWith: and supplying an appropriate <niladicValuable> that, when evaluated, will go ahead and perform the redo.

If undo/redo support has been enabled for a particular <topPresenter> by enabling its command history using #hasCommandHistory:, then the command framework will expect an undo action to be supplied for every command that can be undone. If such an action is not supplied then we assume that all previous undo history has been invalidated and the command history list will be cleared. However, some commands don''t actually change the state of their targets and so can''t be undone. At the same time they don''t invalidate the previous undo history either. For such commands it is necessary to indicate this behaviour to the framework using Command>>beBenign. When the framework sees that a command has been marked as benign, it does not add it to the current Shell''s command history nor does it clear it.

Instance Variables:
	commandDescription		<CommandDescription> specifying the command to be performed.
	receiver			<Object> to which the command will be directed.
	undoAction		<niladicValuable> that, when evaluated, will undo the original command.
	redoAction		<niladicValuable> that, when evaluated, will redo the original command.
	isBenign			<boolean> indicating that a command has had no effect on the receiver''s state.'!

!UI.Command categoriesForClass!MVP-Commands! !

!UI.Command methodsFor!

beBenign
	"Set the receiver to be a benign command"

	isBenign := true!

canRedo
	"Answer true if the effect of the receiver can be redone"

	^redoAction notNil!

canUndo
	"Answer true if the effect of the receiver can be undone"

	^undoAction notNil!

command
	"Answer the command to action when the receiver's value is requested."

	^self commandDescription command!

commandDescription
	"Answer the command description for the receiver."

	^commandDescription!

description
	"Answers a short String description of the receiver's command."

	^self commandDescription description!

isBenign
	"Answer true if the receiver is a benign command, i.e. it does not change the state of the
	command target in any way that is significant. In such cases the command will not invalidate
	any command undo history list even if it does not have an undo action set."

	^isBenign!

isModalCommand
	^self commandDescription isModalCommand!

receiver
	"Answers the command target for the receiver's command."

	^receiver!

receiver: anObject commandDescription: aCommandDescription
	"Private - Initialize the receiver. Sets the command description to aCommandDescription
	and the command target to anObject."

	receiver := anObject.
	commandDescription := aCommandDescription.
	isBenign := false.
!

redo
	"Redo the effect of the receiver. "

	redoAction value!

redoWith: aNiladicValuable
	"Sets the redo action for the receiver to aNiladicValuable"

	redoAction := aNiladicValuable!

undo
	"Undo the effect of the receiver"

	undoAction value!

undoWith: aNiladicValuable
	"Sets the undo action for the receiver to aNiladicValuable"

	undoAction := aNiladicValuable!

value
	"Executes the receiver and answers the result. Maintain the currently executing
	command in the class variable, Current."

	| prior |
	prior := Current.
	Current := self.
	^[self commandDescription performAgainst: self receiver] ensure: [Current := prior]! !

!UI.Command categoriesForMethods!
beBenign!accessing!public! !
canRedo!accessing!public! !
canUndo!accessing!public! !
command!commands!public! !
commandDescription!accessing!public! !
description!accessing!public! !
isBenign!accessing!public! !
isModalCommand!public!testing! !
receiver!accessing!public! !
receiver:commandDescription:!initializing!private! !
redo!operations!public! !
redoWith:!accessing!public! !
undo!operations!public! !
undoWith:!accessing!public! !
value!evaluating!public! !
!

!UI.Command class methodsFor!

current
	"Answers the current instance of the receiver that is being performed"

	^Current!

new
	"Private - Use #receiver:commandDescription:"

	self shouldNotImplement!

onStartup
	Current := nil!

receiver: anObject commandDescription: aCommandDescription
	"Answer an instance of the receiver with aCommandDescription being bound to anObject
	as its command target.."

	^super new receiver: anObject commandDescription: aCommandDescription
! !

!UI.Command class categoriesForMethods!
current!accessing!public! !
new!instance creation!private! !
onStartup!public! !
receiver:commandDescription:!instance creation!public! !
!

