"Filed out from Dolphin Smalltalk 7"!

Core.MessageSendAbstract subclass: #'Core.MessageSend'
	instanceVariableNames: 'receiver'
	classVariableNames: 'EmptySend'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageSend guid: (Core.GUID fromString: '{87b4c662-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.MessageSend comment: 'A MessageSend is a fully closed <Message>, including receiver object, the message selector, and an array of sufficient arguments.

When evaluated with additional arguments the supplied arguments supplant those stored in the MessageSend itself by replacement from the right.

Instance Variables:
	receiver		<Object>, the destination of the message when evaluated'!
!Core.MessageSend categoriesForClass!Kernel-Methods! !
!Core.MessageSend methodsFor!

forwardTo: anObject withArguments: anArgumentArray
	"Answer the result of evaluating the receiver replacing the stored arguments 
	with those from the <Array>, anArgumentArray, from the right, i.e. if two arguments 
	are supplied for a three argument message then the penultimate and last arguments 
	will be those supplied and the first will come from the stored argument <Array>,
	and then forwarding a message composed of those arguments and the selector stored 
	in the receiver to the <Object>, anObject. If more arguments are supplied than are 
	required for the message, then the extraneous arguments are simply ignored."

	^args isEmpty 
		ifTrue: [anObject perform: selector]
		ifFalse: 
			[| actualArgs argCount |
			actualArgs := args shallowCopy.
			argCount := args basicSize.
			actualArgs 
				replaceFrom: (argCount - anArgumentArray basicSize + 1 max: 1)
				to: argCount
				with: anArgumentArray
				startingAt: 1.
			anObject perform: selector withArguments: actualArgs]!

receiver
	^receiver!

receiver: anObject
	receiver := anObject.
! !
!Core.MessageSend categoriesFor: #forwardTo:withArguments:!evaluating!private! !
!Core.MessageSend categoriesFor: #receiver!accessing!public! !
!Core.MessageSend categoriesFor: #receiver:!accessing!public! !

Core.MessageSend methodProtocol: #messageSend attributes: #() selectors: #()!
Core.MessageSend methodProtocol: #valuable attributes: #(#ansi #readOnly) selectors: #(#argumentCount #valueWithArguments:)!

!Core.MessageSend class methodsFor!

empty
	"Answers an instance of the receiver that does nothing.
	N.B. This is a shared object, and should not be modified."

	EmptySend isNil ifTrue: [
		EmptySend := self receiver: nil selector: #isNil].
	^EmptySend! !
!Core.MessageSend class categoriesFor: #empty!instance creation!public! !

