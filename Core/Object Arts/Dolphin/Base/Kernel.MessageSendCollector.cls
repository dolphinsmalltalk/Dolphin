"Filed out from Dolphin Smalltalk"!

Kernel.MessageSendInterpreter
	subclass: #'Kernel.MessageSendCollector'
	instanceVariableNames: 'messages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.MessageSendCollector guid: (Core.GUID fromString: '{f883fe35-9906-4e8c-9ef2-f84400555550}')!

Kernel.MessageSendCollector comment: '`MessageSendCollector` is an `InstructionInterpreter` that collects all the message sends in a method.

## Instance Variables:
  `messages`			`<IdentitySet>`. The collected sent messages.
  `superMessages`		`<IdentitySet>`. The collected supersend messages.

'!

!Kernel.MessageSendCollector categoriesForClass!Kernel-Objects! !

!Kernel.MessageSendCollector methodsFor!

messages
	^messages
		ifNil: 
			[messages := IdentitySet new: method size.
			self interpret.
			messages]!

send: extensionByte
	messages add: (method basicAt: (extensionByte bitAnd: 31) + 1)!

sendSelector: aSymbol args: anInteger 
	messages add: aSymbol!

shortSendOneArg: literalIndex
	messages add: (method basicAt: literalIndex + 1)!

shortSendSelfZeroArgs: anInteger
	"Interpret a Short Send Self [N] with 0 Args instruction."

	messages add: (method basicAt: anInteger + 1)!

shortSendTwoArgs: literalIndex
	messages add: (method basicAt: literalIndex + 1)!

shortSendZeroArgs: literalIndex
	messages add: (method basicAt: literalIndex + 1)!

shortSpecialSend: anInteger
	"Interpret a Short Special Send instruction."

	messages add: (VM selectorOfSpecialSend: anInteger)!

shortSpecialSendEx: anInteger
	"Interpret a Short Special Send instruction."

	messages add: (VM selectorOfSpecialSendEx: anInteger)!

supersend: literalIndex args: argumentCount
	"Private - Interpret a Supersend [N] with M args instruction."

	messages add: (method basicAt: literalIndex + 1)! !

!Kernel.MessageSendCollector categoriesForMethods!
messages!accessing!public! !
send:!instructions-sending!public! !
sendSelector:args:!private! !
shortSendOneArg:!instructions-sending!public! !
shortSendSelfZeroArgs:!instructions-sending!public! !
shortSendTwoArgs:!instructions-sending!public! !
shortSendZeroArgs:!instructions-sending!public! !
shortSpecialSend:!instructions-sending!public! !
shortSpecialSendEx:!instructions-sending!public! !
supersend:args:!interpreting!private! !
!

